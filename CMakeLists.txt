cmake_minimum_required(VERSION 3.7.2)

project(SFML-dependencies)

# Disable harfbuzz for freetype
set(WITH_HarfBuzz FALSE)
add_subdirectory(freetype2)

# Don't build tests
set(BUILD_TESTING OFF CACHE BOOL "")
add_subdirectory(ogg)

# Ensure OGG is found by Vorbis & FLAC
set(OGG_LIBRARY $<TARGET_FILE:Ogg::ogg> CACHE BOOL "")
set(OGG_INCLUDE_DIR $<TARGET_PROPERTY:Ogg::ogg,INCLUDE_DIRECTORIES> CACHE BOOL "")

# openal-soft is provided by emscripten so we don't need to build
# It also builds the extras by default, so disable them
if (NOT EMSCRIPTEN AND NOT IOS)
    set(ALSOFT_UTILS OFF CACHE BOOL "")
    set(ALSOFT_EXAMPLES OFF CACHE BOOL "")
    set(ALSOFT_TESTS OFF CACHE BOOL "")

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
add_subdirectory(vorbis)

# flac is still waiting for cmake support
# so we'll roll our own for now
set(FLAC_SRC
    flac/src/libFLAC/bitmath.c
    flac/src/libFLAC/bitreader.c
    flac/src/libFLAC/bitwriter.c
    flac/src/libFLAC/cpu.c
    flac/src/libFLAC/crc.c
    flac/src/libFLAC/fixed.c
    flac/src/libFLAC/float.c
    flac/src/libFLAC/format.c
    flac/src/libFLAC/lpc.c
    flac/src/libFLAC/md5.c
    flac/src/libFLAC/memory.c
    flac/src/libFLAC/metadata_iterators.c
    flac/src/libFLAC/metadata_object.c
    flac/src/libFLAC/ogg_decoder_aspect.c
    flac/src/libFLAC/ogg_encoder_aspect.c
    flac/src/libFLAC/ogg_helper.c
    flac/src/libFLAC/ogg_mapping.c
    flac/src/libFLAC/stream_decoder.c
    flac/src/libFLAC/stream_encoder.c
    flac/src/libFLAC/stream_encoder_framing.c
    flac/src/libFLAC/window.c
)

if (WIN32)
    list (APPEND FLAC_SRC flac/src/share/win_utf8_io/win_utf8_io.c flac/src/libFLAC/windows_unicode_filenames.c)
endif()

add_library(FLAC ${FLAC_SRC})
target_compile_definitions(FLAC PRIVATE "-DPACKAGE_VERSION=\"1.3.2\"" "-DHAVE_LROUND" "-DFLAC__HAS_OGG=0" "-DHAVE_STDINT_H" "-DHAVE_INTTYPES_H" "-DFLAC_API_EXPORTS" "-DFLAC__HAS_X86INTRIN" "-DFLAC__NO_ASM" "DLL_EXPORT")
target_include_directories(FLAC PUBLIC flac/src/libFLAC/include flac/include PRIVATE ${OGG_INCLUDE_DIRS})
target_link_libraries(FLAC ogg)

if (BUILD_SHARED_LIBS)
    target_compile_definitions(FLAC PUBLIC "-DFLAC_API_EXPORTS")
else()
    target_compile_definitions(FLAC PUBLIC "-DFLAC__NO_DLL")
endif()
