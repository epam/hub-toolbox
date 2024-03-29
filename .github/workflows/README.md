# Github Actions workflows

## Description

Here is you can find description of workflows used in this repository.

### Requirements

Workflow permissions should be set to a `Read and Write permissions` option in repository settings (`Settings -> Actions -> General -> Workflow permissions`) to be able to push tags and run workflows from another workflow.

## Base toolbox workflow [toolbox-base.yaml]

This workflow is used to trigger the build and push of the base toolbox docker image.
It triggers by creating a git tag `base`. After the successful build and push of the docker image workflow will tag release in a format `YYYYMMDD-HHmmss-base` (ex. `20230126-171748-base`) and will trigger workflows for extended images by creating tags `gcp` and `azure`.

It also could be triggered manually and set a custom tag. In this case, the `custom-base-` prefix will always be added to a custom tag value (ex. input: `mytag`, result tag: `custom-base-mytag`)

As a result docker image with the next tags will be pushed to `ghcr.io` repository: `YYYYMMDD-HHmmss-base`, `YYYYMMDD-HHmmss`, `base`, `latest`.

## AWS toolbox workflow [toolbox-aws.yaml]

This workflow is used to trigger the build and push of the aws toolbox docker image.
It triggers by creating a git tag `aws`.

It also could be triggered manually and set a custom tag. In this case, the `custom-aws-` prefix will always be added to a custom tag value (ex. input: `mytag`, result tag: `custom-aws-mytag`)

As a result docker image with the next tags will be pushed to `ghcr.io` repository: `YYYYMMDD-HHmmss-aws`, `aws`.

## GCP toolbox workflow [toolbox-gcp.yaml]

This workflow is used to trigger the build and push of the gcp toolbox docker image.
It triggers by creating a git tag `gcp`.

It also could be triggered manually and set a custom tag. In this case, the `custom-gcp-` prefix will always be added to a custom tag value (ex. input: `mytag`, result tag: `custom-gcp-mytag`)

As a result docker image with the next tags will be pushed to `ghcr.io` repository: `YYYYMMDD-HHmmss-gcp`, `gcp`.

## Azure toolbox workflow [toolbox-azure.yaml]

This workflow is used to trigger the build and push of the azure toolbox docker image.
It triggers by creating a git tag `azure`.

It also could be triggered manually and set a custom tag. In this case, the `custom-azure-` prefix will always be added to a custom tag value (ex. input: `mytag`, result tag: `custom-azure-mytag`)

As a result docker image with the next tags will be pushed to `ghcr.io` repository: `YYYYMMDD-HHmmss-azure`, `azure`.

## GCP Cloud Shell image [gcp-cloud-shell.yaml]

This workflow is used to trigger the build and push of the docker image for GCP Cloud Shell.
It triggers only manually.
