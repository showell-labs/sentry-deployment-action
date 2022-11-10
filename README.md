# GitHub action for making a Sentry deployment

This GH action is based on Docker image `getsentry/sentry-cli`, which provides Sentry CLI tool for deployments.

`action.yml` is the standard GH action definition that lists all accepted arguments
and defines how to execute the action using Docker.

`Dockerfile` is used simply to overwrite the default entrypoint for the Docker image.

`main.sh` is a Shell script that is used as the `entrypoint` for the Docker command.
This script contains the logic for making the deployment.

The GH action arguments are automatically passed as env variables to the Docker container, which means
that they can be accessed using `INPUT_VARIABLENAME` syntax in `main.sh`.