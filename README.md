# Toolbox

Toolbox is a Docker image that is used by by Agile Stack's Control Plane automation tasks to perform provisioning operations on a stack, for example `deploy` and `undeploy`. Stack is a collection of software components like Kubernetes, Etcd, Vault, PostgreSQL, S3 buckets and other cloud resources, applications, etc. wired together yet developed independently.

The image contains all the tools installed and configured that are required by the software components supported by Agile Stacks. It is based on [Alpine Linux](https://www.alpinelinux.org/about/) Docker image v3.8.

You could also run it locally via `./toolbox-run`.

# Toolbox versions

There are several [versions](https://hub.docker.com/r/agilestacks/toolbox/tags) of the image: `latest`, `stage`, `stable`, etc. distinguished by image label. There are also specialized images extending base image with additional tools required for some particular software component, `spinnaker-*` for example.

# Tools included

The image contains following tools:

- Agile Stack's Hub CLI (hub)
- AWS CLI
- Direnv
- Docker in Docker
- Git and GitHub CLI (ghub)
- Helm
- JQ and YQ
- Kompose
- Ksonnet
- Kubectl
- Minio client
- Python 2 with virtualenv
- Stern
- Terraform 0.9 and 0.10 with pre-cached set of provider plug-ins
- Tini init
- Vault
- zip, vim, rsync, sed, gnupg, bash, and of course curl.
