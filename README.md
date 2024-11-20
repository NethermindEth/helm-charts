# Helm Charts

The list of helm charts maintained and further developed by Nethermind team. Every chart is located in a separate folder and has the configuration parameters located in `values.yaml` file.

## Usage

```bash
helm repo add nethermind https://nethermindeth.github.io/helm-charts
helm install my-release nethermind/<chart-name>
```

## Contributing

Please see the [contributing guidelines](CONTRIBUTING.md).

## Security Context Standards

All charts in this repository follow a standardized security context configuration to ensure consistent and secure deployment of containers. The security contexts are always enabled and configured with secure defaults.

### Default Configuration

Each chart includes three levels of security context:

```yaml
# Pod-level security context
podSecurityContext:
  fsGroup: 1000
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000

# Main container security context
securityContext:
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  allowPrivilegeEscalation: false

# Init container security context
initContainerSecurityContext:
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  allowPrivilegeEscalation: false
```

### Security Features

- Non-root user execution (UID 1000)
- Read-only root filesystem
- No privilege escalation
- All capabilities dropped
- Consistent group and filesystem permissions

### Customization

While these security contexts are always enabled, you can override specific settings in your values.yaml:

```yaml
# Example: Override user ID for a specific use case
securityContext:
  runAsUser: 2000
