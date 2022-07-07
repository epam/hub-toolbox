# Toolbox

Toolbox is a Docker image that is used by Agile Stack's [Hub CLI] to perform provisioning operations on a stack, such as `deploy` and `undeploy`. Stack is a collection of software components like Kubernetes, Etcd, Vault, PostgreSQL, S3 buckets and other cloud resources, applications, etc. wired together yet developed independently.

The image contains all the tools installed and configured that are required by the software components supported by Agile Stacks. It is based on [Alpine Linux](https://www.alpinelinux.org/about/) Docker image.

You could also run it locally via `./toolbox-run` or [`hub toolbox`](https://github.com/agilestacks/hub/).

## Toolbox versions

There are several [versions](https://hub.docker.com/r/agilestacks/toolbox/tags) of the image: `latest`, `stage`, `stable`, etc. distinguished by image label. There are also specialized images extending base image with additional tools required for some particular software component, `spinnaker-*` for example.

## Tools included

The base image contains following tools:

* [Hub CLI](https://github.com/agilestacks/hub/)
* [Hub Extensions](https://github.com/agilestacks/hub-extensions/)
* [git](https://git-scm.com/)
* [jq](https://github.com/stedolan/jq)
* [yq](https://github.com/mikefarah/yq)
* [Node.js and NPM](https://nodejs.org/)
* [Kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)
* [Terraform](https://www.terraform.io/)
* [Helm](https://helm.sh/)
* [Kustomize](https://kustomize.io/)
* [Direnv](https://direnv.net/)
* [GitHub CLI](https://cli.github.com/)
* [Tini init](https://github.com/krallin/tini)
* zip, vim, rsync, sed, gnupg, bash, bc, host, wget, and of course curl.

[Hub CLI]: https://github.com/agilestacks/hub/
