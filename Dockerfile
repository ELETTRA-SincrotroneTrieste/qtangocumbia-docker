FROM debian:unstable
RUN echo 'deb http://deb.debian.org/debian experimental main' > /etc/apt/sources.list.d/experimental.list

# Update the repo info 
RUN apt-get update

# change installation dialogs policy to noninteractive
# otherwise debconf raises errors: unable to initialize frontend: Dialog

ENV DEBIAN_FRONTEND noninteractive


# install and configure supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

RUN apt-get install -y procps 

RUN apt-get install -y default-mysql-server

RUN apt-get install -y tango-db  liblog4tango-dev libtango-dev

RUN apt-get install -y tango-test

RUN apt-get install -y git vim xvfb x11-apps

#
# Qt, designer, qtcreator, Qwt libraries for plots
#
RUN apt-get install -y qt5-default libqwt-qt5-6 libqwt-qt5-dev libqt5x11extras5 libqt5x11extras5-dev libqt5designercomponents5 qttools5-dev  qttools5-dev-tools libxmu-dev qtscript5-dev qtcreator qml-module-qtcharts qml-module-qtquick-controls2 qml-module-qtquick-dialogs qml-module-qtquick-extras qml-module-qtquick-scene2d qml-module-qtquick-scene3d qml-module-qtquick-templates2 qtdeclarative5-dev libqt5charts5-dev qtcharts5-examples qtcharts5-doc-html


# Java
#
RUN apt-get install -y net-tools openjdk-11-jre-headless openjdk-11-jdk

# Tools to generate documentation
RUN apt-get install -y doxygen graphviz 

# Autotools, build tools
RUN apt-get install  -y build-essential autoconf libtool  ninja-build meson 

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

WORKDIR /var/lib

RUN mkdir cppqtclients

WORKDIR /var/lib/cppqtclients

RUN git clone https://github.com/ELETTRA-SincrotroneTrieste/cumbia-libs.git

WORKDIR /var/lib/cppqtclients/cumbia-libs

# REMOVE THIS 
RUN git pull && echo OK && echo OK && echo OK

RUN ./scripts/cubuild.sh tango install

#RUN autoconf && libtoolize && automake --add-missing 
#RUN ./configure --prefix=/usr/local --includedir=/usr/local/include/cumbia
#RUN make -j4 && make install


# REMOVE THIS
#RUN git pull && echo OK

#WORKDIR /var/lib/cppqtclients/cumbia-tango
#RUN autoconf && libtoolize && automake --add-missing
#RUN ./configure --prefix=/usr/local --includedir=/usr/local/include/cumbia-tango
#RUN make -j4 && make install



#WORKDIR /var/lib/cppqtclients/cumbia-qtcontrols

# REMOVE THIS
#RUN git pull && echo OK 

#RUN qmake && make -j5 && make install

#remove this
#RUN git pull && echo OK && echo OK  && echo OK && echo OK

#WORKDIR /var/lib/cppqtclients/qumbia-tango-controls
#RUN qmake && make -j5 && make install

#WORKDIR /var/lib/cppqtclients/qumbia-tango-controls/plugins
#RUN qmake && make -j5 && make install

WORKDIR /var/lib/cppqtclients

#WORKDIR /var/lib/cppqtclients

#RUN git clone https://github.com/ELETTRA-SincrotroneTrieste/qtango.git

# WORKDIR /var/lib/cppqtclients/qtango
# remove this!
# RUN git pull && echo oK && echo OK

# RUN qmake && make -j5 && make install


# configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/

# Jive
RUN mkdir /var/lib/tango-java/
COPY Jive-7.16-jar-with-dependencies.jar /var/lib/tango-java/
COPY jive.sh /usr/local/bin

# copy & untar mysql tango database and change owner to mysql user
ADD tangodb-tiny.tar /var/lib/mysql/
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql /var/run/mysqld
RUN chown -R mysql /var/lib/mysql/tango

# define tango host env var
ENV TANGO_HOST cumbiatest:10000
ENV QT_PLUGIN_PATH /usr/local/cumbia-libs/lib/qumbia-plugins:/usr/local/lib/plugins

# configure virtual monitor env variable
ENV DISPLAY :0.0

RUN useradd -ms /bin/bash dancer

# /usr/local/lib in ld path
COPY cumbialibs.conf /etc/ld.so.conf.d

RUN ldconfig

CMD ["/usr/bin/supervisord"]


