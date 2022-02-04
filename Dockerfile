FROM debian:buster-slim
LABEL maintainer="Shawn McBride"
LABEL description="For building an old version of MySQL on my M1 laptop. Mostly cribbed from a very old MySQL release."
LABEL source="https://github.com/docker-library/mysql/commit/15ac8cf4054b5924adb445bd64ceefe33fd664c2#diff-d64b9aeca5ff892d8bee19b7ba43dafd3b9d51ec24cc150fbb3152d5fc40d152"
LABEL version="1.0"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y \
		bison \
		build-essential \
		cmake \
		curl \
        libssl-dev \
		libncurses5-dev

ENV MYSQL_VERSION 5.6.49

RUN mkdir /usr/src/mysql \
	&& curl -SL "https://github.com/mysql/mysql-server/archive/refs/tags/mysql-${MYSQL_VERSION}.tar.gz" \
		| tar -xzC /usr/src/mysql --strip-components=1 \
	&& cd /usr/src/mysql \
	&& cmake . -DCMAKE_BUILD_TYPE=Release \
		-DWITH_EMBEDDED_SERVER=OFF \
	&& make -j"$(nproc)" \
	&& make test \
	&& make install \
	&& cd .. \
	&& rm -rf mysql \
	&& rm -rf /usr/local/mysql/mysql-test \
	&& rm -rf /usr/local/mysql/sql-bench \
	&& find /usr/local/mysql -type f -name "*.a" -delete \
	&& { find /usr/local/mysql -type f -executable -exec strip --strip-all '{}' + || true; }
ENV PATH $PATH:/usr/local/mysql/bin:/usr/local/mysql/scripts

WORKDIR /usr/local/mysql
VOLUME /var/lib/mysql

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]