# Sandbox Build

Hortonworks Sandbox build


## Outline

-   [Concepts](#concepts)
-   [Deploying A New Service](#deploying-a-new-service)
-   [Create A New Sandbox Layer](#create-a-new-sandbox-layer)

## A Sandbox Layer's Directory Structure

hdf-streaming
├── assets
│   ├── blueprint.json
│   ├── override-configuration.json
│   └── service-startup.sh
├── scripts
│   ├── maintenance-mode.sh
│   ├── service-cycle.sh
│   └──
├── .dockerignore
├── Dockerfile
└── packer.json

-   The name of the root directory (e.g. "hdf-streaming") is the name of the sandbox.
-   "assets" is the suggested place to keep files that will at some point be copied into the sandbox, either temporarily or permenantly.
-   "scripts" is the suggested place to keep scripts that perform tasks.
-   Feel free to create subdirectories in "assets" or "scripts" for deeper organization.

## Workflow

Once a [sandbox layer is created](#create-a-new-sandbox-layer), the name of the sandbox can be manually added to build-sandboxes.sh for automated building.  Executing build-sandboxes.sh will execute the build of each sandbox layer defined.

>  Note: For an explanation of each file involve, jump to [File Explanations](#file-explanations)

Build process and order of execution:
-   Dockerfile - Build a base docker image, specifying which sandbox layer this should sit on top of
-   packer.json - Instantiate a docker container using the docker image build from the above Dockerfile.  Run all scripts specified in this packer job inside the docker container and export the resulting container as the sandbox docker image.

## File Explanations

### Dockerfile

1.  Specify what layer of the sandbox you are building off of by including it in the "FROM" line.
2.  If your sandbox auto-starts different services than those of the sandbox it is based off, edit the included `assets/service-startup.sh`.
3.  Temporarily stop services from starting when building your sandbox layer, for fine-grain control of the build process.
4.  If this Dockerfile is built using the pre-included script, the resulting docker image is postfix'ed with "-pre", as it is only the first step in the sandbox image-creation process.

### packer.json

1.  Change the "image" field in the "builders" section to reflect the name of your sandbox, leaving in the "-pre" postfix so that Packer runs its job off of the docker image you defined in the Dockerfile.
2.  Add/remove/edit scripts as needed.  Scripts run in the order they appear in the file.

### Pre-included scripts

-   `scripts/maintenance-mode.sh` - Place services into/out of maintenance-mode, if desired, by editing this file.
-   `scripts/service-cycle.sh` - If changes to services are made, or new services are installed, cycling (starting/stopping) services before finalizing the build may be beneficial.  Some services run setup/configuration steps only after their first start.
-   `assets/service-startup.sh` - This script defines which components or services begin when the sandbox is powered on.  Edit this file to your liking.
-   `assets/blueprint.json` and `assets/override-configuration.json` - These are discussed more in the [Deploying A New Service](#deploying-a-new-service) section.

## Structure Of The Packer Job File


## Structure of Dockerfile


## Deploying A New Service

A ready-to-go, pre-configured environment like a sandbox may have a number of configurations you'd like preset.  To make specifying configurations easy, you're able to drop in an export of your Ambari cluster's blueprint as `assets/blueprint.json` and manually specify any additional overriding configurations as `assets/override-configuration.json`.

The recommended way to go about exporting configurations is:
1.  Set up your cluster, configs and all, through Ambari, as you see fit.
2.  Have Ambari generate a blueprint for you (see [this Wiki](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints#Blueprints-Step1:CreateBlueprint))

Specify the services and it's component parts that you want to install.  See `kafka-deploy.sh` and `nifi-deploy.sh` for examples.  Be sure to include these scripts in `packer.json`.
