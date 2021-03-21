#!/usr/bin/env fish
##
## build ogg, vorbis, vorbisfile, vorbisenc and flac frameworks
##

rm -fr build_deps
mkdir -p build_deps
cd build_deps

wget http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.xz
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.xz
wget https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.3.2.tar.xz

for archive in *.tar.xz
    tar -xf $archive
end

wget https://gitlab.freedesktop.org/freetype/freetype/-/archive/VER-2-8/freetype-VER-2-8.tar.gz

for archive in *.tar.gz
    tar -xf $archive
end

wget https://github.com/kcat/openal-soft/archive/refs/heads/v1.19.zip

for archive in *.zip
    unzip $archive
end

set INSTALL_ROOT (pwd)/install/root
mkdir -p $INSTALL_ROOT


### OpenAL Soft

echo ""
echo "=== OpenAL Soft ==="
echo ""

pushd openal-soft*

mkdir -p build/1.19/arm64/root
mkdir -p build/1.19/x86_64/root
mkdir -p build/1.19/universal
set BASE (pwd)/build/1.19/

set PREFIX_64 $BASE/x86_64/root/
set PREFIX_ARM64 $BASE/arm64/root/

echo "--- x86_64 ---"

mkdir -p building/
cd building

set SDK_1015 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/

cmake -G "Unix Makefiles" -DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF -DALSOFT_TESTS=OFF -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_OSX_SYSROOT="$SDK_1015" -DCMAKE_INSTALL_PREFIX="$PREFIX_64" ../
cmake --build . --target clean
cmake --build .
cmake --build . --target install

cd ..
rm -r building/

echo "--- arm64 ---"

mkdir -p building/
cd building

set SDK_110 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk/

cmake -G "Unix Makefiles" -DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF -DALSOFT_TESTS=OFF -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 -DCMAKE_OSX_SYSROOT="$SDK_110" -DCMAKE_INSTALL_PREFIX="$PREFIX_ARM64" ../
cmake --build . --target clean
cmake --build .
cmake --build . --target install

cd ..
rm -r building/

cd build/1.19/universal

cp ../arm64/root/lib/libopenal.1.19.1.dylib libopenal.1.19.1.dylib.arm64
cp ../x86_64/root/lib/libopenal.1.19.1.dylib libopenal.1.19.1.dylib.x86_64
lipo libopenal.1.19.1.dylib.arm64 libopenal.1.19.1.dylib.x86_64 -create -output libopenal.1.19.1.dylib


cp -R ../arm64/root/ $INSTALL_ROOT
cp libopenal.1.19.1.dylib $INSTALL_ROOT/lib
rm $INSTALL_ROOT/lib/libopenal.la

