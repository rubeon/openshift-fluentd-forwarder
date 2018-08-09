# start based on a centos image
FROM ruby

ENV HOME=/opt/app-root/src \
  PATH=/opt/rh/rh-ruby22/root/usr/bin:/opt/app-root/src/bin:/opt/app-root/bin${PATH:+:${PATH}} \
  LD_LIBRARY_PATH=/opt/rh/rh-ruby22/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
  MANPATH=/opt/rh/rh-ruby22/root/usr/share/man:$MANPATH \
  PKG_CONFIG_PATH=/opt/rh/rh-ruby22/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}} \
  XDG_DATA_DIRS=/opt/rh/rh-ruby22/root/usr/share${XDG_DATA_DIRS:+:${XDG_DATA_DIRS}} \
  RUBY_VERSION=2.2 \
  FLUENTD_VERSION=0.12.32 \
  GEM_HOME=/opt/app-root/src \
  DATA_VERSION=1.6.0 \
  TARGET_TYPE=remote_syslog \
  TARGET_HOST=localhost \
  TARGET_PORT=24284 \
  IS_SECURE=yes \
  STRICT_VERIFICATION=yes \
  CA_PATH=/etc/pki/CA/certs/ca.crt \
  CERT_PATH=/etc/pki/tls/certs/local.crt \
  KEY_PATH=/etc/pki/tls/private/local.key \
  KEY_PASSPHRASE= \
  SHARED_KEY=ocpaggregatedloggingsharedkey

LABEL io.k8s.description="Fluentd container for collecting logs from other fluentd instances" \
  io.k8s.display-name="Fluentd Forwarder (${FLUENTD_VERSION})" \
  io.openshift.expose-services="24284:tcp" \
  io.openshift.tags="logging,fluentd,forwarder" \
  name="fluentd-forwarder" \
  architecture=x86_64

RUN apt-get update
RUN apt-get install -y gettext-base libnss-wrapper bc make
RUN gem install -N --conservative --minimal-deps --no-document \
    fluentd:${FLUENTD_VERSION} \
    'activesupport:<5' \
    'public_suffix:<3.0.0' \
    'fluent-plugin-record-modifier:<1.0.0' \
    'fluent-plugin-rewrite-tag-filter:<2.0.0' \
    fluent-plugin-kubernetes_metadata_filter \
    fluent-plugin-rewrite-tag-filter \
    fluent-plugin-secure-forward \
    'fluent-plugin-remote_syslog:<1.0.0' \
    'fluent-plugin-elasticsearch'

# add files
ADD run.sh fluentd.conf.template passwd.template fluentd-check.sh ${HOME}/
ADD common-*.sh /tmp/
ADD deb*.sh /tmp/

# set permissions on files
RUN chmod g+rx ${HOME}/fluentd-check.sh && \
    chmod +x /tmp/*.sh

# execute files and remove when done
RUN /tmp/deb-install.sh && \
    rm -f /tmp/deb-*.sh

# set working dir
WORKDIR ${HOME}

# external port
EXPOSE 24284

CMD ["sh", "run.sh"]
