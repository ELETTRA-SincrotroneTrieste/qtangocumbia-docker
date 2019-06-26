# qtangocumbia-docker
Docker image with cumbia libraries

#### Linux

Linux version used: *debian testing*

#### Included packages

- supervisor
- git vim 
- tango, tango-db, tango-test mysql-server
- Qt, Qt designer, qtcreator, Qwt libraries for plot
- net-tools openjdk-11-jre-headless openjdk-11-jdk
- build-essential autoconf libtool (build environment)
- doxygen graphwiz (to generate doc)

### Installed libraries

- cumbia-libs from https://github.com/ELETTRA-SincrotroneTrieste/cumbia-libs.git

- qtango from https://github.com/ELETTRA-SincrotroneTrieste/qtango.git

### Install locations

#### cumbia libraries

/var/lib/cppqtclients/cumbia-libs

#### QTango

/var/lib/cppqtclients/qtango
