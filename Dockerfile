FROM python:2.7-alpine

MAINTAINER DCS <dao@daocloud.io> 

RUN apk add --no-cache nginx supervisor

ADD nginx.conf /etc/nginx/nginx.conf

WORKDIR /daocloud

ADD app/requirements.pip /daocloud/

RUN apk add --no-cache --virtual .build-deps  \
		bzip2-dev \
		gcc \
		gdbm-dev \
		libc-dev \
		linux-headers \
		make \
		openssl \
		openssl-dev \
		pax-utils \
		readline-dev \
		sqlite-dev \
		zlib-dev \
	&& pip install --no-cache-dir -r requirements.pip \
	&& apk del .build-deps \
	&& rm -rf /usr/src/python ~/.cache

ADD . /daocloud


ADD ./dist/js/netstats.min.js /daocloud/app/static/js/netstats.min.js
ADD ./dist/index.html /daocloud/app/static/index.html
ADD ./dist/favicon.ico /daocloud/app/static/favicon.ico
ADD ./dist/css/* /daocloud/app/static/css/
ADD ./dist/fonts/* /daocloud/app/static/fonts/
ADD ./dist/js/lib/* /daocloud/app/static/js/lib/

ENV ETH_RPC_ENDPOINT=geth:8545
ENV HUB_ENDPOINT=http://127.0.0.1

EXPOSE 80

CMD [ "/daocloud/entrypoint.sh" ]