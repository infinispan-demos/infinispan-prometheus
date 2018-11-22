#!/bin/bash

REST_HOST=`oc get route/infinispan-app-http -o jsonpath="{.spec.host}"`
PROMETHEUS_HOST=`oc get route/prometheus -o jsonpath="{.spec.host}"`
CONSOLE_HOST=`oc get route/infinispan-app-management -o jsonpath="{.spec.host}"`

USER="developer"
PASSWORD="developer"


for i in {1..100}
do
   echo "Writing key $i"
curl \
  -u $USER:$PASSWORD \
  -H 'Content-type: text/plain' \
  -d 'value $i' \
  $REST_HOST/rest/default/$i
done


echo "Infinispan REST endpoint at http://$REST_HOST"
echo "Prometheus console at http://$PROMETHEUS_HOST"
echo "Infinispan console at http://$CONSOLE_HOST"
