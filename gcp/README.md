# GCP Toolbox

This toolbox image is used to automate operations with Hub CTL in Google Cloud Provider.

## Tools included

* Same as in [`base`](../base/README.md)
* [GCP SDK](https://cloud.google.com/cli)

## Development

The image release process is done with help of Github Actions workflow which is trigged by creating of a git tag `gcp`.

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
