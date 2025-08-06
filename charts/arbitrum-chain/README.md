# Arbitrum Orbit Chain Helm Chart

This Helm chart deploys an Arbitrum Orbit L2 chain with Blockscout explorer and token bridge on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

1. Add the OffchainLabs Helm repository:
```bash
helm repo add offchainlabs https://charts.arbitrum.io
helm repo update
```

2. Create a values file with your configuration:
```bash
cp values.yaml my-values.yaml
# Edit my-values.yaml with your specific settings
```

3. Install the chart:
```bash
helm install my-orbit-chain ./helm-chart -f my-values.yaml
```

## Configuration

The following table lists the configurable parameters and their default values.

### Global Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.chainName` | Name of the Orbit chain | `"My Custom Arbitrum Orbit Chain"` |
| `global.chainId` | Chain ID of the Orbit chain | `"96975958395"` |
| `global.parentChainId` | Parent chain ID (Sepolia) | `"11155111"` |
| `global.domain` | Domain for external access | `"192.168.1.100.sslip.io"` |
| `global.protocol` | Protocol (http/https) | `"http"` |

### Nitro Node Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nitro.enabled` | Enable Nitro node deployment | `true` |
| `nitro.image.repository` | Nitro node image repository | `"offchainlabs/nitro-node"` |
| `nitro.image.tag` | Nitro node image tag | `"v3.6.8-d6c96a5"` |
| `nitro.replicaCount` | Number of Nitro node replicas | `1` |
| `nitro.persistence.enabled` | Enable persistent storage | `true` |
| `nitro.persistence.size` | Size of persistent volume | `"500Gi"` |

### Blockscout Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `blockscout.enabled` | Enable Blockscout explorer | `true` |
| `blockscout.postgresql.enabled` | Enable PostgreSQL database | `true` |
| `blockscout.redis.enabled` | Enable Redis cache | `true` |

### Token Bridge Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `tokenBridge.enabled` | Enable token bridge UI | `true` |
| `tokenBridge.config.l1ChainId` | L1 chain ID (Sepolia) | `11155111` |
| `tokenBridge.config.l2ChainId` | L2 chain ID | `96975958395` |

### Secrets Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `secrets.deployerPrivateKey` | Deployer private key | `""` |
| `secrets.batchPosterPrivateKey` | Batch poster private key | `""` |
| `secrets.validatorPrivateKey` | Validator private key | `""` |

## Customizing for Your Setup

1. **Update Chain Configuration**: Modify the `nitro.config` section with your actual chain parameters from `config/nodeConfig.json`.

2. **Set Private Keys**: Set the private keys in the `secrets` section or use external secret management.

3. **Configure Bridge Addresses**: Update `tokenBridge.config` with your bridge contract addresses from `config/outputInfo.json`.

4. **Adjust Resource Limits**: Modify `resources` sections based on your cluster capacity.

5. **Set Domain/Ingress**: Update `global.domain` and `ingress` configuration for external access.

## Usage Examples

### Installing with Custom Values

```bash
helm install orbit-chain ./helm-chart \
  --set global.domain=my-domain.com \
  --set global.protocol=https \
  --set secrets.batchPosterPrivateKey=0x... \
  --set secrets.validatorPrivateKey=0x...
```

### Using External Secrets

```yaml
# external-secrets.yaml
secrets:
  deployerPrivateKey: ""
  batchPosterPrivateKey: ""
  validatorPrivateKey: ""

externalSecrets:
  enabled: true
  secretStore: vault-secret-store
  data:
    - secretKey: BATCH_POSTER_PRIVATE_KEY
      remoteRef:
        key: orbit-chain/batch-poster
        property: private-key
```

### Production Configuration

For production deployments:

1. Enable HTTPS:
```yaml
global:
  protocol: https
```

2. Configure resource limits:
```yaml
nitro:
  resources:
    limits:
      cpu: 4000m
      memory: 8Gi
    requests:
      cpu: 2000m
      memory: 4Gi
```

3. Enable monitoring:
```yaml
monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
```

## Accessing Services

After installation, the services are available at:

- **Nitro RPC**: `http://DOMAIN/rpc` (or port-forward to 8449)
- **Block Explorer**: `http://DOMAIN/` 
- **Token Bridge**: `http://DOMAIN/bridge`

## Troubleshooting

### Common Issues

1. **Nitro node won't start**: Check if the node configuration is correct and secrets are set.

2. **Persistent volume issues**: Ensure your cluster has a default storage class or specify one.

3. **Ingress not working**: Verify ingress controller is installed and configured.

### Debugging Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/instance=orbit-chain

# View nitro logs
kubectl logs -l app.kubernetes.io/component=nitro-node

# Check configuration
kubectl describe configmap orbit-chain-node-config
```

## Upgrading

To upgrade the chart:

```bash
helm upgrade orbit-chain ./helm-chart -f my-values.yaml
```

## Uninstalling

To uninstall the chart:

```bash
helm uninstall orbit-chain
```

**Note**: This will not delete persistent volumes. Delete them manually if needed.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request