file $INSTALL_ROOT/lib/*

popd

### FreeType

echo ""
echo "=== FreeType ==="
echo ""

pushd freetype*

mkdir -p build/2.8/arm64/root
mkdir -p build/2.8/x86_64/root
mkdir -p build/2.8/universal
set BASE (pwd)/build/2.8/

set PREFIX_64 $BASE/x86_64/root/
set PREFIX_ARM64 $BASE/arm64/root/

./autogen.sh

echo "--- x86_64 ---"

mkdir -p building/
cd building

set SDK_1015 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/

cmake -G "Unix Makefiles" -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_OSX_SYSROOT="$SDK_1015" -DCMAKE_INSTALL_PREFIX="$PREFIX_64" -DBUILD_SHARED_LIBS=ON ../
cmake --build . --target clean
cmake --build .
cmake --build . --target install

cd ..
rm -r building/

echo "--- arm64 ---"

mkdir -p building/
cd building

set SDK_110 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk/

cmake -G "Unix Makefiles" -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 -DCMAKE_OSX_SYSROOT="$SDK_110" -DCMAKE_INSTALL_PREFIX="$PREFIX_ARM64" -DBUILD_SHARED_LIBS=ON ../
cmake --build . --target clean
cmake --build .
cmake --build . --target install

cd ..
rm -r building/

cd build/2.8/universal

cp ../arm64/root/lib/libfreetype.2.8.0.dylib libfreetype.2.8.0.dylib.arm64
cp ../x86_64/root/lib/libfreetype.2.8.0.dylib libfreetype.2.8.0.dylib.x86_64
lipo libfreetype.2.8.0.dylib.arm64 libfreetype.2.8.0.dylib.x86_64 -create -output libfreetype.2.8.0.dylib


cp -R ../arm64/root/ $INSTALL_ROOT
cp libfreetype.2.8.0.dylib $INSTALL_ROOT/lib
rm $INSTALL_ROOT/lib/libfreetype.la

file $INSTALL_ROOT/lib/*

popd


### OGG

echo ""
echo "=== OGG ==="
echo ""

pushd libogg*

mkdir -p build/1.3.3/arm64/root
mkdir -p build/1.3.3/x86_64/root
mkdir -p build/1.3.3/universal
set BASE (pwd)/build/1.3.3/

set PREFIX_64 $BASE/x86_64/root/
set PREFIX_ARM64 $BASE/arm64/root/

echo "--- x86_64 ---"

export MACOSX_DEPLOYMENT_TARGET=10.15
set SDK_1015 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/

./configure --prefix="$PREFIX_64" --enable-shared=yes --enable-static=no CFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15" LDFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15" CPPFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15"
make clean
make
make install

echo "--- arm64 ---"

export MACOSX_DEPLOYMENT_TARGET=11.0
set SDK_110 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk/

./configure --prefix="$PREFIX_ARM64" --enable-shared=yes --enable-static=no CFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0" LDFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0" CPPFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0"
make clean
make
make install

cd build/1.3.3/universal

cp ../arm64/root/lib/libogg.0.dylib libogg.0.dylib.arm64
cp ../x86_64/root/lib/libogg.0.dylib libogg.0.dylib.x86_64
lipo libogg.0.dylib.arm64 libogg.0.dylib.x86_64 -create -output libogg.0.dylib


cp -R ../arm64/root/ $INSTALL_ROOT
cp libogg.0.dylib $INSTALL_ROOT/lib
rm $INSTALL_ROOT/lib/libogg.la

file $INSTALL_ROOT/lib/*

popd


### VORBIS

echo ""
echo "=== VORBIS ==="
echo ""

pushd libvorbis*

mkdir -p build/1.3.6/arm64/root
mkdir -p build/1.3.6/x86_64/root
mkdir -p build/1.3.6/universal
set OGG_ROOT $INSTALL_ROOT
set BASE (pwd)/build/1.3.6/

set PREFIX_32 $BASE/arm64/root/
set PREFIX_64 $BASE/x86_64/root/

echo "--- x86_64 ---"

export MACOSX_DEPLOYMENT_TARGET=10.15
set SDK_1015 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/

./configure --prefix="$PREFIX_64" --enable-shared=yes --enable-static=no --with-ogg="$OGG_ROOT" CFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15" LDFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15" CPPFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15"
make clean
make
make install

echo "--- arm64 ---"

export MACOSX_DEPLOYMENT_TARGET=11.0
set SDK_110 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk/

./configure --prefix="$PREFIX_32" --enable-shared=yes --enable-static=no --with-ogg="$OGG_ROOT" CFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0" LDFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0" CPPFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0"
make clean
make
make install

cd build/1.3.6/universal

cp ../arm64/root/lib/libvorbis.0.dylib  libvorbis.0.dylib.arm64
cp ../x86_64/root/lib/libvorbis.0.dylib  libvorbis.0.dylib.x86_64
cp ../arm64/root/lib/libvorbisfile.3.dylib  libvorbisfile.3.dylib.arm64
cp ../x86_64/root/lib/libvorbisfile.3.dylib  libvorbisfile.3.dylib.x86_64
cp ../arm64/root/lib/libvorbisenc.2.dylib  libvorbisenc.2.dylib.arm64
cp ../x86_64/root/lib/libvorbisenc.2.dylib  libvorbisenc.2.dylib.x86_64
lipo libvorbis.0.dylib.arm64 libvorbis.0.dylib.x86_64 -create -output libvorbis.0.dylib
lipo libvorbisfile.3.dylib.arm64 libvorbisfile.3.dylib.x86_64 -create -output libvorbisfile.3.dylib
lipo libvorbisenc.2.dylib.arm64 libvorbisenc.2.dylib.x86_64 -create -output libvorbisenc.2.dylib

cp -R ../arm64/root/ $INSTALL_ROOT
cp *.dylib $INSTALL_ROOT/lib
rm $INSTALL_ROOT/lib/*.la

file $INSTALL_ROOT/lib/*

popd




### FLAC

echo ""
echo "=== FLAC ==="
echo ""

pushd flac*

mkdir -p build/1.3.2/arm64/root
mkdir -p build/1.3.2/x86_64/root
mkdir -p build/1.3.2/universal

set OGG_ROOT $INSTALL_ROOT
set BASE (pwd)/build/1.3.2/

set PREFIX_32 $BASE/arm64/root/
set PREFIX_64 $BASE/x86_64/root/

echo "--- x86_64 ---"

export MACOSX_DEPLOYMENT_TARGET=10.15
set SDK_1015 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/

./configure --prefix="$PREFIX_64" --enable-shared=yes --enable-static=no --disable-cpplibs --with-ogg="$OGG_ROOT" CFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15" LDFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15" CPPFLAGS="-arch x86_64 --sysroot=$SDK_1015 -mmacosx-version-min=10.15"
make clean
make
make install

echo "--- arm64 ---"

export MACOSX_DEPLOYMENT_TARGET=11.0
set SDK_110 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk/

./configure --prefix="$PREFIX_32" --enable-shared=yes --enable-static=no --disable-cpplibs --with-ogg="$OGG_ROOT" CFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0" LDFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0" CPPFLAGS="-arch arm64 --sysroot=$SDK_110 -mmacosx-version-min=11.0"
make clean
make
make install

cd build/1.3.2/universal/

cp ../arm64/root/lib/libFLAC.8.dylib libFLAC.8.dylib.arm64
cp ../x86_64/root/lib/libFLAC.8.dylib libFLAC.8.dylib.x86_64

lipo *.dylib.* -create -output libFLAC.8.dylib

cp -R ../arm64/root/ $INSTALL_ROOT
cp *dylib $INSTALL_ROOT/lib
rm $INSTALL_ROOT/lib/*.la

file $INSTALL_ROOT/lib/*

popd



### FRAMEWORKS

mkdir frameworks

for lib in openal freetype FLAC ogg vorbis vorbisfile vorbisenc
    cp $INSTALL_ROOT/lib/lib$lib.dylib frameworks/$lib.dylib
end

pushd frameworks

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>
    <key>CFBundleExecutable</key>
    <string>@@LIB@@</string>
    <key>CFBundleIdentifier</key>
    <string>org.sfml-dev.@@LIB@@</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
</dict>
</plist>' > Info.plist.in

function rpath
   echo "@rpath/../Frameworks/$argv.framework/Versions/A/$argv"
end

for f in *.dylib
    set lib (basename $f .dylib)
    rm -fr "$lib.framework"
    mkdir -p "$lib.framework/Versions/A/Resources/"
    cp "$f" "$lib.framework/Versions/A/$lib"
    sed -e "s#@@LIB@@#$lib#" "Info.plist.in" > "$lib.framework/Versions/A/Resources/Info.plist"
    pushd "$lib.framework/Versions"
      ln -s "A" "Current"
      cd ..
      ln -s "Versions/Current/Resources" "Resources"
      ln -s "Versions/Current/$lib"
    popd
end

for f in *.framework
    set lib (echo $f | sed -e 's#\(.*\)\.framework#\1#')
    install_name_tool -id (rpath "$lib") "$lib.framework/Versions/A/$lib"
end

for f in {FLAC,vorbis,vorbisfile,vorbisenc}.framework
    set lib (echo $f | sed -e 's#\(.*\)\.framework#\1#')
    set old (otool -L "$f/$lib" | grep "ogg" | awk '{ print $1 }')
    set new (rpath "ogg")
    install_name_tool -change "$old" "$new" "$f/$lib"
end

for f in {vorbisfile,vorbisenc}.framework
    set lib (echo $f | sed -e 's#\(.*\)\.framework#\1#')
    set old (otool -L "$f/$lib" | grep "libvorbis.0.dylib" | awk '{ print $1 }')
    set new (rpath "vorbis")
    install_name_tool -change "$old" "$new" "$f/$lib"
end

for f in *.framework
    set lib (echo $f | sed -e 's#\(.*\)\.framework#\1#')
    echo "Printing otool -L for $lib.framework"
    otool -L "$f/$lib"
    echo
    echo
end

rm Info.plist.in *.dylib

echo Frameworks are in (pwd)

popd