FROM fanningert/baseimage-alpine

MAINTAINER fanningert <thomas@fanninger.at>

RUN apk update
RUN apk add bash
# Taiga: Essential packages 
RUN apk add gcc wget autoconf flex bison libjpeg-turbo-dev
RUN apk add freetype-dev zlib-dev zeromq-dev gdbm-dev ncurses-dev
RUN apk add automake libtool libffi-dev curl git tmux gettext
RUN apk add rabbitmq-server redis
# Taiga backend: Python (3.6) and virtualenvwrapper must be installed along with a few third-party libraries
RUN apk add python3 python3-dev py3-virtualenv
RUN apk add libxml2-dev libxslt-dev
RUN apk add openssl-dev libffi-dev

ADD root/ /

RUN chmod -v +x /etc/services.d/*/run /etc/cont-init.d/*

# Create a user named APP, and a virtualhost for RabbitMQ (taiga-events)
RUN rabbitmqctl add_user app PASSWORD_FOR_EVENTS
RUN rabbitmqctl add_vhost app
RUN rabbitmqctl set_permissions -p app app ".*" ".*" ".*"
# Create the logs folder (mandatory)
RUN mkdir -p /home/app/logs

# Download the code
RUN /home/app
RUN git clone https://github.com/taigaio/taiga-back.git taiga-back
RUN cd taiga-back
RUN checkout stable

# Create new virtualenv named taiga
RUN mkvirtualenv -p /usr/bin/python3.6 taiga

# Install dependencies
RUN pip3 install -r requirements.txt

#VOLUME ["/home/app/taiga-back/settings"]



EXPOSE 8000
