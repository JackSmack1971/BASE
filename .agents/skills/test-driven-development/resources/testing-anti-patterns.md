# Testing Anti-Patterns Reference

Load this file on-demand when authoring tests that require mocks or shared utilities.

## Anti-Pattern 1: Testing Mock Behavior Instead of Real Behavior

**Bad:**
```typescript
test('retry works', async () => {
  const mock = jest.fn()
    .mockRejectedValueOnce(new Error())
    .mockResolvedValueOnce('success');
  await retryOperation(mock);
  expect(mock).toHaveBeenCalledTimes(2);
});
```
This tests the mock's call count, not the retry logic behavior.

**Good:**
```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };
  const result = await retryOperation(operation);
  expect(result).toBe('success');
  expect(attempts).toBe(3);
});
```
Uses real logic counters. Tests actual behavior.

## Anti-Pattern 2: Test-Only Methods on Production Classes

Never add methods like `getInternalState()` or `resetForTesting()` to production
classes. If the test requires internal access, the design needs simplification.

## Anti-Pattern 3: Mocking Without Understanding Dependencies

Only mock:
- External I/O (network calls, file system in unit tests, databases)
- Non-deterministic values (Date.now(), Math.random())

Do NOT mock:
- Pure functions
- Value objects
- Your own domain logic

## Anti-Pattern 4: Huge Test Setup

If `beforeEach` exceeds 10 lines, the design is too coupled.
Use dependency injection. Extract setup helpers. Simplify interfaces.

## Anti-Pattern 5: "and" in Test Names

`test('validates email and domain and whitespace')` → split into three tests.
One behavior. One test.
