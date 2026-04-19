#!/usr/bin/env node
// .agents/skills/semantic-versioning/semantic-versioning.js
// Zero-dependency local-first SemVer engine (Node.js v22+)

const { execSync } = require('child_process');
const fs = require('fs');

function run(cmd) {
  try {
    return execSync(cmd, { encoding: 'utf8' }).trim();
  } catch (e) {
    return '';
  }
}

const latestTag = run('git describe --tags --abbrev=0') || "v0.0.0";
let [major, minor, patch] = latestTag.replace('v', '').split('.').map(Number);
if (isNaN(major)) { major = 0; minor = 0; patch = 0; }

const commits = run(`git log --pretty=format:%s ${latestTag === "v0.0.0" ? "" : latestTag + "..HEAD"}`).split('\n').filter(Boolean);

if (commits.length === 0) {
  console.log("No new commits since last release.");
  process.exit(0);
}

let bump = 'patch';
for (const msg of commits) {
  if (msg.includes('BREAKING CHANGE') || msg.includes('!')) { bump = 'major'; break; }
  if (msg.startsWith('feat')) { bump = 'minor'; }
}

if (bump === 'major') {
  major++; minor = 0; patch = 0;
} else if (bump === 'minor') {
  minor++; patch = 0;
} else {
  patch++;
}

const newVersion = `v${major}.${minor}.${patch}`;
const today = new Date().toISOString().split('T')[0];

console.log(`Bumping ${latestTag} → ${newVersion}`);

// Update CHANGELOG.md (append new section)
try {
  let changelog = fs.readFileSync('CHANGELOG.md', 'utf8');
  const latestCommitMsg = run('git log -1 --pretty=%s');
  const newSection = `\n## [${newVersion}] - ${today}\n\n### ${bump.charAt(0).toUpperCase() + bump.slice(1)}\n- ${latestCommitMsg}\n`;
  
  if (changelog.includes('## [Unreleased]')) {
    changelog = changelog.replace('## [Unreleased]', `## [Unreleased]\n\n${newSection.trim()}`);
  } else {
    changelog = changelog + '\n' + newSection;
  }
  fs.writeFileSync('CHANGELOG.md', changelog);
  console.log(`✅ Updated CHANGELOG.md with ${newVersion}: "${latestCommitMsg}"`);
} catch (e) {
  console.error("Failed to update CHANGELOG.md", e.message);
}

// Update AGENTS.md header
try {
  let agents = fs.readFileSync('AGENTS.md', 'utf8');
  agents = agents.replace(/v\d+\.\d+\.\d+-hardening/g, `${newVersion}-hardening`);
  fs.writeFileSync('AGENTS.md', agents);
  console.log(`✅ Updated AGENTS.md to ${newVersion}`);
} catch (e) {
  console.error("Failed to update AGENTS.md", e.message);
}

// Update README.md header (badge or footer)
try {
  let readme = fs.readFileSync('README.md', 'utf8');
  // Update badge if exists or footer date
  const updatedDate = new Date().toLocaleString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
  readme = readme.replace(/Updated-.*-brightgreen/g, `Updated-${newVersion}-brightgreen`);
  readme = readme.replace(/Last updated: .* ·/g, `Last updated: ${today} ·`);
  fs.writeFileSync('README.md', readme);
  console.log(`✅ Updated README.md to ${newVersion}`);
} catch (e) {
  console.error("Failed to update README.md", e.message);
}

// Create annotated tag
try {
  run(`git tag -a ${newVersion} -m "Release ${newVersion}"`);
  console.log(`✅ Tagged ${newVersion}`);
} catch (e) {
  console.error(`Failed to create tag ${newVersion}`, e.message);
}
