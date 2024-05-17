cmake_minimum_required(VERSION 3.7.2)

project(SFML-dependencies)

# Disable harfbuzz for freetype
set(WITH_HarfBuzz FALSE)
message(STATUS "Configuring freetype2")
add_subdirectory(freetype2)

# Don't build tests
set(BUILD_TESTING OFF CACHE BOOL "")
message(STATUS "Configuring ogg")
add_subdirectory(ogg)

# Ensure OGG is found by Vorbis & FLAC
set(OGG_LIBRARY $<TARGET_FILE:Ogg::ogg> CACHE STRING "")
set(OGG_INCLUDE_DIR $<TARGET_PROPERTY:Ogg::ogg,INCLUDE_DIRECTORIES> CACHE STRING "")

# openal-soft is provided by emscripten so we don't need to build
# It also builds the extras by default, so disable them
if (NOT EMSCRIPTEN AND NOT IOS)
    set(ALSOFT_UTILS OFF CACHE BOOL "")
    set(ALSOFT_EXAMPLES OFF CACHE BOOL "")
    set(ALSOFT_TESTS OFF CACHE BOOL "")
    set(CMAKE_DISABLE_FIND_PACKAGE_WindowsSDK ON CACHE BOOL "")

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

# Don't build tests
set(BUILD_TESTING OFF CACHE BOOL "")
message(STATUS "Configuring vorbis")
add_subdirectory(vorbis)

# Don't build C++ library & tests
set(BUILD_CXXLIBS OFF CACHE BOOL "")
set(BUILD_PROGRAMS OFF CACHE BOOL "")
set(BUILD_EXAMPLES OFF CACHE BOOL "")
set(BUILD_DOCS OFF CACHE BOOL "")
set(BUILD_TESTING OFF CACHE BOOL "")
message(STATUS "Configuring flac")
add_subdirectory(flac)