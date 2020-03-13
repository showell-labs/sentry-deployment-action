#!/bin/sh -l

# $1 = sentry-organisation
# $2 = sentry-project
# $3 = sentry-auth-key
# $4 = release-id
# $5 = source-map-loction
# $6 = source-map-prefix
set -e

# Respect RELEASE_VERSION if specified
[ -n "$RELEASE_VERSION" ] || export RELEASE_VERSION="$(sentry-cli releases propose-version)"

export SENTRY_AUTH_TOKEN=$3

echo "Release version is ${RELEASE_VERSION}"
# Capture output
output=$(
sentry-cli releases new $RELEASE_VERSION
sentry-cli releases -o $1 -p $2 files $RELEASE_VERSION upload-sourcemaps $5
sentry-cli releases deploys $RELEASE_VERSION new -e $ENVIRONMENT
sentry-cli releases finalize "$RELEASE_VERSION"
)

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.${log}"


# Write output to STDOUT
echo "$output"

