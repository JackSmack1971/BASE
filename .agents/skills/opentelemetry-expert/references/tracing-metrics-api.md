# Tracing & Metrics API Reference

Canonical reference for OpenTelemetry JavaScript API methods, configuration keys, and semantic conventions.

## 1. Tracing API (@opentelemetry/api)

### Tracer Methods
- `trace.getTracer(name: string, version?: string)`: Get a tracer instance. Use a unique name for each skill or component.
- `tracer.startActiveSpan(name, [options], callback)`: Creates a span and sets it as active in the current context. **Preferred method.**
- `tracer.startSpan(name, [options])`: Creates a span without making it active. Requires manual context management.

### Span Methods
- `span.setAttribute(key: string, value: any)`: Add metadata to a span.
- `span.setAttributes(attributes: Attributes)`: Add multiple attributes at once.
- `span.addEvent(name: string, [attributes])`: Record a point-in-time "event" with optional metadata.
- `span.setStatus({ code: SpanStatusCode, message?: string })`: Set success (OK) or failure (ERROR).
- `span.recordException(err: Error)`: Record an error stack trace.
- `span.end([timestamp])`: **Mandatory.** Closes the span and triggers export.

## 2. Metrics API (@opentelemetry/api)

### Meter Methods
- `metrics.getMeter(name: string)`: Get a meter instance.
- `meter.createCounter(name, [options])`: For monotonic values (increments only).
- `meter.createHistogram(name, [options])`: For value distributions (e.g., duration, size).
- `meter.createGauge(name, [options])`: For values that go up and down (non-monotonic).

### Instrument Methods
- `counter.add(value, attributes)`
- `histogram.record(value, attributes)`
- `gauge.record(value, attributes)`

## 3. ESM Loader Hook

Since Node.js v18.19.0+, ESM instrumentation requires the loader hook to patch `import` statements.

| Flag | Value | Purpose |
|---|---|---|
| `--import` | `./instrumentation.ts` | Pre-loads the SDK before app code. |
| `--experimental-loader` | `@opentelemetry/instrumentation/hook.mjs` | Enables runtime bytecode patching for ESM. |

### TSX Usage (Development)
```bash
node --import ./instrumentation.ts \
     --experimental-loader @opentelemetry/instrumentation/hook.mjs \
     ./node_modules/tsx/dist/cli.mjs src/main.ts
```

## 4. Semantic Conventions
OpenTelemetry defines standard attribute names. Always prefer these over custom names:
- `http.method`, `http.url`, `http.status_code`
- `db.system`, `db.statement`, `db.operation`
- `exception.type`, `exception.message`, `exception.stacktrace`
- `service.name`, `service.version`, `service.instance.id`
