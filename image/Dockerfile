FROM phusion/baseimage:0.9.11
MAINTAINER Tinco Andringa <tinco@phusion.nl>

ENV HOME /root
RUN mkdir /build
ADD . /build
RUN /build/install.sh
ENTRYPOINT /sbin/my_init ---skip-startup-files --skip-runit --main_command
CMD cd /app; passenger start -p 80 --environment=production --min-pool-size 4 --max-pool-size 4 --no-friendly-error-pages --sticky-sessions
EXPOSE 80 443