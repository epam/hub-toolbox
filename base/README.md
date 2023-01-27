# Base Toolbox

This toolbox image is used to automate operations with Hub CTL.

## Tools included

* [Hub CTL]
* [Hub Extensions](https://github.com/epam/hub-extensions/)
* [git](https://git-scm.com/)
* [jq](https://github.com/stedolan/jq)
* [yq](https://github.com/mikefarah/yq)
* [Kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)
* [Terraform](https://www.terraform.io/)
* [Helm](https://helm.sh/)
* curl, zip, vim, sed, bash, wget.

[Hub CTL]: https://github.com/epam/hubctl

## Development

The image release process is done with help of Github Actions workflow which is trigged by creating of a git tag `base`.

To help with local development there is a `Makefile` with simple goals.

### Build image

```bash
make build
```

### Run image

```bash
make run
```

### Push image

```bash
make push
```
