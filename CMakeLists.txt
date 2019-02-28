cmake_minimum_required(VERSION 3.7.2)

project(SFML-dependencies)

# Easy ones with cmake support first
add_subdirectory(freetype2)
add_subdirectory(ogg)
add_subdirectory(openal-soft)

# vorbis requires these ogg variables to be set
set(OGG_LIBRARIES $<TARGET_FILE:ogg>) 
set(OGG_INCLUDE_DIRS $<TARGET_PROPERTY:ogg,INCLUDE_DIRECTORIES>)
add_subdirectory(vorbis)