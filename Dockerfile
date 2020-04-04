FROM	node:5.12

RUN	groupadd --gid 1000 obyte \
	&& useradd --uid 1000 --gid obyte --shell /bin/bash --create-home obyte

RUN	npm install -g bower grunt-cli

RUN	apt-get update \
	&& apt-get install -y \
		desktop-file-utils \
		libasound2 \
		libgconf-2-4 \
		libgl1-mesa-glx \
		libgtk2.0-0 \
		libgtk-3-0 \
		libnss3 \
		libxss1 \
		libxtst6

ENV	NW_VERSION 0.14.7

RUN	curl -SLO https://dl.nwjs.io/v$NW_VERSION/nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz \
	&& tar xzf nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz -C /usr/local \
	&& ln -s /usr/local/nwjs-sdk-v$NW_VERSION-linux-x64/nw /usr/local/bin/nw \
	&& rm nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz \
	&& chown -R obyte:obyte /usr/local/nwjs-sdk-v$NW_VERSION-linux-x64

ARG	VERSION=3.0.3

RUN	echo "Obyte ${VERSION}dev" > /etc/obyte-release \
	&& mkdir /obyte /home/obyte/.config \
        && chown obyte:obyte /obyte /home/obyte/.config \
        && ln -s /obyte /home/obyte/.config/byteball \
	&& su - obyte -c "git clone https://github.com/byteball/obyte-gui-wallet.git \
		&& cd obyte-gui-wallet \
		&& echo devnet=1 > .env \
		&& bower install -F \
		&& npm install \
		&& grunt \
		&& cp -ir node_modules/sqlite3/lib/binding/node-v*-linux-x64 node_modules/sqlite3/lib/binding/node-webkit-v$NW_VERSION-linux-x64"

VOLUME	/obyte

USER	obyte
WORKDIR	/home/obyte
RUN	mkdir -p .local/share/mime/packages

CMD	["nw", "obyte-gui-wallet"]

