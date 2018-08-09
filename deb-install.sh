#!/bin/bash

# get release version
# set home directory
mkdir -p ${HOME} && \

# install gems for target version of fluentd, eventually
# update to fluentd version that matches version deployed
# into openshift
# set up directores so that group 0 can have access like specified in
# https://docs.openshift.com/container-platform/3.7/creating_images/guidelines.html
# https://docs.openshift.com/container-platform/3.7/creating_images/guidelines.html#openshift-specific-guidelines
mkdir -p /etc/fluent
chgrp -R 0 /etc/fluent
chmod -R g+rwX /etc/fluent
chgrp -R 0 ${HOME}
chmod -R g+rwX ${HOME}
chgrp -R 0 /etc/pki
chmod -R g+rwX /etc/pki
mkdir /secrets
chgrp -R 0 /secrets
chmod -R g+rwX /secrets
chgrp -R 0 /var/log
chmod -R g+rwX /var/log
