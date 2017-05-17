FROM alpine:3.5

MAINTAINER Paul Velzeboer

ARG JMETER_VERSION="3.2"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN	${JMETER_HOME}/bin

# Install extra packages
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Europe/Amsterdam"
RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
RUN apk add --update openjdk8-jre tzdata curl unzip bash
# Clean APK cache
RUN rm -rf /var/cache/apk/*

# download and extract JMeter
RUN mkdir -p /tmp/dependencies
COPY apache-jmeter-3.2.tgz  /tmp/dependencies
RUN mkdir -p /opt

RUN tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
    rm -rf /tmp/dependencies

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
