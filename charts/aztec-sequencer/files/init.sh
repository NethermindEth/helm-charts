#!/usr/bin/env bash

echo "Starting init script for pod ${POD_NAME}..."
touch /shared/env

echo "Getting external node ip..."
EXTERNAL_NODE_IP=$(kubectl get node $NODE_NAME -o jsonpath='{.status.addresses[?(@.type=="ExternalIP")].address}')
echo "Getting external node port..."
EXTERNAL_NODE_PORT=$(kubectl get services -l "pod=${POD_NAME},type=p2p" -o jsonpath='{.items[0].spec.ports[0].nodePort}')

echo "EXTERNAL_NODE_IP=${EXTERNAL_NODE_IP}"
echo "EXTERNAL_NODE_PORT=${EXTERNAL_NODE_PORT}"

echo "export EXTERNAL_NODE_IP=${EXTERNAL_NODE_IP}" >> /shared/env
echo "export EXTERNAL_NODE_PORT=${EXTERNAL_NODE_PORT}" >> /shared/env

echo "Getting validator index and exporting private key..."
VALIDATOR_INDEX=$(echo $POD_NAME | awk -F'-' '{print $NF}')
echo "VALIDATOR_INDEX=${VALIDATOR_INDEX}, reading private key from /app/config/validator_keys/${VALIDATOR_INDEX}..."

PRIVATE_KEY=$(cat "/app/config/validator_keys/${VALIDATOR_INDEX}")
echo "export PRIVATE_KEY=${PRIVATE_KEY}" >> /shared/env
echo "Private Key exported"

echo "exporting other env variables..."
echo "export P2P_UDP_ANNOUNCE_ADDR=${EXTERNAL_NODE_IP}:${EXTERNAL_NODE_PORT}" >> /shared/env
echo "export P2P_TCP_ANNOUNCE_ADDR=${EXTERNAL_NODE_IP}:${EXTERNAL_NODE_PORT}" >> /shared/env
echo "export VALIDATOR_PRIVATE_KEY=${PRIVATE_KEY}" >> /shared/env
echo "export SEQ_PUBLISHER_PRIVATE_KEY=${PRIVATE_KEY}" >> /shared/env
echo "export L1_PRIVATE_KEY=${PRIVATE_KEY}" >> /shared/env
echo 'test -z "$PEER_ID_PRIVATE_KEY" && export PEER_ID_PRIVATE_KEY=$(cat /var/lib/aztec/p2p-private-key)' >> /shared/env
echo "Init script finished"
