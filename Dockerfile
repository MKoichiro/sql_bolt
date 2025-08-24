FROM postgres:latest

# ベースイメージの仕様で、/docker-entrypoint-initdb.d/内の.sqlなどのスクリプトがentrypoint実行時（初回起動時）に実行される
# なお、既存のデータが存在する場合はスキップされる
# db系ベースイメージで似たような仕様あり。特にMongoDBのベースイメージはポスグレとほとんど同様。
COPY ./init/init.sql /docker-entrypoint-initdb.d/init.sql

# postgresは、POSTGRES_USERで命名される、superuser
RUN mkdir /home/postgres && \
    chown -R postgres:postgres /home/postgres/ && \
    usermod -d /home/postgres postgres

WORKDIR /home/postgres
USER postgres
