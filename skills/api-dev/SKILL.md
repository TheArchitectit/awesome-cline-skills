---
name: api-dev
description: REST and GraphQL API design and development covering schema-first design, versioning, authentication, rate limiting, error handling, and documentation. This skill should be used when designing APIs, building REST or GraphQL backends, implementing authentication and rate limiting, or creating API documentation.
---

# API Development

This skill provides structured guidance for designing and building robust REST and GraphQL APIs, with patterns for schema design, versioning, authentication, rate limiting, and documentation.

## Prerequisites

- A backend framework (Express, Fastify, Django, FastAPI, etc.)
- Understanding of HTTP fundamentals
- Database access for persistence

## When to Use This Skill

- Designing a new REST or GraphQL API
- Implementing authentication and authorization
- Adding rate limiting and request throttling
- Versioning an existing API
- Creating API documentation (OpenAPI/GraphQL schema)
- Structuring error responses consistently

## REST API Design

### Schema-First Design Process

1. **Define resources** — What entities does your API expose?
2. **Define relationships** — How do resources relate to each other?
3. **Define operations** — What can clients do with each resource?
4. **Define representations** — What does each resource look like in JSON?
5. **Define status codes** — What HTTP status for each outcome?

### URL Structure

```
# ✅ Resource-based URLs (nouns, not verbs)
GET    /api/v1/users          # List users
POST   /api/v1/users          # Create user
GET    /api/v1/users/:id      # Get user
PATCH  /api/v1/users/:id      # Update user
DELETE /api/v1/users/:id      # Delete user

# ✅ Nested resources (limit to 1 level of nesting)
GET    /api/v1/users/:id/posts       # User's posts
POST   /api/v1/users/:id/posts       # Create post for user

# ✅ Actions as sub-resources (when not CRUD)
POST   /api/v1/users/:id/activate    # Activate user
POST   /api/v1/orders/:id/cancel     # Cancel order

# ❌ Avoid verb-based URLs
GET    /api/v1/getUsers
POST   /api/v1/createUser
POST   /api/v1/deleteUser/123
```

### Response Format

```json
// ✅ Consistent envelope
{
  "data": {
    "id": "usr_abc123",
    "name": "Jane Doe",
    "email": "jane@example.com"
  },
  "meta": {
    "request_id": "req_xyz789",
    "timestamp": "2025-01-15T10:30:00Z"
  }
}

// ✅ Collection with pagination
{
  "data": [
    { "id": "usr_abc123", "name": "Jane Doe" }
  ],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 156,
    "total_pages": 8
  },
  "links": {
    "self": "/api/v1/users?page=1",
    "next": "/api/v1/users?page=2",
    "last": "/api/v1/users?page=8"
  }
}

// ✅ Error response
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address",
        "value": "not-an-email"
      }
    ],
    "request_id": "req_xyz789"
  }
}
```

### HTTP Status Codes

| Code | Meaning | When to Use |
|------|---------|-------------|
| 200 | OK | Successful GET, PATCH, DELETE |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE with no body |
| 400 | Bad Request | Validation failure, malformed input |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Authenticated but not authorized |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource, state conflict |
| 422 | Unprocessable Entity | Semantic validation failure |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server failure |

### Filtering, Sorting, Pagination

```
# Filtering (field=value, supports operators)
GET /api/v1/users?status=active&created_after=2025-01-01

# Sorting (field for asc, -field for desc)
GET /api/v1/users?sort=-created_at,name

# Pagination (cursor-based for large datasets)
GET /api/v1/users?cursor=abc123&limit=20

# Pagination (offset-based for small datasets)
GET /api/v1/users?page=2&per_page=20

# Field selection (sparse fieldsets)
GET /api/v1/users?fields=id,name,email

# Include related resources
GET /api/v1/users/:id?include=posts,profile
```

## GraphQL API Design

### Schema-First Approach

```graphql
# Schema definition comes before implementation

type User {
  id: ID!
  name: String!
  email: String!
  role: Role!
  posts(limit: Int = 10): [Post!]!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  tags: [Tag!]!
  publishedAt: DateTime
}

enum Role {
  ADMIN
  EDITOR
  VIEWER
}

# Queries (read operations)
type Query {
  user(id: ID!): User
  users(
    filter: UserFilter
    sort: UserSort
    first: Int = 20
    after: String
  ): UserConnection!
  post(id: ID!): Post
}

# Mutations (write operations)
type Mutation {
  createUser(input: CreateUserInput!): CreateUserPayload!
  updateUser(id: ID!, input: UpdateUserInput!): UpdateUserPayload!
  deleteUser(id: ID!): DeleteUserPayload!
}

# Subscriptions (real-time)
type Subscription {
  userUpdated(id: ID): User!
  postCreated(authorId: ID): Post!
}

# Input types (separate from output types)
input CreateUserInput {
  name: String!
  email: String!
  role: Role = VIEWER
}

# Payload types (for consistent mutation responses)
type CreateUserPayload {
  user: User
  errors: [FieldError!]
}

type FieldError {
  field: String!
  message: String!
  code: String!
}
```

### GraphQL Best Practices

- **Separate input and output types** — CreateUserInput ≠ User
- **Use cursor-based pagination** — `first/after` pattern with Connection types
- **N+1 prevention** — Use DataLoader for batched fetching
- **Nullability** — Mark fields `!` only when they're guaranteed to exist
- **Versioning** — Evolve schema (add fields, never remove); avoid versioned endpoints
- **Depth limiting** — Cap query depth to prevent abuse (max 5-7 levels)
- **Cost analysis** — Assign complexity scores and limit per-query cost

