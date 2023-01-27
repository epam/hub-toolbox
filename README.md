# Toolbox

Toolbox is a Docker image that is used by [Hub CTL] to perform provisioning operations on a stack, such as `deploy` and `undeploy`. Stack is a collection of software components like Kubernetes, Etcd, Vault, PostgreSQL, S3 buckets and other cloud resources, applications, etc. wired together yet developed independently.

The image contains all the tools installed and configured that are required by the software components supported by [Hub CTL]. It is based on [Alpine Linux](https://www.alpinelinux.org/about/) Docker image.

## Toolbox versions

There are several versions of the image: [`base`](/base/README.md), [`gcp`](/gcp/README.md), [`azure`](/azure/README.md).

[Hub CTL]: https://github.com/epam/hubctl
