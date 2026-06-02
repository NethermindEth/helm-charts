#!/bin/sh
set -e

# --- Logging helpers ----------------------------------------------------------
# Emits: <UTC timestamp> [LEVEL] message
# INFO -> stdout, WARN/ERROR -> stderr (both surface in `kubectl logs`).
log() {
  _level="$1"
  shift
  printf '%s [%-5s] %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$_level" "$*"
}
info()  { log INFO "$@"; }
warn()  { log WARN "$@" >&2; }
error() { log ERROR "$@" >&2; }
# Log each line of a file with an INFO prefix and indentation.
log_file() {
  while IFS= read -r _line; do
    info "  $_line"
  done < "$1"
}
# ------------------------------------------------------------------------------

info "Initializing node configuration"
info "Namespace: ${POD_NAMESPACE}, Pod: ${POD_NAME}"

{{- if or (and .Values.execution.persistence.enabled .Values.execution.initChownData) (and .Values.beacon.persistence.enabled .Values.beacon.initChownData) (.Values.sharedPersistence.enabled) }}
info "Setting up data directory permissions"
mkdir -p /data && chown -R {{ .Values.global.securityContext.runAsUser }}:{{ .Values.global.securityContext.runAsUser }} /data
mkdir -p /data/beacon && chown -R {{ .Values.global.securityContext.runAsUser }}:{{ .Values.global.securityContext.runAsUser }} /data/beacon
{{- end }}

{{- if .Values.p2pNodePort.enabled }}
info "Configuring P2P NodePort (type: {{ .Values.p2pNodePort.type }})"

{{- if eq .Values.p2pNodePort.type "LoadBalancer" }}
info "Waiting for LoadBalancer IP..."
until [ -n "$(kubectl -n ${POD_NAMESPACE} get svc/${POD_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
  warn "LoadBalancer has no IP yet, waiting..."
  sleep 10
done

export EXTERNAL_EXECUTION_PORT=$(kubectl -n ${POD_NAMESPACE} get services -l "client=execution,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{.items[0].spec.ports[0].nodePort}')
export EXTERNAL_BEACON_PORT=$(kubectl -n ${POD_NAMESPACE} get services -l "client=beacon,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{.items[0].spec.ports[0].nodePort}')
export EXTERNAL_IP=$(kubectl -n ${POD_NAMESPACE} get svc/${POD_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
info "Resolved LoadBalancer IP: ${EXTERNAL_IP}"
{{- else }}
info "Discovering NodePort services..."
RETRIES=30
RETRY_INTERVAL=5
i=0
until [ $i -ge $RETRIES ]; do
  EXTERNAL_EXECUTION_PORT=$(kubectl get services -l "client=execution,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{range .items[*]}{.spec.ports[0].nodePort}{end}' 2>/dev/null || true)
  EXTERNAL_BEACON_PORT=$(kubectl get services -l "client=beacon,pod in (${POD_NAME}), type in (p2p)" -o jsonpath='{range .items[*]}{.spec.ports[0].nodePort}{end}' 2>/dev/null || true)
  if [ -n "$EXTERNAL_EXECUTION_PORT" ] && [ -n "$EXTERNAL_BEACON_PORT" ]; then
    info "NodePort services found (execution: ${EXTERNAL_EXECUTION_PORT}, beacon: ${EXTERNAL_BEACON_PORT})"
    break
  fi
  i=$((i + 1))
  warn "NodePort services not ready yet, retrying in ${RETRY_INTERVAL}s... (${i}/${RETRIES})"
  sleep $RETRY_INTERVAL
done
if [ -z "$EXTERNAL_EXECUTION_PORT" ] || [ -z "$EXTERNAL_BEACON_PORT" ]; then
  error "Failed to get NodePort configuration after ${RETRIES} attempts"
  exit 1
fi
export EXTERNAL_EXECUTION_PORT
export EXTERNAL_BEACON_PORT
export EXTERNAL_IP=$(kubectl get nodes "${NODE_NAME}" -o jsonpath='{.status.addresses[?(@.type=="ExternalIP")].address}')
info "Resolved node ExternalIP: ${EXTERNAL_IP:-<none>}"
{{- end }}

info "Writing NodePort configuration to /env/init-nodeport"
echo "EXTERNAL_EXECUTION_PORT=$EXTERNAL_EXECUTION_PORT" >  /env/init-nodeport
echo "EXTERNAL_BEACON_PORT=$EXTERNAL_BEACON_PORT" >> /env/init-nodeport
echo "EXTERNAL_IP=$EXTERNAL_IP" >> /env/init-nodeport

info "NodePort configuration:"
log_file /env/init-nodeport

{{- if eq .Values.beacon.client "prysm" }}
info "Creating Prysm config.yaml"
touch /data/beacon/config.yaml
echo "p2p-host-ip: $EXTERNAL_IP" > /data/beacon/config.yaml
echo "p2p-tcp-port: $EXTERNAL_BEACON_PORT" >> /data/beacon/config.yaml
echo "p2p-udp-port: $EXTERNAL_BEACON_PORT" >> /data/beacon/config.yaml
info "Updated Prysm config.yaml at /data/beacon/config.yaml"
{{- end }}

if [ -f "/data/beacon/config.yaml" ]; then
  info "Beacon client config:"
  log_file /data/beacon/config.yaml
fi
{{- end }}

info "Initialization complete"
