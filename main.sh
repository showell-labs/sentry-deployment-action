#!/bin/sh -l

set -e

export SENTRY_AUTH_TOKEN=$INPUT_SENTRYAUTHTOKEN
export SENTRY_LOG_LEVEL=info

# Capture output
output=$(
echo "Release ID is ${INPUT_RELEASEID}"
echo "Organization is ${INPUT_SENTRYORGANIZATION}"
echo "Project is ${INPUT_SENTRYPROJECT}"
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} new ${INPUT_RELEASEID}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} set-commits --auto ${INPUT_RELEASEID}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} files ${INPUT_RELEASEID} upload-sourcemaps ${INPUT_SOURCEMAPLOCATION}
sentry-cli releases -o ${INPUT_SENTRYORGANIZATION} -p ${INPUT_SENTRYPROJECT} finalize ${INPUT_RELEASEID}
)

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.${log}"

# Write output to STDOUT
echo "$output"