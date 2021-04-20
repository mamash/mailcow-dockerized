FROM debian:buster-slim

MAINTAINER Filip Hajny <filip@hajny.net>

ENV REPORT_PARSER_SOURCE="https://github.com/techsneeze/dmarcts-report-parser/archive/master.zip"

RUN set -x \
	&& apt-get update \
	&& apt-get install -y libfile-mimeinfo-perl libmail-imapclient-perl libmime-tools-perl \
	    libxml-simple-perl libclass-dbi-mysql-perl libio-socket-inet6-perl \
	    libio-socket-ip-perl libperlio-gzip-perl libmail-mbox-messageparser-perl

RUN set -x \
	&& apt-get install -y cron unzip wget

RUN set -x \
      && wget -q --no-check-certificate -O parser.zip $REPORT_PARSER_SOURCE \
      && unzip parser.zip && cp -v dmarcts-report-parser-master/* /usr/bin/ && rm -f parser.zip

COPY parser /etc/cron.d/parser
COPY dmarcts-report-parser.conf /usr/bin/dmarcts-report-parser.conf
COPY entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
