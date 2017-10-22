FROM	node:7.9

RUN	deluser --remove-home node \
	&& groupadd --gid 1000 byteball \
	&& useradd --uid 1000 --gid byteball --shell /bin/bash --create-home byteball

RUN	npm install -g bower grunt-cli

RUN	apt-get update \
	&& apt-get install -y \
		desktop-file-utils \
		libasound2 \
		libgconf-2-4 \
		libgl1-mesa-glx \
		libgtk2.0-0 \
		libnss3 \
		libxss1 \
		libxtst6

ENV	NW_VERSION 0.19.5

RUN	curl -SLO https://dl.nwjs.io/v$NW_VERSION/nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz \
	&& tar xzf nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz -C /usr/local \
	&& ln -s /usr/local/nwjs-sdk-v$NW_VERSION-linux-x64/nw /usr/local/bin/nw \
	&& rm nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz 

ENV	TIMESTAMPER_ADDRESS ZQFHJXFWT2OCEBXF26GFXJU4MPASWPJT
ENV	HUB 172.17.0.1:6611

RUN	echo "Byteball 1.11.1dev" > /etc/byteball-release \
	&& mkdir /byteball /home/byteball/.config \
        && chown byteball:byteball /byteball /home/byteball/.config \
        && ln -s /byteball /home/byteball/.config/byteball \	
	&& su - byteball -c "git clone https://github.com/byteball/byteball.git \
		&& cd byteball \
		&& sed -r -i \
			-e '/TIMESTAMPER_ADDRESS/s/[A-Z0-9]{32}/$TIMESTAMPER_ADDRESS/g' \
			-e 's/byteball.org\/bb(-test)?/$HUB/g' \
			src/js/services/configService.js \
		&& bower install \
		&& npm install --save pmiklos/byteball-devnet-config \
		&& npm install \
		&& ./node_modules/.bin/byteball-devnet-config \
		&& sed -r -i -e '/WS_PROTOCOL/s/wss:/ws:/' node_modules/byteballcore/conf.js \
		&& grunt \
		&& cp -ir node_modules/sqlite3/lib/binding/node-v*-linux-x64 node_modules/sqlite3/lib/binding/node-webkit-v$NW_VERSION-linux-x64"

VOLUME	/byteball

USER	byteball
WORKDIR	/home/byteball

CMD	["nw", "byteball"]

