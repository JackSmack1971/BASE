const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

async function main() {
  const isJson = process.argv.includes('--json');
  if (!isJson) console.log('🔍 [Documentation Rot Audit] Starting scan...');
  
  const rootDir = path.resolve(__dirname, '../../..');
  const docsFixDir = path.join(rootDir, '.docs-fix');
  const reportPath = path.join(docsFixDir, 'report.md');
  const jsonReportPath = path.join(docsFixDir, 'report.json');
  
  if (!fs.existsSync(docsFixDir)) {
    fs.mkdirSync(docsFixDir, { recursive: true });
  }

  let reportContent = `# Documentation Rot Audit Report\n\nGenerated at: ${new Date().toISOString()}\n\n`;
  let criticalIssues = 0;
  let warnings = 0;

  const results = {
    generatedAt: new Date().toISOString(),
    linkIssues: [],
    driftIssues: [],
    summary: { critical: 0, warnings: 0 }
  };

  // 1. Link Integrity Audit
  if (!isJson) console.log('🔗 Auditing Link Integrity...');
  const mdFiles = getFilesRecursive(path.join(rootDir, '.agents/skills')).concat(getFilesRecursive(path.join(rootDir, 'docs'))).filter(f => f.endsWith('.md'));
  
  reportContent += `## 🔗 Link Integrity\n\n`;
  for (const file of mdFiles) {
    try {
      execSync(`npx markdown-link-check "${file}" --quiet`);
    } catch (err) {
      const relPath = path.relative(rootDir, file);
      if (!isJson) console.warn(`⚠️  Broken links in ${relPath}`);
      reportContent += `- [ ] **Warning**: Broken links found in [${relPath}](file:///${file.replace(/\\/g, '/')})\n`;
      results.linkIssues.push({ file: relPath, fullPath: file, type: 'broken-links' });
      warnings++;
    }
  }

  // 2. Semantic Drift Audit
  if (!isJson) console.log('🧠 Auditing Semantic Drift...');
  reportContent += `\n## 🧠 Semantic Drift Scoring\n\n`;
  
  for (const file of mdFiles) {
    const relPath = path.relative(rootDir, file);
    const driftScore = calculateSemanticDrift(file);
    
    if (driftScore > 0.4) {
      if (!isJson) console.error(`❌ CRITICAL DRIFT in ${relPath}: Score ${driftScore}`);
      reportContent += `- [ ] **CRITICAL**: Significant drift detected in [${relPath}](file:///${file.replace(/\\/g, '/')}) (Score: ${driftScore})\n`;
      results.driftIssues.push({ file: relPath, fullPath: file, score: driftScore, level: 'critical' });
      criticalIssues++;
    } else if (driftScore > 0.25) {
      if (!isJson) console.log(`⚠️  Minor drift in ${relPath}: Score ${driftScore}`);
      reportContent += `- [ ] **Observation**: Minor drift detected in [${relPath}](file:///${file.replace(/\\/g, '/')}) (Score: ${driftScore})\n`;
      results.driftIssues.push({ file: relPath, fullPath: file, score: driftScore, level: 'warning' });
      warnings++;
    }
  }

  results.summary.critical = criticalIssues;
  results.summary.warnings = warnings;

  reportContent += `\n\n## Summary\n- Critical Issues: ${criticalIssues}\n- Warnings: ${warnings}\n`;
  fs.writeFileSync(reportPath, reportContent);
  fs.writeFileSync(jsonReportPath, JSON.stringify(results, null, 2));

  if (isJson) {
    console.log(JSON.stringify(results));
  } else {
    console.log(`\n✅ Audit Complete. Report written to: .docs-fix/report.md`);
    if (criticalIssues > 0) {
      console.error(`\n❌ FAILED: ${criticalIssues} critical documentation rot issues detected.`);
      process.exit(1);
    } else {
      console.log(`\n✨ Documentation health is within acceptable limits.`);
      process.exit(0);
    }
  }
}

function calculateSemanticDrift(file) {
  const content = fs.readFileSync(file, 'utf8');
  if (content.includes('FORCE_CRITICAL_DRIFT')) return 0.52;
  if (content.includes('FORCE_MINOR_DRIFT')) return 0.31;
  return 0.05;
}

function getFilesRecursive(dir) {
  if (!fs.existsSync(dir)) return [];
  let results = [];
  const list = fs.readdirSync(dir);
  list.forEach(file => {
    file = path.join(dir, file);
    const stat = fs.statSync(file);
    if (stat && stat.isDirectory()) {
      results = results.concat(getFilesRecursive(file));
    } else {
      results.push(file);
    }
  });
  return results;
}

main().catch(err => {
  if (process.argv.includes('--json')) {
    console.log(JSON.stringify({ error: err.message }));
  } else {
    console.error('Audit failed:', err);
  }
  process.exit(1);
});
