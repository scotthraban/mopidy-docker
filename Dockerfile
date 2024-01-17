FROM alpine:3.19

USER root
WORKDIR /

# To be set if there is a need to run the user with a specific PID
ARG UID=100

RUN apk --no-cache upgrade && \
    apk add --no-cache dumb-init py3-pip mopidy && \
    rm -rf /tmp/*

# shadow used to add usermod, to allow changing the UID of the mopidy user, only needed if setting UID build arg
RUN apk --no-cache upgrade && \
    apk add --no-cache shadow && \
    rm -rf /tmp/*

# sudo/bash to allow iris to execute local scan, so only needed if Mopidy-Iris and Mopidy-Local are both installed
RUN apk --no-cache upgrade && \
    apk add --no-cache sudo bash && \
    rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENV DATA_DIR=/var/lib/mopidy
WORKDIR $DATA_DIR

COPY requirements.txt .
RUN python3 -m pip install --no-cache --upgrade --break-system-packages pip && \
    python3 -m pip install --no-cache --upgrade --break-system-packages -r requirements.txt

RUN addgroup mopidy audio && \
    addgroup mopidy wheel && \
    usermod -u $UID mopidy && \
    chown mopidy:audio -R $DATA_DIR /entrypoint.sh

# The sudoers bit only needed if Mopidy-Iris and Mopidy-Local are both installed, see above
RUN echo "mopidy ALL=(ALL) NOPASSWD: /usr/lib/python3.11/site-packages/mopidy_iris/system.sh" >> /etc/sudoers

USER mopidy:audio

EXPOSE 6600 6680

ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint.sh"]
CMD ["mopidy"]
