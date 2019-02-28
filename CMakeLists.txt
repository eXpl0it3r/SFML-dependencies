cmake_minimum_required(VERSION 3.7.2)

project(SFML-dependencies)

# Easy ones with cmake support first
add_subdirectory(freetype2)
add_subdirectory(ogg)

# openal-soft has cmake, but a load of stuff we dont need
# so lets disable them
set(ALSOFT_UTILS OFF CACHE BOOL "")
set(ALSOFT_EXAMPLES OFF CACHE BOOL "")
set(ALSOFT_TESTS OFF CACHE BOOL "")
add_subdirectory(openal-soft)

# vorbis requires these ogg variables to be set
set(OGG_LIBRARIES $<TARGET_FILE:ogg>) 
set(OGG_INCLUDE_DIRS $<TARGET_PROPERTY:ogg,INCLUDE_DIRECTORIES>)
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

add_library(FLAC ${FLAC_SRC})
target_compile_definitions(FLAC PRIVATE "-DPACKAGE_VERSION=\"1.3.2\"" "-DHAVE_LROUND" "-DFLAC__HAS_OGG=1" "-DHAVE_STDINT_H" "-DHAVE_INTTYPES_H")
target_include_directories(FLAC PRIVATE flac/src/libFLAC/include flac/include ${OGG_INCLUDE_DIRS})
target_link_libraries(FLAC ogg)