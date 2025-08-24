FROM postgres:latest

COPY ./init/init.sql /docker-entrypoint-initdb.d/init.sql

RUN mkdir /home/postgres && \
    chown -R postgres:postgres /home/postgres/ && \
    usermod -d /home/postgres postgres

WORKDIR /home/postgres
USER postgres
