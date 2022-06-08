FROM debian:stable-slim

ARG arch=amd64
ADD mycloudreve.ini /root/cloudreve/mycloudreve.ini
ADD cloudreve.db /root/cloudreve/cloudreve.db
ADD aria2.conf /root/aria2/aria2.conf
ADD trackers-list-aria2.sh /root/aria2/trackers-list-aria2.sh
ADD run.sh /root/cloudreve/run.sh

RUN apt-get update \
    && apt-get install ssh wget curl aria2 -y

RUN wget -qO cloudreve.tar.gz https://github.com/cloudreve/Cloudreve/releases/download/3.5.3/cloudreve_3.5.3_linux_amd64.tar.gz \
    && wget -qO /root/aria2/dht.dat https://github.com/P3TERX/aria2.conf/raw/master/dht.dat \
    && wget -qO /root/aria2/dht6.dat https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat
    
RUN tar -zxvf cloudreve.tar.gz -C /root/cloudreve
RUN touch /root/aria2/aria2.session /root/aria2/aria2.log
RUN chmod +x /root/cloudreve/cloudreve \
    && chmod +x /root/aria2/trackers-list-aria2.sh \
    && chmod +x /root/cloudreve/run.sh
RUN mkdir -p /root/Download

RUN wget "https://github.com/cokemine/ServerStatus-goclient/releases/latest/download/status-client_linux_${arch}.tar.gz" && \
    tar -zxvf "status-client_linux_${arch}.tar.gz" && \
    mv status-client /usr/local/bin/ && \
    rm -rf status-client* && \
    chmod +x /usr/local/bin/status-client

CMD /root/cloudreve/run.sh