## Authentication

### JWT Pattern

```typescript
// Token structure
interface TokenPayload {
  sub: string;      // User ID
  iat: number;      // Issued at
  exp: number;      // Expiration
  role: string;     // Authorization role
  scope: string[];  // Permission scopes
}

// Middleware pattern
async function authMiddleware(req, res, next) {
  const token = extractBearerToken(req);
  if (!token) {
    return res.status(401).json({
      error: { code: 'UNAUTHORIZED', message: 'Missing authorization token' }
    });
  }

  try {
    const payload = verifyToken(token);
    req.user = payload;
    next();
  } catch (err) {
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({
        error: { code: 'TOKEN_EXPIRED', message: 'Token has expired' }
      });
    }
    return res.status(401).json({
      error: { code: 'INVALID_TOKEN', message: 'Token is invalid' }
    });
  }
}

// Role-based access
function requireRole(...roles: string[]) {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        error: { code: 'FORBIDDEN', message: 'Insufficient permissions' }
      });
    }
    next();
  };
}
```

### API Key Pattern

```typescript
// For service-to-service or third-party access
interface ApiKey {
  key: string;          // Hashed in storage
  prefix: string;       // First 8 chars for identification
  scopes: string[];     // Permitted operations
  rate_limit: number;   // Requests per minute
  expires_at: Date;
}

// Header: X-API-Key: ak_live_abc123def456
```

## Rate Limiting

### Implementation Strategies

```typescript
// Sliding window rate limiter (Redis-backed)
async function rateLimiter(
  key: string,
  limit: number,
  windowMs: number
): Promise<{ allowed: boolean; remaining: number; resetAt: number }> {
  const now = Date.now();
  const windowKey = `ratelimit:${key}`;

  // Remove expired entries and add current request
  const pipeline = redis.pipeline();
  pipeline.zremrangebyscore(windowKey, 0, now - windowMs);
  pipeline.zadd(windowKey, now, `${now}-${Math.random()}`);
  pipeline.zcard(windowKey);
  pipeline.pexpire(windowKey, windowMs);

  const results = await pipeline.exec();
  const count = results[2][1] as number;

  return {
    allowed: count <= limit,
    remaining: Math.max(0, limit - count),
    resetAt: now + windowMs,
  };
}
```

### Rate Limit Headers

```
X-RateLimit-Limit: 100          # Max requests per window
X-RateLimit-Remaining: 67       # Remaining in current window
X-RateLimit-Reset: 1704067200   # Unix timestamp when window resets
Retry-After: 30                 # Seconds to wait (only on 429)
```

### Rate Limit Tiers

| Tier | Limit | Use Case |
|------|-------|----------|
| Anonymous | 30 req/min | Unauthenticated exploration |
| Authenticated | 100 req/min | Normal user operations |
| Premium | 300 req/min | Power users, internal services |
| Service | 1000 req/min | Backend service-to-service |

## Versioning

### Strategies Comparison

| Strategy | URL Pattern | Pros | Cons |
|----------|------------|------|------|
| **URL path** | `/api/v1/users` | Explicit, cacheable | URL changes |
| **Header** | `Accept: application/vnd.api.v1+json` | Clean URLs | Hidden in headers |
| **Query param** | `/api/users?version=1` | Simple | Not RESTful, caching issues |

**Recommendation:** URL path versioning for REST, schema evolution for GraphQL.

### Versioning Workflow

1. **New version** — Create new route prefix or endpoint
2. **Deprecation notice** — Add `Sunset` and `Deprecation` headers to old version
3. **Migration period** — Support both versions for 6+ months
4. **Communication** — Email, changelog, header notices
5. **Sunset** — Remove old version, return 410 Gone

## Error Handling

### Error Code System

```typescript
// Structured error codes: DOMAIN_ENTITY_ERROR
const ErrorCodes = {
  // Auth errors (AUTH_*)
  AUTH_UNAUTHORIZED: 'Authentication required',
  AUTH_TOKEN_EXPIRED: 'Token has expired',
  AUTH_FORBIDDEN: 'Insufficient permissions',

  // Validation errors (VAL_*)
  VAL_INVALID_INPUT: 'Request validation failed',
  VAL_MISSING_FIELD: 'Required field is missing',
  VAL_INVALID_FORMAT: 'Field format is invalid',

  // Resource errors (RES_*)
  RES_NOT_FOUND: 'Resource not found',
  RES_CONFLICT: 'Resource already exists',
  RES_GONE: 'Resource has been removed',

  // Rate limit errors (RATE_*)
  RATE_LIMITED: 'Rate limit exceeded',
} as const;

class ApiError extends Error {
  constructor(
    public code: string,
    public status: number,
    message: string,
    public details?: unknown[]
  ) {
    super(message);
  }
}
```

## Tips

- Use schema-first design for both REST and GraphQL — define the contract before implementing
- Return consistent error envelopes with machine-readable codes, not just messages
- Paginate all list endpoints; use cursor-based pagination for large datasets
- Version your REST API in the URL path; evolve your GraphQL schema instead of versioning
- Rate limit by default, even for authenticated users — abuse comes from all sources
- Document with OpenAPI (REST) or introspection + descriptions (GraphQL) — never keep docs separate from code
- Use `Sunset` headers when deprecating endpoints — give clients time to migrate
- Log request IDs for tracing — every error response should include the request ID
