FROM alpine:3.8
MAINTAINER Stille <stille@ioiox.com>

WORKDIR /
ENV FRP_VERSION 0.36.2

RUN set -xe && \
    apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

RUN set -x && \
	UNAME=$(uname -m) && if [ "$UNAME" = "x86_64" ]; then export PLATFORM=amd64 ; else export PLATFORM=arm64 ; fi && \
	wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${PLATFORM}.tar.gz && \ 
	tar xzf frp_${FRP_VERSION}_linux_${PLATFORM}.tar.gz && \
	cd frp_${FRP_VERSION}_linux_${PLATFORM} && \
	mkdir /frp && \
	mv frps frps.ini /frp && \
	cd .. && \
	rm -rf *.tar.gz frp_${FRP_VERSION}_linux_${PLATFORM}

VOLUME /frp

CMD /frp/frps -c /frp/frps.ini
