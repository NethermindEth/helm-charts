template-sts:
	helm template generic-sts . -f values.yaml -f values.sts.yaml --debug > manifest.yaml

template-deploy:
	helm template generic-deploy . -f values.yaml -f values.deploy.yaml --debug > manifest.yaml

template-override:
	helm template generic-override . -f values.yaml -f values.override.yaml --debug > manifest.yaml
