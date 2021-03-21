#!/usr/bin/env fish
##
## build ogg, vorbis, vorbisfile, vorbisenc and flac frameworks
##

set OUTPUT (pwd)/trace.log
rm -f $OUTPUT

function assert
    if test $argv[1] -ne 0
        echo "ERROR, see $OUTPUT for more details"
        exit 1
    end
end

rm -rf tmp
mkdir tmp
pushd tmp

### Initial setup

set URLS http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.xz http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.xz https://svn.xiph.org/releases/flac/flac-1.3.2.tar.xz
echo -n "DOWNLOADING LIBRARIES..."
for url in $URLS
    wget --quiet $url >> $OUTPUT ^&1
    assert $status
end
echo "[DONE]"

for ARCHIVE in *.tar.xz
    tar -xf $ARCHIVE
    assert $status
end


set PREFIX_BASE (pwd)/root


function makeIt
    make clean >> $OUTPUT ^&1
    assert $status
    make >> $OUTPUT ^&1
    assert $status
    make install >> $OUTPUT ^&1
    assert $status
end


function buildThem # arch, ios_min_version, ios_sdk_path[, host]
    set ARCH $argv[1]
    set IOS_MIN_VER $argv[2]
    set IOS_SDK_PATH $argv[3]

    if test (count $argv) -ge 4
        set HOST $argv[4]
    else
        set HOST
    end

    set IOS_SDK --sysroot=$IOS_SDK_PATH -isystem $IOS_SDK_PATH/usr/include

    mkdir -p $PREFIX_BASE/$ARCH
    set PREFIX $PREFIX_BASE/$ARCH
    set FLAGS -arch $ARCH $IOS_MIN_VER $IOS_SDK

    ### OGG

    pushd libogg*

        echo -n "BUILDING ogg for $ARCH..."

        ./configure --prefix="$PREFIX" $HOST --enable-shared=yes --enable-static=yes CFLAGS="$FLAGS" CPPFLAGS="$FLAGS" >> $OUTPUT ^&1
        assert $status

        makeIt

        echo "[DONE]"

    popd


    ### VORBIS

    pushd libvorbis*

        echo -n "BUILDING libvorbis for $ARCH..."

        ./configure --prefix="$PREFIX" $HOST --enable-shared=yes --enable-static=yes --with-ogg="$PREFIX" CFLAGS="$FLAGS" CPPFLAGS="$FLAGS" >> $OUTPUT ^&1
        assert $status

        makeIt

        echo "[DONE]"

    popd


    ### FLAC

    pushd flac*

        echo -n "BUILDING flac for $ARCH..."

        ./configure --prefix="$PREFIX" $HOST --enable-shared=yes --enable-static=yes --with-ogg="$PREFIX" --disable-cpplibs CFLAGS="$FLAGS -DGWINSZ_IN_SYS_IOCTL" CPPFLAGS="$FLAGS" >> $OUTPUT ^&1
        assert $status

        makeIt

        echo "[DONE]"

    popd

end


set SDK_SIMULATOR "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator8.0.sdk"
set SDK_DEVICE "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.0.sdk"
set ARCHS_SIMULATOR i386 x86_64
set ARCHS_DEVICE armv7 armv7s arm64
set ARCHS $ARCHS_SIMULATOR $ARCHS_DEVICE

for ARCH in $ARCHS_SIMULATOR
    buildThem $ARCH "-mios-simulator-version-min=4.3" $SDK_SIMULATOR
end

for ARCH in $ARCHS_DEVICE
    buildThem $ARCH "-miphoneos-version-min=4.3" $SDK_DEVICE "--host=arm-apple-darwin"
end


mkdir universal
cp -R root/i386/* universal
rm -fR universal/lib/* universal/bin

for LIB in libFLAC libogg libvorbis libvorbisenc libvorbisfile
    echo -n "GENERATING $LIB"
    for EXT in a dylib
        lipo root/{$ARCHS}/lib/$LIB.$EXT -create -output universal/lib/$LIB.$EXT
        assert $status
    end
    echo "[DONE]"
end


exit 0