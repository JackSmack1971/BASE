# Production Audit: Issue Detection Taxonomy

This resource defines the criteria used during a production-grade code audit to identify vulnerabilities, bottlenecks, and technical debt.

## 1. Architecture
- **Circular Dependencies**: Mutually dependent modules that complicate testing and builds.
- **God Classes/Modules**: Files exceeding 500 lines or containing too many responsibilities (violation of SRP).
- **Tight Coupling**: Lack of proper interfaces or event-driven decoupling.
- **Pattern Violations**: Inconsistent implementation of chosen software patterns (MVC, Hexagonal, etc.).

## 2. Security
- **Injection**: SQLi, NoSQLi, and command injection via unvalidated inputs.
- **Broken Auth**: Missing middleware on protected routes or weak session management.
- **Exposure**: Hardcoded secrets, API keys, or verbose error messages leaking system details.
- **Hashing**: Use of weak algorithms like MD5 or SHA1 for passwords.

## 3. Performance
- **Database**: N+1 queries, missing indexes, and unoptimized JOINs.
- **Async/Sync**: Blocking operations on the main thread that should be asynchronous.
- **Caching**: Lack of result caching for expensive, high-frequency operations.
- **Assets**: Large bundle sizes, unoptimized images, and memory leaks.

## 4. Code Quality
- **Complexity**: High cyclomatic complexity (>10) making code hard to test and maintain.
- **Duplication**: Repeated logic that should be abstracted into shared utilities.
- **Convention**: Inconsistent naming, formatting, or lack of proper error handling.
- **Dead Code**: Reached but unused functions and variables.

## 5. Production Readiness
- **Observability**: Missing structured logging, error tracking (Sentry), and health checks.
- **Environment**: Hardcoded configurations that should be environment variables.
- **CI/CD**: Lack of automated testing and deployment pipelines.
