# Setup Patterns: OpenTelemetry Node.js SDK

Detailed configuration patterns for initializing OpenTelemetry in professional Node.js and Next.js environments.

## 1. Standalone Node.js (TypeScript/ESM)

This configuration ensures full auto-instrumentation of Express, Prisma, and HTTP calls.

```typescript
// instrumentation.ts
import { NodeSDK } from '@opentelemetry/sdk-node';
import { diag, DiagConsoleLogger, DiagLogLevel } from '@opentelemetry/api';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-proto';
import { PrometheusExporter } from '@opentelemetry/exporter-prometheus';

// Optional: Enable internal OTel diagnostics for troubleshooting
diag.setLogger(new DiagConsoleLogger(), DiagLogLevel.INFO);

const sdk = new NodeSDK({
  serviceName: 'base-backend',
  traceExporter: new OTLPTraceExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4318/v1/traces',
  }),
  metricReader: new PrometheusExporter({
    port: 9464, // Metrics will be available at http://localhost:9464/metrics
  }),
  instrumentations: [
    getNodeAutoInstrumentations({
      // Configure specific instrumentations
      '@opentelemetry/instrumentation-prisma': { enabled: true },
      '@opentelemetry/instrumentation-express': { enabled: true },
    }),
  ],
});

sdk.start();

// Graceful shutdown
process.on('SIGTERM', () => {
  sdk.shutdown()
    .then(() => console.log('Tracing terminated'))
    .catch((error) => console.log('Error terminating tracing', error))
    .finally(() => process.exit(0));
});
```

### Execution (ESM Loader)
You **must** run the application with the loader to patch ESM modules:
```bash
node --experimental-loader=@opentelemetry/instrumentation/hook.mjs \
     --import ./instrumentation.ts \
     dist/main.js
```

## 2. Next.js App Router Instrumentation

Next.js has native support for OpenTelemetry via the `instrumentation.ts` hook.

```typescript
// src/instrumentation.ts (or root)
export async function register() {
  if (process.env.NEXT_RUNTIME === 'nodejs') {
    const { NodeSDK } = await import('@opentelemetry/sdk-node');
    const { getNodeAutoInstrumentations } = await import('@opentelemetry/auto-instrumentations-node');
    const { PrometheusExporter } = await import('@opentelemetry/exporter-prometheus');

    const sdk = new NodeSDK({
      serviceName: 'base-web',
      metricReader: new PrometheusExporter({
        port: 9465, // Metrics for web layer
      }),
      instrumentations: [getNodeAutoInstrumentations()],
    });

    sdk.start();
  }
}
```

### Enable in `next.config.js`
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    instrumentationHook: true,
  },
};
module.exports = nextConfig;
```

## 3. Logger Context Injection

Inject OTel trace IDs into structured JSON logs (e.g., using `pino`).

```typescript
import pino from 'pino';
import { trace, context } from '@opentelemetry/api';

const logger = pino({
  mixin() {
    const span = trace.getSpan(context.active());
    if (!span) return {};
    const { traceId, spanId } = span.spanContext();
    return { traceId, spanId };
  },
});
```
