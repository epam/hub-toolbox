# How to build me?

The main building blocks of the GCP Cloud Shell image are:

* [Hub CTL binary](https://github.com/epam/hubctl/releases)
* [Hub CTL extensions (source)](https://github.com/epam/hub-extensions)

The [Dockerfile](Dockerfile) downloads the given version of the Hub CTL binary, as well as checks out from Git the given references of the extensions and the mgmt tool, and builds them into the image.

To build an image run:

```bash
./image
```

This will build & push the latest GCP Cloud Shell image from the given references.
The naming convention of the image tag is:

```text
ghcr.io/epam/hub-toolbox-gcp-cloud-shell:<commit hash of toolbox>-<commit hash of Hub CTL binary>-<commit hash of Hub extensions>
```

By default, the extensions check out from the following references (branches, tags, etc.):

```bash
HUB_EXTENSIONS_REF=master
```

Hub CTL binary is downloaded from the latest release.

```bash
HUB_CTL_RELEASE_VERSION=latest
```

Feel free to update them according to your needs before running `./image`

It's also possible to tag and push the image with `latest` tag:

```bash
./image --release
```
