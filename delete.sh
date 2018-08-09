#!/bin/bash
oc delete all -l fluentd-forwarder
oc delete template fluentd-forwarder
oc delete secret fluentd-forwarder-certs
oc delete dc fluentd-forwarder
oc delete cm fluentd-forwarder
oc delete svc fluentd-forwarder
oc delete is fluentd-forwarder
oc delete is fluentd-forwarder-centos
oc delete template fluentd-forwarder-centos-build
