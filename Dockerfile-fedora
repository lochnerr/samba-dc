FROM fedora:30

LABEL MAINTAINER Richard Lochner, Clone Research Corp. <lochner@clone1.com> \
      org.label-schema.name = "samba-dc" \
      org.label-schema.description = "Samba Active Directory Domain Controller" \
      org.label-schema.vendor = "Clone Research Corp" \
      org.label-schema.usage = "https://github.com/lochnerr/samba-dc" \
      org.label-schema.url = "https://www.samba.org/" \
      org.label-schema.vcs-url = "https://github.com/lochnerr/samba-dc.git"

# Manditory packages:
# samba-dc - the samba domain controller
# samba-client - required by samba.
# samba-winbind - required by samba.
# samba-dc-bind-dlz - required to use the BIND9_DLZ backend.
# krb5-workstation - required by samba.
# bind - named (required to use the BIND9_DLZ backend)
# bind-utils - host (used in provisioning and automated tests)
# iproute - ip (used in provisioning and automated tests)
# tdb-tools - tdbbackup (used to create backup of idmap)
# cifs-utils - mount.cifs (Required when provisioning a slave domain controller to access idmap backup on master)
# procps-ng - ps (Needed to determine if running under systemd)
# wget - wget (used to get current named.cache file from internet)
# hostname - hostname (used in samba-set-vars)

# Useful packages for debugging:
# iputils - ping
# net-tools - ifconfig
# nmap - nmap
# findutils - find
# traceroute - traceroute

RUN dnf -y upgrade \
 && dnf -y install --nodocs \
        samba-dc \
        samba-client \
        samba-winbind \
        samba-dc-bind-dlz \
        krb5-workstation \
        bind \
        bind-utils \
        iproute \
        tdb-tools \
        cifs-utils \
        procps-ng \
        wget \
        hostname \
        iputils \
        net-tools \
        nmap \
        findutils \
        traceroute \
 && dnf -y clean all

# The persistent volume for samba and named.
VOLUME /var/lib/samba

# Use systemd init to bring up services.
CMD [ "/sbin/init" ]

# Copy the script files and other artifacts.
COPY bin/. /usr/local/bin/

# Copy the systemd samba service.
COPY samba-ad-dc.service /usr/lib/systemd/system/

# Do one-time samba configuration.
RUN . /usr/local/bin/samba-configure \
 && samba_configure

# Set systemd stop signal.
STOPSIGNAL SIGRTMIN+3

# Set the build labels.
# Do this last to allow build cacheing during development.
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date = $BUILD_DATE \
      org.label-schema.vcs-ref = $VCS_REF

