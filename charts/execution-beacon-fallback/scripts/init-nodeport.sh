#!/bin/sh
set -e

echo "==> Initializing node configuration"
echo "Namespace: ${POD_NAMESPACE}, Pod: ${POD_NAME}"

{{- if or (and .Values.execution.persistence.enabled .Values.execution.initChownData) (and .Values.beacon.persistence.enabled .Values.beacon.initChownData) (.Values.sharedPersistence.enabled) }}
echo "==> Setting up data directory permissions"
mkdir -p /data && chown -R {{ .Values.global.securityContext.runAsUser }}:{{ .Values.global.securityContext.runAsUser }} /data
mkdir -p /data/beacon && chown -R {{ .Values.global.securityContext.runAsUser }}:{{ .Values.global.securityContext.runAsUser }} /data/beacon
{{- end }}

{{- if .Values.p2pNodePort.enabled }}
echo "==> Configuring P2P NodePort"

{{- if eq .Values.p2pNodePort.type "LoadBalancer" }}
echo "==> Waiting for LoadBalancer IP..."
until [ -n "$(kubectl -n ${POD_NAMESPACE} get svc/${POD_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
  echo "Waiting for load balancer to get an IP"
  sleep 10
done

export EXTERNAL_EXECUTION_PORT=$(kubectl -n ${POD_NAMESPACE} get services -l "client=execution,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{.items[0].spec.ports[0].nodePort}')
export EXTERNAL_BEACON_PORT=$(kubectl -n ${POD_NAMESPACE} get services -l "client=beacon,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{.items[0].spec.ports[0].nodePort}')
export EXTERNAL_IP=$(kubectl -n ${POD_NAMESPACE} get svc/${POD_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
{{- else }}
echo "==> Getting NodePort configuration..."
export EXTERNAL_EXECUTION_PORT=$(kubectl get services -l "client=execution,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{.items[0].spec.ports[0].nodePort}')
export EXTERNAL_BEACON_PORT=$(kubectl get services -l "client=beacon,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{.items[0].spec.ports[0].nodePort}')
export EXTERNAL_IP=$(kubectl get nodes "${NODE_NAME}" -o jsonpath='{.status.addresses[?(@.type=="ExternalIP")].address}')
{{- end }}

echo "==> Writing NodePort configuration to /env/init-nodeport"
echo "EXTERNAL_EXECUTION_PORT=$EXTERNAL_EXECUTION_PORT" >  /env/init-nodeport
echo "EXTERNAL_BEACON_PORT=$EXTERNAL_BEACON_PORT" >> /env/init-nodeport
echo "EXTERNAL_IP=$EXTERNAL_IP" >> /env/init-nodeport

echo "==> NodePort configuration:"
cat /env/init-nodeport

{{- if eq .Values.beacon.client "prysm" }}
echo "==> Creating Prysm config.yaml"
touch /data/beacon/config.yaml
echo "p2p-host-ip: $EXTERNAL_IP" > /data/beacon/config.yaml
echo "p2p-tcp-port: $EXTERNAL_BEACON_PORT" >> /data/beacon/config.yaml
echo "p2p-udp-port: $EXTERNAL_BEACON_PORT" >> /data/beacon/config.yaml
echo "Updated Prysm config.yaml file at /data/beacon/config.yaml"
{{- end }}

if [ -f "/data/beacon/config.yaml" ]; then
  echo "==> Beacon client config:"
  cat "/data/beacon/config.yaml"
fi
{{- end }}

echo "==> Initialization complete"
