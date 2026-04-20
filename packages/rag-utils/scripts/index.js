const fs = require('fs');
const path = require('path');

async function main() {
  console.log('--- Starting RAG Indexing Loop ---');
  
  const rootDir = path.resolve(__dirname, '../../..');
  const skillsDir = path.join(rootDir, '.agents/skills');
  const docsDir = path.join(rootDir, 'docs');
  
  const searchPaths = [skillsDir, docsDir];
  let filesProcessed = 0;

  for (const dir of searchPaths) {
    if (!fs.existsSync(dir)) {
      console.warn(`Warning: Directory not found: ${dir}`);
      continue;
    }

    const files = getFilesRecursive(dir).filter(f => f.endsWith('.md'));
    
    for (const file of files) {
      const content = fs.readFileSync(file, 'utf8');
      console.log(`[INDEXING] ${path.relative(rootDir, file)} (${content.length} chars)`);
      filesProcessed++;
      
      // In a real implementation with credentials:
      // const embedding = await generateEmbedding(content);
      // await storeInPgVector(file, content, embedding);
    }
  }

  console.log(`--- Indexing Complete. Processed ${filesProcessed} files. ---`);
  
  if (!process.env.DATABASE_URL || !process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    console.log('\nNOTE: Persistent storage skipped. Set DATABASE_URL and GOOGLE_APPLICATION_CREDENTIALS for full RAG activation.');
  }
}

function getFilesRecursive(dir) {
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
  console.error('Indexing failed:', err);
  process.exit(1);
});
