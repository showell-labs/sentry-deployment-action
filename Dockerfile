# Container image that runs your code
FROM getsentry/sentry-cli

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY main.sh /main.sh

# Code file to execute when the docker container starts up
ENTRYPOINT ["/main.sh"]