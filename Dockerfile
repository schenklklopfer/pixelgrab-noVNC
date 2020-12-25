FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

#RUN dpkg --add-architecture i386
#RUN apt-get update && apt-get -y install xvfb x11vnc xdotool wget tar supervisor net-tools fluxbox gnupg2
RUN apt-get update

#BUILD pixelgrab
RUN apt-get -y install libgl1-mesa-dev xorg-dev golang git
RUN git clone https://github.com/schenklklopfer/pixelgrab /root/pixelgrab
RUN cd /root/pixelgrab/ && go build

RUN apt-get -y install xvfb x11vnc xdotool wget tar supervisor net-tools gnupg2 python fluxbox xz-utils
RUN apt-get -y full-upgrade && apt-get clean

WORKDIR /root/
RUN wget -O - https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.2.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html
RUN wget -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.9.0 /root/novnc/utils/websockify

ADD ffmpeg /root/ffmpeg

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENV DISPLAY :0

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
