# Self-Diagnostic Spans: Agentic Observability

Patterns for instrumenting agentic workflows to make them proactive, observable, and self-healing.

## 1. The Core Implementation Pattern

Always use `startActiveSpan` to ensure automatic parent-child relationship handling within the asynchronous flow.

```typescript
import { trace, SpanStatusCode } from '@opentelemetry/api';

const tracer = trace.getTracer('agent-orchestrator');

async function executeAgentTask(taskName: string, logic: () => Promise<void>) {
  return tracer.startActiveSpan(`agent.task.${taskName}`, async (span) => {
    try {
      span.setAttribute('agent.task.name', taskName);
      span.setAttribute('git.sha', process.env.COMMIT_SHA || 'unknown');
      
      await logic();
      
      span.setStatus({ code: SpanStatusCode.OK });
    } catch (error) {
      span.recordException(error as Error);
      span.setStatus({
        code: SpanStatusCode.ERROR,
        message: (error as Error).message,
      });
      throw error;
    } finally {
      span.end();
    }
  });
}
```

## 2. Synergy: CI/CD & Visual QA Loops

### Orchestrating Matrix Jobs
Wrap matrix job execution in spans that include job identifiers and parameters.

```typescript
// Inside ci-cd-orchestrator
tracer.startActiveSpan('ci.matrix.job', {
  attributes: {
    'ci.job.id': job.id,
    'ci.matrix.node': matrix.nodeIndex,
    'ci.matrix.total': matrix.totalNodes,
  }
}, async (span) => {
  // ... run job
  span.end();
});
```

### Visual TDD Cycles
Instrument visual regression checks to track screenshot latency and diff severity.

```typescript
// Inside playwright-visual-regression
tracer.startActiveSpan('visual.tdd.cycle', async (span) => {
  const result = await runVisualTddCycle();
  
  span.setAttribute('visual.diff.count', result.diffCount);
  span.setAttribute('visual.status', result.passed ? 'pass' : 'fail');
  
  if (!result.passed) {
    span.setStatus({ code: SpanStatusCode.ERROR, message: 'Visual diff detected' });
  }
  span.end();
});
```

## 3. Agent-Native Observability Loop

| Phase | Metric Name | Spans | Key Attributes |
|---|---|---|---|
| **Planning** | `agent_plan_duration_seconds` | `agent.plan` | `strategy.type`, `complexity` |
| **Generation** | `agent_code_lines_total` | `agent.write` | `file.extension`, `skill.name` |
| **Audit** | `agent_audit_failure_total` | `agent.audit` | `severity`, `rule.id` |
| **Verification** | `agent_test_pass_rate` | `agent.test` | `test.framework`, `runner.id` |

## 4. Proactive Auditing
Use the Prometheus exporter to query these metrics within the orchestrator:
- **Condition**: If `agent_audit_failure_total` > 20% in the last 5 minutes.
- **Action**: Alert the user or trigger a `simplification-cascade` to reduce architectural complexity.
