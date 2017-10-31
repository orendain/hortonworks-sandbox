# Hortonworks Sandbox

_The Hortonworks Sandbox is popular, and is now modular!_

_Complicated builds cause haters, so use native Docker layers!_

_Something something rhyme, I'm bad at rhymes!_

## Outline

-   [What This Is](#what-this-is)
-   [Directory Structure](#directory-structure)
-   [Build Process](#build-process)
-   [File Explanations](#file-explanations)
-   [Deploying A New Service](#deploying-a-new-service)


## What This Is

In a nutshell: Rather than building an entire sandbox environment from scratch, use this project to extend any Hortonworks Sandbox image by specifying what changes you'd like to make to an existing image.

The interface between sandbox "layers" are well-defined, making extensions swappable and combinable.

For support, feel free to ping me:
eorendain@hortonworks.com

> _TODO: Add slides or recording of new build architecture unveiling for better visuals_

## Directory Structure

```
hdp-sandbox-name/
├── assets/
│   ├── blueprint.json
│   ├── custom-configs.json
│   └── service-startup.sh
├── scripts/
│   ├── deploys/
│   │   ├── blueprint.json
│   │   ├── kafka.json
│   │   └── nifi.json
│   ├── maintenance-mode.sh
│   ├── mysql-setup.sh
│   └── service-cycle.sh
├── Dockerfile
└── packer.json
```

-   The name of the root directory (e.g. "hdp-sandbox-name") can be the desired name of your sandbox.
-   `assets` is the suggested place to keep files that will at some point be copied into the sandbox, either temporarily or permenantly.
-   `scripts` is the suggested place to keep scripts that perform tasks
-   `scripts/deploys` houses scripts that deploy new services on Ambari
-   Feel free to create whatever subdirectories you need for organization.

## Build Process

Build process and order of execution:
1.  build.sh - A script that will fire off your sandbox builds
2.  Dockerfile - Build a base docker image, specifying which sandbox layer this new layer should sit on top of
3.  packer.json - Instantiate a docker container using the docker image build from the above Dockerfile.  Run all scripts specified in this packer job inside the docker container and export the resulting container as a new sandbox docker image.

## File Explanations

### Dockerfile

-   Specify which sandbox you are expanding on by including it in the "FROM" line.
-   If your sandbox auto-starts different services than those of the sandbox it is based off, edit the included `assets/service-startup.sh`, which is copied onto the sandbox for execution during each startup.
-   Temporarily stop services from starting when building your sandbox layer, for fine-grain control of the build process.
-   If this Dockerfile is built using the pre-included script, the resulting docker image is postfix'ed with "-pre", as it an indicator that this is only the first step in the sandbox image-creation process.

### packer.json

-   Change the "image" field in the "builders" section to reflect the name of your sandbox, leaving in the "-pre" postfix so that Packer runs its job off of the docker image you defined in the Dockerfile.
-   Add/remove/edit scripts as needed.  Scripts run in series, the order they appear in the file.
-   The included template `packer.job` is broken up into several shell-type and file-type blocks.
    -   The first shell-type block creates a build-wide temporary directory and waits for Ambari on the current sandbox to fully load.
    -   The file-type directive simply mounts the entire `assets` directory as `/tmp/sandbox/build` on the sandbox for the duration of the build.
    -   The last shell-type block removes the temporary directory previously created and enables autostarting Ambari on each sandbox boot.

### Pre-included scripts

-   `scripts/maintenance-mode.sh` - Place services into/out of maintenance-mode, if desired, by editing this file.
-   `scripts/mysql-setup.sh` - A template to use if you need to do any mysql prep.
-   `scripts/service-cycle.sh` - If changes to services are made, or new services are installed, cycling (starting/stopping) services before finalizing the build may be beneficial.  Some services run setup/configuration steps only after their first start.
-   `assets/service-startup.sh` - This script defines which components or services begin when the sandbox is powered on.  Edit this file to your liking.
-   `assets/blueprint.json` and `assets/custom-configs.json` - These are discussed more in the [Deploying A New Service](#deploying-a-new-service) section.

## Deploying A New Service

A ready-to-go, pre-configured environment like a sandbox may have a number of configurations you'd like preset.  To make specifying configurations easy, you're able to drop in an export of your Ambari cluster's blueprint as `assets/blueprint.json` and manually specify any additional configurations as `assets/custom-configs.json`.

The recommended way to go about exporting configurations is:
1.  Set up your cluster, configs and all, through Ambari as you see fit.
2.  Have Ambari [generate a blueprint for you](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints#Blueprints-Step1:CreateBlueprint)

Specify the services and it's component parts that you want to install.  See `scripts/deploy/kafka.sh` and `scripts/deploy/nifi.sh` for examples.
