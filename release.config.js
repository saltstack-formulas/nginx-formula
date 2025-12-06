// Commit types appear in the changelog in this order
const commitTypes = [
  { type: 'feat', section: 'Features' },
  { type: 'fix', section: 'Bug Fixes' },
  { type: 'perf', section: 'Performance Improvements' },
  { type: 'revert', section: 'Reversions' },
  { type: 'refactor', section: 'Code Refactoring' },
  { type: 'docs', section: 'Documentation' },
  { type: 'test', section: 'Testing' },
  { type: 'style', section: 'Style Changes' },
  { type: 'ci', section: 'Continuous Integration' },
  { type: 'build', section: 'Build System' },
  { type: 'chore', section: 'Maintenance' }
]

// Default rules can be found in `github.com/semantic-release/commit-analyzer/lib/default-release-rules.js`
// that cover feat, fix, perf and breaking.
// Commit types defined above but without release rules do not trigger a release
// but will be incorporated into the next release.
// NOTE: Any changes to commit types or release rules must be reflected in `CONTRIBUTING.rst`.
const releaseRules = [
  { type: 'docs', release: 'patch' },
  { type: 'refactor', release: 'patch' },
  { type: 'revert', release: 'patch' },
  { type: 'style', release: 'patch' },
  { type: 'test', release: 'patch' }
]

const config = {
  // TODO: remove this when we no longer process releases on GitLab CI
  repositoryUrl: 'https://github.com/saltstack-formulas/nginx-formula',
  plugins: [
    ['@semantic-release/commit-analyzer', { releaseRules }],
    '@semantic-release/release-notes-generator',
    ['@semantic-release/changelog', {
      changelogFile: 'CHANGELOG.md',
      changelogTitle: '# Changelog'
    }],
    ['@semantic-release/exec', {
      // eslint-disable-next-line no-template-curly-in-string
      prepareCmd: 'sh ./pre-commit_semantic-release.sh ${nextRelease.version}'
    }],
    ['@semantic-release/git', {
      assets: ['*.md', 'docs/*.rst', 'FORMULA']
    }],
    '@semantic-release/github'
  ],
  preset: 'conventionalcommits',
  presetConfig: {
    types: commitTypes
  }
}

module.exports = config
