ECHO off

MKDIR extlibs
MKDIR extlibs\bin
MKDIR extlibs\bin\x86
MKDIR extlibs\bin\x64
MKDIR extlibs\headers
MKDIR extlibs\libs-msvc-universal
MKDIR extlibs\libs-msvc-universal\x86
MKDIR extlibs\libs-msvc-universal\x64

REM OGG

COPY ogg\win32\VS2010\Win32\Release\libogg_static.lib extlibs\libs-msvc-universal\x86\ogg.lib
COPY ogg\win32\VS2010\x64\Release\libogg_static.lib extlibs\libs-msvc-universal\x64\ogg.lib
MKDIR extlibs\headers\ogg
COPY ogg\include\ogg\* extlibs\headers\ogg\
DEL extlibs\headers\ogg\Makefile.am

REM Vorbis

COPY vorbis\win32\VS2010\Win32\Release\libvorbis_static.lib extlibs\libs-msvc-universal\x86\vorbis.lib
COPY vorbis\win32\VS2010\Win32\Release\libvorbisfile_static.lib extlibs\libs-msvc-universal\x86\vorbisfile.lib
COPY vorbis\win32\VS2010\x64\Release\libvorbis_static.lib extlibs\libs-msvc-universal\x64\vorbis.lib
COPY vorbis\win32\VS2010\x64\Release\libvorbisfile_static.lib extlibs\libs-msvc-universal\x64\vorbisfile.lib
MKDIR extlibs\headers\vorbis
COPY vorbis\include\vorbis\* extlibs\headers\vorbis\
DEL extlibs\headers\vorbis\Makefile.am

REM FLAC

COPY flac\objs\release\lib\libFLAC_static.lib extlibs\libs-msvc-universal\x86\flac.lib
COPY flac\objs\x64\Release\lib\libFLAC_static.lib extlibs\libs-msvc-universal\x64\flac.lib
MKDIR extlibs\headers\flac
COPY flac\include\flac\* extlibs\headers\flac\
DEL extlibs\headers\flac\Makefile.am

REM Opus

COPY opus\win32\VS2015\Win32\Release\opus.lib extlibs\libs-msvc-universal\x86\opus.lib
COPY opus\win32\VS2015\x64\Release\opus.lib extlibs\libs-msvc-universal\x64\opus.lib
MKDIR extlibs\headers\opus
COPY opus\include\* extlibs\headers\opus

REM Opusfile

COPY opusfile\win32\VS2010\Win32\Release\opusfile.lib extlibs\libs-msvc-universal\x86\opusfile.lib
COPY opusfile\win32\VS2010\x64\Release\opusfile.lib extlibs\libs-msvc-universal\x64\opusfile.lib
MKDIR extlibs\headers\opus
COPY opusfile\include\* extlibs\headers\opus

REM libjpeg-turbo

COPY libjpeg-turbo\install\x86\lib\jpeg-static.lib extlibs\libs-msvc-universal\x86\jpeg.lib
COPY libjpeg-turbo\install\x64\lib\jpeg-static.lib extlibs\libs-msvc-universal\x64\jpeg.lib
MKDIR extlibs\headers\jpeg
COPY libjpeg-turbo\install\x86\include\* extlibs\headers\jpeg

REM Freetype2

COPY freetype2\install\x86\lib\freetype.lib extlibs\libs-msvc-universal\x86\freetype.lib
COPY freetype2\install\x64\lib\freetype.lib extlibs\libs-msvc-universal\x64\freetype.lib
MKDIR extlibs\headers\freetype2
MKDIR extlibs\headers\freetype2\config
COPY freetype2\install\x86\include\freetype2\freetype\* extlibs\headers\freetype2
COPY freetype2\install\x86\include\freetype2\freetype\config\* extlibs\headers\freetype2\config
COPY freetype2\install\x86\include\freetype2\ft2build.h extlibs\headers\freetype2

REM OpenAL Soft

COPY openal-soft\install\x86\lib\OpenAL32.lib extlibs\libs-msvc-universal\x86\openal32.lib
COPY openal-soft\install\x86\bin\OpenAL32.dll extlibs\bin\x86\openal32.dll
COPY openal-soft\install\x64\lib\OpenAL32.lib extlibs\libs-msvc-universal\x64\openal32.lib
COPY openal-soft\install\x64\bin\OpenAL32.dll extlibs\bin\x64\openal32.dll
MKDIR extlibs\headers\AL
COPY openal-soft\install\x86\include\AL\* extlibs\headers\AL

REM STB

MKDIR extlibs\headers\stb_image
COPY stb\stb_image.h extlibs\headers\stb_image
COPY stb\stb_image_write.h extlibs\headers\stb_image
