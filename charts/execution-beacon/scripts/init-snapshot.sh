#!/bin/sh
set -e

echo "==> Initializing Reth snapshot download"
echo "Namespace: ${POD_NAMESPACE}, Pod: ${POD_NAME}"

{{- if and (eq .Values.execution.client "reth") .Values.execution.snapshot.enabled }}

# Install required packages
echo "==> Installing required packages..."
apk add --no-cache curl lz4 zstd tar gzip > /dev/null 2>&1

# Check if data directory already has data
if [ -d "/data/execution/db" ] && [ "$(ls -A /data/execution/db 2>/dev/null)" ]; then
  {{- if .Values.execution.snapshot.force }}
  echo "==> WARNING: Data directory exists but force flag is enabled. Backing up existing data..."
  BACKUP_DIR="/data/execution/db-backup-$(date +%s)"
  mv /data/execution/db "$BACKUP_DIR"
  echo "==> Existing data backed up to $BACKUP_DIR"
  {{- else }}
  echo "==> Data directory already exists and is not empty. Skipping snapshot download."
  echo "==> Set execution.snapshot.force=true to force download and backup existing data."
  exit 0
  {{- end }}
fi

echo "==> Creating target directory structure"
mkdir -p /data/execution/db
mkdir -p /tmp/snapshot-extract

{{- if .Values.execution.snapshot.url }}
echo "==> Downloading and extracting snapshot from: {{ .Values.execution.snapshot.url }}"
echo "==> Target directory: /data/execution/db"

# Determine compression type from URL
SNAPSHOT_URL="{{ .Values.execution.snapshot.url }}"
COMPRESSION=""

if echo "$SNAPSHOT_URL" | grep -q '\.tar\.lz4$'; then
  COMPRESSION="lz4"
elif echo "$SNAPSHOT_URL" | grep -q '\.tar\.zst$'; then
  COMPRESSION="zstd"
elif echo "$SNAPSHOT_URL" | grep -q '\.tar\.gz$'; then
  COMPRESSION="gzip"
elif echo "$SNAPSHOT_URL" | grep -q '\.tar$'; then
  COMPRESSION="none"
else
  echo "==> ERROR: Unable to determine compression type from URL"
  echo "==> Supported formats: .tar.lz4, .tar.zst, .tar.gz, .tar"
  exit 1
fi

echo "==> Detected compression: $COMPRESSION"
echo "==> Starting download... (this may take a while for large snapshots)"

# Download and extract based on compression type
# Using -L to follow redirects, --fail to exit on HTTP errors, --progress-bar for visual feedback
case "$COMPRESSION" in
  lz4)
    echo "==> Downloading and extracting (lz4)..."
    curl -L --fail --progress-bar "$SNAPSHOT_URL" | lz4 -d | tar -xf - -C /data/execution/db
    RESULT=$?
    ;;
  zstd)
    echo "==> Downloading and extracting (zstd)..."
    curl -L --fail --progress-bar "$SNAPSHOT_URL" | zstd -d | tar -xf - -C /data/execution/db
    RESULT=$?
    ;;
  gzip)
    echo "==> Downloading and extracting (gzip)..."
    curl -L --fail --progress-bar "$SNAPSHOT_URL" | tar -xzf - -C /data/execution/db
    RESULT=$?
    ;;
  none)
    echo "==> Downloading and extracting (uncompressed)..."
    curl -L --fail --progress-bar "$SNAPSHOT_URL" | tar -xf - -C /data/execution/db
    RESULT=$?
    ;;
esac

if [ $RESULT -eq 0 ]; then
  echo "==> Snapshot downloaded and extracted successfully"
  echo "==> Data directory contents:"
  ls -lah /data/execution/db
  echo "==> Disk usage:"
  du -sh /data/execution/db
else
  echo "==> ERROR: Failed to download or extract snapshot (exit code: $RESULT)"
  echo "==> Please check:"
  echo "    1. Network connectivity to snapshot URL"
  echo "    2. Available disk space"
  echo "    3. Snapshot URL is accessible and valid"
  exit 1
fi
{{- else }}
echo "==> ERROR: execution.snapshot.url is not set"
exit 1
{{- end }}

echo "==> Setting correct permissions"
chown -R {{ .Values.global.securityContext.runAsUser }}:{{ .Values.global.securityContext.runAsUser }} /data/execution

{{- end }}

echo "==> Snapshot initialization complete"
