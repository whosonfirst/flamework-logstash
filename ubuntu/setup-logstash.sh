#!/bin/sh

WHOAMI=`python -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`
WHEREAMI=`dirname $WHOAMI`
ROOT=`dirname $WHEREAMI`

# https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04

sudo apt-get update
sudo apt-get upgrade -y

echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list

sudo apt-get update
sudo apt-get install logstash

LOGSTASH="${ROOT}/logstash/"

if [ ! -f ${LOGSTASH}/flamework-logstash.conf ]
then
    cp ${LOGSTASH}/flamework-logstash.conf.example ${LOGSTASH}/flamework-logstash.conf
fi

if [ -L /etc/logstash/conf.d/flamework-logstash.conf ]
then
    sudo rm /etc/logstash/conf.d/flamework-logstash.conf
fi

if [ -f /etc/logstash/conf.d/flamework-logstash.conf ]
then
    sudo mv /etc/logstash/conf.d/flamework-logstash.conf /etc/logstash/conf.d/flamework-logstash.conf.bak
fi

sudo ln -s ${LOGSTASH}/flamework-logstash.conf /etc/logstash/conf.d/flamework-logstash.conf

if [ ! -d /usr/local/logstash ]
    sudo mkdir /usr/local/logstash
    sudo chown logstash /usr/local/logstash
fi

sudo /etc/init.d/logstash restart
sudo update-rc.d logstash defaults

exit 0
