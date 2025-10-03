#!/bin/sh
set -e  # Exit on error
set -u  # Exit on undefined variable

# Configuration
VALIDATOR_TYPE="${VALIDATOR_TYPE:-lighthouse}"
DATA_DIR="${DATA_DIR:-/data}"

echo "==> Preparing validator data for ${VALIDATOR_TYPE}"

# Create validator-specific directories
case "${VALIDATOR_TYPE}" in
  lighthouse)
    mkdir -p "${DATA_DIR}/lighthouse/validators"
    if [ -f "${DATA_DIR}/validator_definitions.yml" ]; then
      cp "${DATA_DIR}/validator_definitions.yml" "${DATA_DIR}/lighthouse/validators/validator_definitions.yml"
      echo "==> Copied validator_definitions.yml for Lighthouse"
    fi
    ;;
  nimbus)
    mkdir -p "${DATA_DIR}/nimbus"
    echo "==> Created Nimbus directory"
    ;;
  prysm)
    mkdir -p "${DATA_DIR}/prysm"
    echo "==> Created Prysm directory"
    ;;
  teku)
    mkdir -p "${DATA_DIR}/teku"
    echo "==> Created Teku directory"
    ;;
  lodestar)
    mkdir -p "${DATA_DIR}/lodestar"
    echo "==> Created Lodestar directory"
    ;;
  *)
    echo "==> No specific directory setup needed for ${VALIDATOR_TYPE}"
    ;;
esac

# Process signer keys if they exist
if [ -f "${DATA_DIR}/signer_keys.yml" ]; then
  cat "${DATA_DIR}/signer_keys.yml" > "${DATA_DIR}/config"
  echo "==> Created config file from signer_keys.yml"
else
  echo "==> Warning: signer_keys.yml not found"
fi

# Extract and format pubkeys for Lodestar
if [ "${VALIDATOR_TYPE}" = "lodestar" ] && [ -f "${DATA_DIR}/signer_keys.yml" ]; then
  echo "==> Processing keys for Lodestar"
  formatted_content=$(cat "${DATA_DIR}/signer_keys.yml" | grep -o '".*"' | sed -e 's/"//g' | tr ',' '\n')
  echo "$formatted_content" > "${DATA_DIR}/pubkeys.txt"
  echo "{\"externalSigner.pubkeys\": [$(awk '{printf "%s\"%s\"", (NR==1 ? "" : ", "), $0}' "${DATA_DIR}/pubkeys.txt")"]}" > "${DATA_DIR}/rcconfig.json"
  echo "==> Created rcconfig.json for Lodestar"
fi

# Fix Nimbus permissions
if [ "${VALIDATOR_TYPE}" = "nimbus" ]; then
  echo "==> Fixing Nimbus keystore permissions"
  find "${DATA_DIR}/nimbus" -type d -name '0x*' -exec chmod 0600 {}/remote_keystore.json \; 2>/dev/null || true
  echo "==> Nimbus permissions updated"
fi

# Display generated files for debugging (optional)
if [ "${DEBUG:-false}" = "true" ]; then
  echo "==> DEBUG: Listing ${DATA_DIR}"
  ls -lha "${DATA_DIR}" || true

  if [ -f "${DATA_DIR}/config" ]; then
    echo "==> DEBUG: config file contents:"
    cat "${DATA_DIR}/config" || true
  fi

  if [ -f "${DATA_DIR}/proposerConfig.json" ]; then
    echo "==> DEBUG: proposerConfig.json contents:"
    cat "${DATA_DIR}/proposerConfig.json" || true
  fi

  if [ -f "${DATA_DIR}/proposerConfig.yaml" ]; then
    echo "==> DEBUG: proposerConfig.yaml contents:"
    cat "${DATA_DIR}/proposerConfig.yaml" || true
  fi

  if [ -f "${DATA_DIR}/rcconfig.json" ]; then
    echo "==> DEBUG: rcconfig.json contents:"
    cat "${DATA_DIR}/rcconfig.json" || true
  fi
fi

echo "==> Preparation complete"
