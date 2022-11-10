#!/bin/sh -l

set -e

# Respect RELEASE_VERSION if specified
[ -n "$INPUT_RELEASEVERSION" ] || export RELEASE_VERSION="$(sentry-cli releases propose-version)"

export SENTRY_AUTH_TOKEN=$INPUT_SENTRYAUTHTOKEN
export SENTRY_LOG_LEVEL=info

# Capture output
output=$(
echo "Release version is ${RELEASE_VERSION}"
echo "Organization is ${INPUT_SENTRYORGANIZATION}"
echo "Project is ${INPUT_SENTRYPROJECT}"
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} new ${RELEASE_VERSION}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} set-commits --auto ${RELEASE_VERSION}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} files ${RELEASE_VERSION} upload-sourcemaps ${INPUT_SOURCEMAPLOCATION}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} finalize ${RELEASE_VERSION}
)

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.${log}"

# Write output to STDOUT
echo "$output"