# SFML Dependencies

[SFML](https://www.sfml-dev.org/) has a number of different dependencies. This repository should help to rebuild all the dependencies by pulling together all the source code repositories and providing the right tools and instructions to do so.

## Dependencies

| Name                                                   | Version            | Repository                                             |
|--------------------------------------------------------|--------------------|--------------------------------------------------------|
| [ogg](http://www.vorbis.com/)                          | v1.3.5             | `https://github.com/xiph/ogg.git`                      |
| [flac](https://xiph.org/flac/)                         | 1.3.4              | `https://github.com/xiph/flac.git`                     |
| [vorbis](http://www.vorbis.com/)                       | v1.3.7             | `https://github.com/xiph/vorbis.git`                   |
| [opus](https://xiph.org/flac/)                         | v1.3.1             | `https://github.com/xiph/opus.git`                     |
| [opusfile](https://github.com/xiph/opusfile)           | v0.12              | `https://github.com/xiph/opusfile.git`                 |
| [freetype2](https://www.freetype.org/)                 | VER-2-12-1         | `https://gitlab.freedesktop.org/freetype/freetype.git` | 
| [openal-soft](http://kcat.strangesoft.net/openal.html) | openal-soft-1.21.0 | `https://github.com/kcat/openal-soft.git`              |
| [stb_*](https://github.com/nothings/stb)               | master             | `https://github.com/nothings/stb.git`                  |

## Building

All the necessary steps are described on the [repository wiki](https://github.com/eXpl0it3r/SFML-dependencies/wiki).

## Custom Scripts

Until they're fully integrated into the setup here, I've add the scripts that have been used to generate the dependency frameworks for macOS and iOS.

- [macOS-dependencies.sh](macOS-dependencies.sh)
- [iOS-dependencies.sh](iOS-dependencies.sh)