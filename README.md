# Toolbox

Toolbox is a Docker image that is used by [Hub CTL] to perform provisioning operations on a stack, such as `deploy` and `undeploy`. Stack is a collection of software components like Kubernetes, Etcd, Vault, PostgreSQL, S3 buckets and other cloud resources, applications, etc. wired together yet developed independently.

The image contains all the tools installed and configured that are required by the software components supported by [Hub CTL]. It is based on [Alpine Linux](https://www.alpinelinux.org/about/) Docker image.

## Toolbox versions

There are several [versions](https://hub.docker.com/r/agilestacks/toolbox/tags) of the image: `latest`, `stage`, `stable`, etc. distinguished by image label. There are also specialized images extending base image with additional tools required for some particular software component, `spinnaker-*` for example.

## Tools included

The base image contains following tools:

* [Hub CTL]
* [Hub Extensions](https://github.com/epam/hub-extensions/)
* [git](https://git-scm.com/)
* [jq](https://github.com/stedolan/jq)
* [yq](https://github.com/mikefarah/yq)
* [Kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)
* [Terraform](https://www.terraform.io/)
* [Helm](https://helm.sh/)
* curl, zip, vim, rsync, sed, gnupg, bash, wget.

[Hub CTL]: https://github.com/epam/hubctl
