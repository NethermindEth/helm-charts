#!/bin/sh
set -e

echo "==> Initializing Reth snapshot download"
echo "Namespace: ${POD_NAMESPACE}, Pod: ${POD_NAME}"

{{- if and (eq .Values.execution.client "reth") .Values.execution.snapshot.enabled }}

DATADIR=/data/execution
# Written only after reth download returns successfully. Presence of node data
# alone cannot mean "done", since extraction populates the datadir as it runs.
COMPLETE_MARKER="$DATADIR/.snapshot-complete"

{{- if .Values.execution.snapshot.force }}
echo "==> WARNING: force is enabled."
echo "==> reth download --force will REMOVE db/, rocksdb/, static_files/ and reth.toml"
echo "==> Set execution.snapshot.force=false once the snapshot has landed, otherwise"
echo "==> every pod restart discards the node and downloads the snapshot again."
{{- else }}

if [ -f "$COMPLETE_MARKER" ]; then
  echo "==> Snapshot already downloaded. Nothing to do."
  exit 0
fi

# reth stages each archive under .download-cache/ inside the datadir, so its
# presence means a previous download was interrupted. Re-running resumes it
# (reth download --resumable defaults to true), so do not skip in that case.
if [ -d "$DATADIR/.download-cache" ]; then
  echo "==> Found an interrupted download, resuming"
else
  # Storage v2 splits the datadir into db/ (MDBX), rocksdb/ (indices) and
  # static_files/. Any of them being non-empty here means this node already has
  # data that did not come from a snapshot download, so leave it alone.
  # logs/ is deliberately not checked, it is not node data.
  for dir in db rocksdb static_files; do
    if [ -d "$DATADIR/$dir" ] && [ "$(ls -A "$DATADIR/$dir" 2>/dev/null)" ]; then
      echo "==> $DATADIR/$dir already exists and is not empty. Skipping snapshot download."
      echo "==> Set execution.snapshot.force=true to discard existing data and re-download."
      exit 0
    fi
  done
fi
{{- end }}

mkdir -p "$DATADIR"

echo "==> Starting download at: $(date)"
echo ""

reth download \
  --datadir "$DATADIR" \
  --chain {{ .Values.network }} \
  --{{ .Values.execution.snapshot.profile }} \
  {{- if .Values.execution.snapshot.url }}
  --url {{ .Values.execution.snapshot.url | quote }} \
  {{- end }}
  {{- if .Values.execution.snapshot.force }}
  --force \
  {{- end }}
  {{- range .Values.execution.snapshot.extraFlags }}
  {{ . }} \
  {{- end }}
  --non-interactive

touch "$COMPLETE_MARKER"

echo ""
echo "==> Completed at: $(date)"
echo "==> Data directory structure:"
ls -lah "$DATADIR"
echo ""
echo "==> Total disk usage:"
du -sh "$DATADIR"

echo "==> Setting correct permissions"
chown -R {{ .Values.global.securityContext.runAsUser }}:{{ .Values.global.securityContext.runAsUser }} "$DATADIR"

{{- end }}

echo "==> Snapshot initialization complete"
