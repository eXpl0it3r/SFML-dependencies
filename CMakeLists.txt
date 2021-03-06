cmake_minimum_required(VERSION 3.7.2)

project(SFML-dependencies)

# Disable harfbuzz for freetype
set(WITH_HarfBuzz FALSE)
add_subdirectory(freetype2)

# No extra configuration for ogg
add_subdirectory(ogg)

# openal-soft is provided by emscripten so we don't need to build
# It also builds the extras by default, so disable them
if (NOT EMSCRIPTEN AND NOT IOS)
    set(ALSOFT_UTILS OFF CACHE BOOL "")
    set(ALSOFT_EXAMPLES OFF CACHE BOOL "")
    set(ALSOFT_TESTS OFF CACHE BOOL "")
    add_subdirectory(openal-soft)
endif()

# vorbis requires these ogg variables to be set
set(OGG_LIBRARIES $<TARGET_FILE:ogg>) 
set(OGG_INCLUDE_DIRS $<TARGET_PROPERTY:ogg,INCLUDE_DIRECTORIES>)
add_subdirectory(vorbis)

# No extra configuration for flac
set(OGG_LIBRARY $<TARGET_FILE:ogg>) 
set(OGG_INCLUDE_DIR $<TARGET_PROPERTY:ogg,INCLUDE_DIRECTORIES>)
add_subdirectory(flac)