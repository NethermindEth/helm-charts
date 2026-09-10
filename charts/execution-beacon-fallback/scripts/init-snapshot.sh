#!/bin/sh
set -e

echo "==> Initializing Reth snapshot download"
echo "Namespace: ${POD_NAMESPACE}, Pod: ${POD_NAME}"

{{- if and (eq .Values.execution.client "reth") .Values.execution.snapshot.enabled }}

# Install required packages
echo "==> Installing required packages..."
apk add --no-cache curl lz4 zstd tar gzip pv > /dev/null 2>&1

# Check if data directory already has data
if [ -d "/data/execution/db" ] && [ "$(ls -A /data/execution/db 2>/dev/null)" ]; then
  {{- if .Values.execution.snapshot.force }}
  echo "==> WARNING: Data directory exists but force flag is enabled. Backing up existing data..."
  BACKUP_DIR="/data/execution-backup-$(date +%s)"
  mkdir -p "$BACKUP_DIR"

  if [ -d "/data/execution/db" ]; then
    mv /data/execution/db "$BACKUP_DIR/"
    echo "==> Backed up db/ to $BACKUP_DIR/"
  fi

  if [ -d "/data/execution/static_files" ]; then
    mv /data/execution/static_files "$BACKUP_DIR/"
    echo "==> Backed up static_files/ to $BACKUP_DIR/"
  fi

  echo "==> Existing data backed up to $BACKUP_DIR"
  {{- else }}
  echo "==> Data directory already exists and is not empty. Skipping snapshot download."
  echo "==> Set execution.snapshot.force=true to force download and backup existing data."
  exit 0
  {{- end }}
fi

echo "==> Creating target directory structure"
mkdir -p /data/execution

{{- if .Values.execution.snapshot.url }}
echo "==> Downloading and extracting snapshot from: {{ .Values.execution.snapshot.url }}"
echo "==> Target directory: /data/execution"
echo "==> Archive should contain: db/ and static_files/ directories"

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
echo "==> Starting download and extraction..."
echo "==> Started at: $(date)"
echo ""

# Download and extract based on compression type
# Using pv to show live progress with speed and ETA
# Extracting to /data/execution so archive creates db/ and static_files/ subdirectories
case "$COMPRESSION" in
  lz4)
    echo "==> Downloading and decompressing (lz4)..."
    curl -L --fail -s "$SNAPSHOT_URL" | pv | lz4 -d | tar -xf - -C /data/execution
    RESULT=$?
    ;;
  zstd)
    echo "==> Downloading and decompressing (zstd)..."
    curl -L --fail -s "$SNAPSHOT_URL" | pv | zstd -d | tar -xf - -C /data/execution
    RESULT=$?
    ;;
  gzip)
    echo "==> Downloading and decompressing (gzip)..."
    curl -L --fail -s "$SNAPSHOT_URL" | pv | tar -xzf - -C /data/execution
    RESULT=$?
    ;;
  none)
    echo "==> Downloading (uncompressed)..."
    curl -L --fail -s "$SNAPSHOT_URL" | pv | tar -xf - -C /data/execution
    RESULT=$?
    ;;
esac

echo ""
echo "==> Completed at: $(date)"

if [ $RESULT -eq 0 ]; then
  echo "==> Snapshot downloaded and extracted successfully"
  echo "==> Data directory structure:"
  ls -lah /data/execution
  echo ""

  # Verify expected directories exist
  if [ -d "/data/execution/db" ]; then
    echo "==> ✓ db/ directory found"
    if [ -f "/data/execution/db/mdbx.dat" ]; then
      echo "==> ✓ mdbx.dat database file found"
    fi
  else
    echo "==> ⚠ WARNING: db/ directory not found!"
  fi

  if [ -d "/data/execution/static_files" ]; then
    echo "==> ✓ static_files/ directory found"
  else
    echo "==> ⚠ WARNING: static_files/ directory not found (may be optional depending on snapshot)"
  fi

  echo ""
  echo "==> Total disk usage:"
  du -sh /data/execution
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
