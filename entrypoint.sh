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

export SENTRY_AUTH_TOKEN=$SENTRY_AUTH_TOKEN
export SENTRY_LOG_LEVEL=info

echo "Release version is ${RELEASE_VERSION}"
# Capture output
output=$(
sentry-cli releases -o ${SENTRY_ORGANIZATION} -p ${SENTRY_PROJECT} new ${RELEASE_VERSION}
sentry-cli releases -o ${SENTRY_ORGANIZATION} -p ${SENTRY_PROJECT} files ${RELEASE_VERSION} upload-sourcemaps ${SOURCE_MAP_LOCATION}
sentry-cli releases -o ${SENTRY_ORGANIZATION} -p ${SENTRY_PROJECT} finalize ${RELEASE_VERSION}
)

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.${log}"


# Write output to STDOUT
echo "$output"

