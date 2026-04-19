# Production Audit: Case Studies

This resource provides comprehensive examples of how the audit skill transforms representative codebases into enterprise-grade systems.

## Case Study 1: Security Hardening

**The Audit Discovery**:
- Detected SQL Injection in legacy `UserRepository`.
- Found hardcoded database credentials in `config.js`.
- Identified weak MD5 password hashing.

**The Transformation**:
```typescript
// BEFORE (Vulnerable)
const query = `SELECT * FROM users WHERE email = '${email}'`;

// AFTER (Secure)
const query = 'SELECT * FROM users WHERE email = $1';
await db.query(query, [email]);

// BEFORE (Insecure)
const hash = crypto.createHash('md5').update(pass).digest('hex');

// AFTER (Secure)
const hash = await bcrypt.hash(pass, 12);
```

## Case Study 2: Performance Optimization

**The Audit Discovery**:
- N+1 query pattern found in Dashboard loading.
- Missing Redis cache for high-traffic product listings.
- 850KB uncompressed JS bundle size.

**The Transformation**:
- **Query Optimization**: Replaced loop-based queries with a single SQL JOIN (3.2s → 180ms).
- **Caching**: Implemented Redis cache-aside pattern with 1-hour TTL (95% cache hit rate).
- **Bundle Optimization**: Applied code splitting and tree-shaking (55% bundle size reduction).

## Case Study 3: Global SaaS Refactor

**The Audit Discovery**:
- A single "God Class" managing all user logic (850 lines).
- Circular dependency between Order and Payment modules.

**The Transformation**:
- **Decoupling**: Extracted 4 focused services (Profile, Auth, Notification, Permission).
- **Architecture**: Implemented an Event Bus to decouple cross-module calls, breaking the circular dependency.
