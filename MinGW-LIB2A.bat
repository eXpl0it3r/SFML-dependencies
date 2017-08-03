ECHO off

REM Generate MinGW import libraries

MKDIR extlibs\libs-mingw
MKDIR extlibs\libs-mingw\x86
tools\reimp.exe -d extlibs\libs-msvc-universal\x86\openal32.lib
%MINGW_X86%\bin\dlltool.exe -d openal32.def -D extlibs\bin\x86\openal32.dll -k -l extlibs\libs-mingw\x86\libopenal32.a
DEL openal32.def

MKDIR extlibs\libs-mingw
MKDIR extlibs\libs-mingw\x64
tools\reimp.exe -d extlibs\libs-msvc-universal\x64\openal32.lib
%MINGW_X64%\bin\dlltool.exe -d openal32.def -D extlibs\bin\x64\openal32.dll -k -l extlibs\libs-mingw\x64\libopenal32.a
DEL openal32.def
