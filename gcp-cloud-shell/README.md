# How to build me?

The main building blocks of the GCP Cloud Shell image are:

* [Hub CTL binary](https://github.com/epam/hubctl/releases)
* [Hub CTL extensions (source)](https://github.com/epam/hub-extensions)
* [Hub State mgmt tool (source)](https://github.com/epam/hub-state)

The [Dockerfile](Dockerfile) downloads the given version of the SuperHub CLI binary, as well as
checks out from Git the given references of the extensions and the mgmt tool,
and builds them into the image.

To build an image run:

```bash
./image
```

This will build & push the latest GCP Cloud Shell image from the given references.
The naming convention of the image tag is:

```text
gcr.io/superhub/cloud-shell:<commit hash of CLI binary>-<commit hash of CLI extensions>-<commit hash of HUB state>
```

By default, the extensions and the mgmt tool check out from the following references (branches, tags, etc.):

```text
HUB_EXTENSIONS_REF=stable
HUB_STATE_REF=master
```

But default SuperhHub CLI binary version is the following:

```text
HUB_CLI_RELEASE_VERSION=v1.0.10
```

Feel free to update them according to your needs before running `./image`

It's also possible to tag and push the image with `latest` tag:

```bash
./image --release
```
