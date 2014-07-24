FROM phusion/baseimage:0.9.11
MAINTAINER Tinco Andringa <tinco@phusion.nl>

ENV HOME /root
RUN mkdir /build
ADD build /build
RUN /build/install.sh

ENTRYPOINT ["/sbin/my_init", "--skip-startup-files", "--skip-runit"]

ADD passenger_start.sh /bin/passenger_start
RUN chmod +x /bin/passenger_start
CMD ["/bin/passenger_start"]

ENV PASSENGER_COMPILE_NATIVE_SUPPORT_BINARY 0
ENV PASSENGER_DOWNLOAD_NATIVE_SUPPORT_BINARY 0

RUN chown -R app:app /app

EXPOSE 80 443
