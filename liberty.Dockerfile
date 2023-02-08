FROM open-liberty:full-java8-openj9

COPY --chown=1001:0 src/main/liberty/config /config

RUN configure.sh