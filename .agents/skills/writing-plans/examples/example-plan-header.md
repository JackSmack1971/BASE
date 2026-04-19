# User Auth Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace legacy session-based auth with JWT token authentication across the API layer.

**Architecture:** Issue signed JWTs on login, validate via middleware on protected routes, store refresh tokens in Redis with 7-day TTL.

**Tech Stack:** Python 3.11, FastAPI, python-jose, Redis 7, pytest

---

### Task 1: JWT Token Issuance

**Files:**
- Create: `src/auth/tokens.py`
- Modify: `src/auth/routes.py:45-67`
- Test: `tests/auth/test_tokens.py`

- [ ] **Step 1: Write the failing test**

```python
def test_create_access_token_returns_valid_jwt():
    token = create_access_token(subject="user@example.com", expires_delta=timedelta(minutes=30))
    payload = decode_token(token)
    assert payload["sub"] == "user@example.com"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/auth/test_tokens.py::test_create_access_token_returns_valid_jwt -v`
Expected: FAIL with "ImportError: cannot import name 'create_access_token'"

- [ ] **Step 3: Write minimal implementation**

```python
from datetime import datetime, timedelta
from jose import jwt

SECRET_KEY = "your-secret"
ALGORITHM = "HS256"

def create_access_token(subject: str, expires_delta: timedelta) -> str:
    expire = datetime.utcnow() + expires_delta
    return jwt.encode({"sub": subject, "exp": expire}, SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str) -> dict:
    return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/auth/test_tokens.py::test_create_access_token_returns_valid_jwt -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/auth/test_tokens.py src/auth/tokens.py
git commit -m "feat: add JWT token issuance and decode"
```
