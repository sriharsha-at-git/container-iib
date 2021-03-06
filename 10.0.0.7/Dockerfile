FROM ubuntu:16.04

LABEL MAINTAINER "Sriharsha Vedurada <sriharsha@inthubss.com>"

# Install curl
RUN apt-get update && \
    apt-get install -y curl

# Install IIB V10 .. Fixpack 7 - Developer edition
RUN mkdir /opt/ibm && \
    curl http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/10.0.0.7-IIB-LINUX64-DEVELOPER.tar.gz \
    | tar zx --exclude iib-10.0.0.7/tools --directory /opt/ibm && \
    /opt/ibm/iib-10.0.0.7/iib make registry global accept license silently

# Configure system
COPY kernel_settings.sh /tmp/
RUN echo "IIB_10:" > /etc/debian_chroot  && \
    touch /var/log/syslog && \
    chown syslog:adm /var/log/syslog && \
    chmod +x /tmp/kernel_settings.sh;sync && \
    /tmp/kernel_settings.sh


# Create user to run as
RUN useradd --create-home --home-dir /home/iibuser -G mqbrkrs,sudo iibuser

# Increase security
RUN sed -i 's/sha512/sha512 minlen=8/'  /etc/pam.d/common-password && \
    sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t1/'  /etc/login.defs && \
    sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/'  /etc/login.defs

# Copy in script files
COPY create_runtime.sh /usr/local/bin/
COPY check_license.sh /usr/local/bin/
COPY source_profile.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/source_profile.sh

# Expose default admin port and http port
EXPOSE 4414 7800

USER iibuser

# Set entrypoint to run management script
ENTRYPOINT ["create_runtime.sh"]
