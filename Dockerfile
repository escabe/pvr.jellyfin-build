FROM ubuntu:16.04
COPY . /app
RUN /app/build-docker.sh
CMD /app/dobuilds.sh
VOLUME /output