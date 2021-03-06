cmake_minimum_required(VERSION 3.7.2)

project(SFML-dependencies)

# Disable harfbuzz for freetype
set(WITH_HarfBuzz FALSE)

message(STATUS "Configuring freetype2")
add_subdirectory(freetype2)

message(STATUS "Configuring ogg")
add_subdirectory(ogg)

# openal-soft is provided by emscripten so we don't need to build
# It also builds the extras by default, so disable them
if (NOT EMSCRIPTEN AND NOT IOS)
    set(ALSOFT_UTILS OFF CACHE BOOL "")
    set(ALSOFT_EXAMPLES OFF CACHE BOOL "")
    set(ALSOFT_TESTS OFF CACHE BOOL "")

    message(STATUS "Configuring openal-soft")
    add_subdirectory(openal-soft)

    # Ensure -fcommon is used
    # - https://gcc.gnu.org/gcc-10/porting_to.html#common
    # - https://github.com/kcat/openal-soft/issues/519
    # - https://reviews.llvm.org/D75056
    if (CMAKE_C_COMPILER_ID STREQUAL "Clang" OR (CMAKE_C_COMPILER_ID STREQUAL "GNU" AND CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 10))
        target_compile_options(OpenAL PRIVATE -fcommon)
    endif()
endif()

# Set variables used by vorbis and flac to find ogg
set(OGG_LIBRARY $<TARGET_FILE:ogg>)
set(OGG_INCLUDE_DIR $<TARGET_PROPERTY:ogg,INCLUDE_DIRECTORIES>)

message(STATUS "Configuring vorbis")
add_subdirectory(vorbis)

option(BUILD_EXAMPLES OFF)
option(BUILD_CXXLIBS OFF)

# Use the non pkg-config FindOgg.cmake
file(REMOVE "${CMAKE_SOURCE_DIR}/flac/cmake/FindOgg.cmake")
file(COPY "${CMAKE_SOURCE_DIR}/vorbis/cmake/FindOgg.cmake" "${CMAKE_SOURCE_DIR}/flac/cmake")

set(OGG_LIBRARIES $<TARGET_FILE:ogg>)
set(OGG_INCLUDE_DIRS $<TARGET_PROPERTY:ogg,INCLUDE_DIRECTORIES>)

message(STATUS "Configuring flac")
add_subdirectory(flac)