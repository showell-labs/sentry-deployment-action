#!/bin/sh -l

# $1 = sentry-organisation
# $2 = sentry-project
# $3 = sentry-auth-key
# $4 = release-id
# $5 = source-map-loction
# $6 = source-map-prefix
set -e

# Respect RELEASE_VERSION if specified
[ -n "$INPUT_RELEASEVERSION" ] || export RELEASE_VERSION="$(sentry-cli releases propose-version)"

export SENTRY_AUTH_TOKEN=$INPUT_SENTRYAUTHTOKEN
export SENTRY_LOG_LEVEL=info

echo "Release version is ${RELEASE_VERSION}"
echo "Organization is ${INPUT_SENTRYORGANIZATION}"
echo "Project is ${INPUT_SENTRYPROJECT}"
# Capture output
output=$(
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} new ${RELEASE_VERSION}
sentry-cli releases set-commits --auto ${RELEASE_VERSION}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} files ${RELEASE_VERSION} upload-sourcemaps ${INPUT_SOURCEMAPLOCATION}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} finalize ${RELEASE_VERSION}
)

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.${log}"


# Write output to STDOUT
echo "$output"

