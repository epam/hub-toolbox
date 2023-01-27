# Azure Toolbox

This toolbox image is used to automate operations with Hub CTL in Microsoft Azure cloud provider.

## Tools included

* Same as in [`base`](../base/README.md)
* [Azure Command-Line Interface](https://learn.microsoft.com/en-us/cli/azure/)

## Development

The image release process is done with help of Github Actions workflow which is trigged by creating of a git tag `azure`.

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
