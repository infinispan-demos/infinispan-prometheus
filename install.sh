#!/bin/bash


oc login -u system:admin

oc adm policy add-cluster-role-to-user cluster-admin developer
oc login -u developer

oc new-project demo-monitoring

read -n1 -r -p "Let's create Prometheus operator. Press any key to continue..." key

oc apply -f 1-cluster-role-binding.yaml
oc apply -f 2-cluster-role.yaml
oc apply -f 3-prometheus-operator-deployment.yaml
oc apply -f 4-service-account.yaml

# Set permissions for prometheus and its operator
oc adm policy add-scc-to-user privileged -ndemo-monitoring -z prometheus-operator
oc adm policy add-scc-to-user privileged -ndemo-monitoring -z prometheus

read -n1 -r -p "Please wait for Prometheus operator to be deployed. Confirm deployment using 'oc get pods' from another terminal windonw. Once confirmed press any key to proceed with installation..." key

echo "Setting RBAC"

oc apply -f 8-rbac-service-account.yaml
oc apply -f 9-rbac-cluster-roles.yaml
oc apply -f 10-rbac-cluster-role-binding.yaml

echo "Creating service monitors and exposing Prometheus web console..."

oc apply -f 11-service-monitors.yaml
oc apply -f 12-expose-prometheus.yaml

oc create route edge  --service=prometheus

read -n1 -r -p "Now we'll deploy Infinispan cluster and connect it to Prometheus for monitoring. Press any key to continue...." key

echo "Installing Infinispan"

oc create -f infinispan-ephemeral-modified.yaml

INFINISPAN_USER=developer
INFINISPAN_PASSWORD=developer

oc new-app infinispan-ephemeral \
  -p APPLICATION_USER=$INFINISPAN_USER \
  -p APPLICATION_PASSWORD=$INFINISPAN_PASSWORD \
  -p MANAGEMENT_USER=$INFINISPAN_USER \
  -p MANAGEMENT_PASSWORD=$INFINISPAN_PASSWORD \
  -p NAMESPACE=demo-monitoring \
  -p NUMBER_OF_INSTANCES=1

oc expose svc/infinispan-app-http

read -n1 -r -p "Now that Infinispan cluster is booting we'll expose Infinispan metrics to Prometheus. Press any key to continue..." key

oc apply -f 20-service-metrics.yaml
oc expose svc/infinispan-app-metrics

oc apply -f 21-infinispan-service-monitor.yaml 

echo "Installation done! Check all pods and statuses using Openshift CLI or web console."




