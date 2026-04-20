---
name: opentelemetry-expert
description: Implements full-spectrum observability using OpenTelemetry JS and Prometheus for Node.js (TypeScript) environments. Specializes in "self-diagnostic" spans for agentic workflows, distributed tracing, metric collection, and structured log context injection. Trigger on: "setup observability", "add opentelemetry", "instrument code", "tracing and metrics", "opentelemetry expert". Requires Node.js v18.19.0+ and ESM configuration. Do NOT trigger for frontend-only observability tasks or pure prom-client without OTel.
---

# OpenTelemetry Expert

Expert-level observability implementation for Node.js (TypeScript) applications using OpenTelemetry (OTel). This skill enables a closed-loop "self-diagnostic" system where every agent-generated feature is traced, metered, and logged from day one.

## Prerequisites

- **Node.js**: v18.19.0 or later (required for ESM loader support).
- **Environment**: TypeScript with ESM configuration (`"type": "module"` in `package.json`).
- **Dependencies**:
  ```bash
  npm install @opentelemetry/api @opentelemetry/sdk-node @opentelemetry/auto-instrumentations-node @opentelemetry/exporter-trace-otlp-proto @opentelemetry/exporter-prometheus @opentelemetry/sdk-metrics
  ```

## Implementation Workflow

### Step 1 — Infrastructure Instrumentation
Initialize the OpenTelemetry SDK in a dedicated `instrumentation.ts` file. This file must be loaded *before* any other module to ensure auto-instrumentation patches are applied.

- Use `NodeSDK` from `@opentelemetry/sdk-node`.
- Include `getNodeAutoInstrumentations()` to cover Express, Prisma, HTTP, etc.
- Configure `PrometheusExporter` as the `MetricReader`.
- See `references/setup-patterns.md` for specific Next.js vs. Standalone Node.js configurations.

### Step 2 — Self-Diagnostic Tracing
Instrument agentic workflows with manual spans to track the lifecycle of planning, execution, and verification.

- Wrap major operations in `tracer.startActiveSpan()`.
- Attach operational metadata as attributes (e.g., `agent.task`, `user.approval`).
- Use `references/self-diagnostic-spans.md` for implementation patterns.

### Step 3 — Metrics & Alerting
Export custom metrics to Prometheus to track success rates and latency.

- Use the OpenTelemetry Metrics API (`meter.createCounter`, `meter.createHistogram`).
- Define counters for task completions and histograms for execution duration.
- See `references/tracing-metrics-api.md` for full API details.

## AI Behavior Rules

- **ESM-First**: Always use `--import` and `--experimental-loader` (or the `hook.mjs`) when running instrumented code.
- **OTel-Native**: Prioritize the OpenTelemetry Metrics API over using `prom-client` directly.
- **Trace Context Preservation**: Ensure context is propagated across asynchronous boundaries and service calls.
- **Zero Hallucination**: Every API signature must trace to the verified OpenTelemetry documentation.

## Reference

- `references/setup-patterns.md` — Detailed SDK configuration for Node.js & Next.js.
- `references/self-diagnostic-spans.md` — Synergy patterns for agent workflows and visual QA.
- `references/tracing-metrics-api.md` — API reference for Spans, Metrics, and ESM loaders.
