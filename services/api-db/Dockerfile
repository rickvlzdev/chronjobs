FROM postgres:11.2-alpine

RUN mkdir -p /usr/src/db
WORKDIR /usr/src/db

ADD create.sql /docker-entrypoint-initdb.d
