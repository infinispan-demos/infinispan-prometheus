rm -rf _grafana
mkdir _grafana
pushd _grafana

wget https://raw.githubusercontent.com/openshift/origin/master/examples/grafana/setup-grafana.sh
chmod +x setup.grafana
wget https://raw.githubusercontent.com/openshift/origin/master/examples/grafana/grafana.yaml
wget https://raw.githubusercontent.com/openshift/origin/master/examples/grafana/node-exporter-full-dashboard.json
wget https://raw.githubusercontent.com/openshift/origin/master/examples/grafana/openshift-cluster-monitoring.json

popd
