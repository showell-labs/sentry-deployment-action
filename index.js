const fs = require('fs');
const core = require('@actions/core');
const github = require('@actions/github');
const SentryCli = require('@sentry/cli');

async function run() {
    try {
        const sentryOrg = core.getInput('sentry-organisation');
        const sentryProj = core.getInput('sentry-project');
        const sentryAuthKey = core.getInput('sentry-auth-key');
        const confFile = `
          [auth]
          token=${sentryAuthKey}
          [defaults]
          project = ${sentryProj}
          org = ${sentryOrg}
        `;
        fs.writeFileSync('.sentryclirc', confFile, {
            flag: 'w+'
        })
        const releaseId = core.getInput('release-id');
        const sourceMapLoc = core.getInput('source-map-location');
        const sourceMapPre = core.getInput('source-map-prefix');
      
        const cli = new SentryCli('.sentryclirc');
        const release = releaseId || cli.releases.proposeVersion();
        console.log(`Release ID is ${release}`);
        await cli.releases.new(release);
        await cli.releases.uploadSourceMaps(release, {
            include: [sourceMapLoc],
            urlPrefix: sourceMapPre || undefined
        });
        await cli.releases.finalize(release);
        core.setOutput("versionId", version);
        fs.unlinkSync('.sentryclirc');
      } catch (error) {
        core.setFailed(error.message);
      }
} 
run();