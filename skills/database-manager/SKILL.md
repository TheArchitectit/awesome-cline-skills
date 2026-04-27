---
name: database-manager
description: Database operations and management covering schema design, migrations, query optimization, indexing, and backup strategies for PostgreSQL, MySQL, and MongoDB. This skill should be used when designing database schemas, writing migrations, optimizing queries, managing indexes, or performing database administration tasks.
---

# Database Manager

This skill provides structured guidance for database operations across PostgreSQL, MySQL, and MongoDB, covering schema design, migrations, query optimization, and administration patterns.

## Prerequisites

- Database server access (PostgreSQL, MySQL, or MongoDB)
- Basic SQL or query language knowledge
- Migration tool installed (Alembic, Prisma, Django, Flyway, etc.)

## When to Use This Skill

- Designing database schemas for new features
- Writing and managing database migrations
- Optimizing slow queries and adding indexes
- Setting up backup and recovery strategies
- Debugging database connectivity or performance issues
- Choosing between SQL and NoSQL for a use case

## Schema Design

### Relational (PostgreSQL / MySQL)

#### Normalization Guidelines

| Level | Rule | Practical Impact |
|-------|------|-----------------|
| 1NF | Atomic values, no repeating groups | One value per cell, no comma-separated lists |
| 2NF | All non-key attributes depend on the whole key | No partial dependencies in composite keys |
| 3NF | No transitive dependencies | Non-key fields don't depend on other non-key fields |

**When to denormalize:** Read-heavy analytics, reporting tables, caching computed values. Denormalize intentionally, not accidentally.

#### Table Design Pattern

```sql
-- ✅ Well-designed table
CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email       VARCHAR(255) NOT NULL,
    name        VARCHAR(100) NOT NULL,
    role        VARCHAR(20) NOT NULL DEFAULT 'member'
                CHECK (role IN ('admin', 'editor', 'member')),
    status      VARCHAR(20) NOT NULL DEFAULT 'active'
                CHECK (status IN ('active', 'suspended', 'deleted')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    CONSTRAINT uq_users_email UNIQUE (email)
);

-- Indexes for common query patterns
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_status ON users (status) WHERE status = 'active';

-- Auto-update updated_at (PostgreSQL)
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

#### Relationship Patterns

```sql
-- One-to-Many (foreign key)
CREATE TABLE posts (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title       VARCHAR(500) NOT NULL,
    content     TEXT,
    published   BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_posts_author ON posts (author_id);

-- Many-to-Many (junction table)
CREATE TABLE post_tags (
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    tag_id  UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

-- Polymorphic (use with caution)
CREATE TABLE comments (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id   UUID NOT NULL REFERENCES users(id),
    body        TEXT NOT NULL,
    target_type VARCHAR(20) NOT NULL CHECK (target_type IN ('post', 'page')),
    target_id   UUID NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- Note: Polymorphic can't use FK constraints. Prefer separate tables
-- (post_comments, page_comments) or a base table pattern.
```

### Document (MongoDB)

#### Collection Design Patterns

```javascript
// ✅ Embedded documents (one-to-few, data accessed together)
{
  _id: ObjectId("..."),
  name: "Jane Doe",
  email: "jane@example.com",
  addresses: [
    { type: "home", street: "123 Main St", city: "Austin", state: "TX" },
    { type: "work", street: "456 Tech Blvd", city: "Austin", state: "TX" }
  ]
}
// Rule: Embed if array won't exceed ~100 items and doesn't grow unbounded

// ✅ Referenced documents (one-to-many, data accessed separately)
// users collection
{ _id: ObjectId("usr1"), name: "Jane" }

// posts collection  
{ _id: ObjectId("pst1"), author_id: ObjectId("usr1"), title: "Hello" }

// ✅ Hybrid pattern (embed summary, reference full data)
// products collection
{
  _id: ObjectId("prod1"),
  name: "Widget",
  category: { _id: ObjectId("cat1"), name: "Electronics" },  // Embed name for display
  // Full category data lives in categories collection
}
```

#### MongoDB Schema Rules

| Pattern | When to Use | Avoid When |
|---------|------------|------------|
| **Embed** | Few items, always read together, <16MB doc | Unbounded arrays, frequent updates |
| **Reference** | Many items, accessed independently | Always joining (consider embedding) |
| **Hybrid** | Frequent display of summary data | Summary data changes often |
| **Bucket** | Time-series, IoT data (group by hour/day) | Sparse, irregular time intervals |

## Migrations

### Migration Best Practices

1. **Forward-only in production** — Never edit a shipped migration
2. **Reversible in development** — Write `down` migrations for local dev
3. **Small and focused** — One migration per logical change
4. **Data migrations separate** — Don't mix schema and data changes
5. **Test on production-like data** — Migrations on empty DBs hide problems

### Migration Workflow

```bash
# Using Alembic (Python/PostgreSQL)
alembic revision --autogenerate -m "add_users_table"
alembic upgrade head
alembic downgrade -1       # Rollback last migration

# Using Prisma (TypeScript)
npx prisma migrate dev --name add_users_table
npx prisma migrate deploy  # Production: apply without prompting

# Using Flyway (Java/any)
flyway migrate
flyway undo               # Requires Flyway Teams edition
```

### Safe Migration Patterns

```sql
-- ✅ Adding a nullable column (non-blocking)
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- ✅ Adding column with default (PostgreSQL 11+/MySQL 8+, non-blocking)
ALTER TABLE users ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'active';

-- ⚠️ Adding NOT NULL column without default (blocks table)
-- Step 1: Add nullable
ALTER TABLE users ADD COLUMN preferred_name VARCHAR(100);
-- Step 2: Backfill in batches
UPDATE users SET preferred_name = name WHERE preferred_name IS NULL LIMIT 1000;
-- Step 3: Add NOT NULL constraint
ALTER TABLE users ALTER COLUMN preferred_name SET NOT NULL;

-- ✅ Adding index concurrently (PostgreSQL, non-blocking)
CREATE INDEX CONCURRENTLY idx_users_email ON users (email);

-- ✅ Renaming column (multi-step for zero downtime)
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN full_name VARCHAR(200);
-- Step 2: Dual-write to both columns
-- Step 3: Backfill full_name from name
-- Step 4: Drop old column
ALTER TABLE users DROP COLUMN name;

-- ❌ Dangerous: Dropping column in use
-- Always verify no code references column before dropping
```

### MongoDB Migrations

```javascript
// migrations/001_add_user_status.js
module.exports = {
  async up(db) {
    // Add status field to all users without one
    await db.collection('users').updateMany(
      { status: { $exists: false } },
      { $set: { status: 'active', updatedAt: new Date() } }
    );
    // Create index
    await db.collection('users').createIndex({ status: 1 });
  },

  async down(db) {
    await db.collection('users').dropIndex('status_1');
    await db.collection('users').updateMany(
      {},
      { $unset: { status: '' } }
    );
  }
};
```

## Query Optimization

### Identifying Slow Queries

```sql
-- PostgreSQL: Find slow queries
SELECT query, mean_exec_time, calls, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- PostgreSQL: Current running queries
SELECT pid, now() - pg_stat_activity.query_start AS duration, query
FROM pg_stat_activity
WHERE state = 'active' AND query NOT LIKE '%pg_stat_activity%'
ORDER BY duration DESC;

-- MySQL: Slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;  -- Log queries over 1 second
SHOW VARIABLES LIKE 'slow_query_log_file';

-- MongoDB: Profiling
db.setProfilingLevel(1, { slowms: 100 });  // Log queries over 100ms
db.system.profile.find().sort({ ts: -1 }).limit(10);
```

### EXPLAIN Analysis

```sql
-- PostgreSQL
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT u.name, COUNT(p.id) as post_count
FROM users u
JOIN posts p ON p.author_id = u.id
WHERE u.status = 'active'
GROUP BY u.id, u.name
ORDER BY post_count DESC
LIMIT 10;

-- Key things to look for:
-- Seq Scan → should be Index Scan for filtered tables
-- Nested Loop → ok for small sets, problem for large
-- Sort → should have index supporting ORDER BY
-- Hash Join → generally good for large joins
-- Buffers: shared hit vs. shared read (cache effectiveness)
```

### Index Strategy

```sql
-- ✅ B-tree index (default, for =, <, >, BETWEEN, ORDER BY)
CREATE INDEX idx_posts_published ON posts (published) WHERE published = TRUE;

-- ✅ Composite index (column order matters: equality → range)
CREATE INDEX idx_posts_author_published ON posts (author_id, published);

-- ✅ Partial index (smaller, faster for filtered queries)
CREATE INDEX idx_users_active_email ON users (email) WHERE status = 'active';

-- ✅ Covering index (include columns to avoid table lookup)
CREATE INDEX idx_posts_covering ON posts (author_id) INCLUDE (title, published);

-- ✅ GIN index (full-text search, JSONB, arrays)
CREATE INDEX idx_posts_content_search ON posts USING GIN (to_tsvector('english', content));

-- ✅ Unique index (enforce uniqueness + fast lookups)
CREATE UNIQUE INDEX idx_users_email_unique ON users (email);

-- ❌ Over-indexing (every index slows writes)
-- Rule: Add index when query is slow AND query runs frequently
```

### Query Rewrite Patterns

```sql
-- ❌ SELECT * (transfers unnecessary data)
SELECT * FROM users WHERE status = 'active';

-- ✅ Select only needed columns
SELECT id, name, email FROM users WHERE status = 'active';

-- ❌ OR condition that prevents index usage
SELECT * FROM posts WHERE author_id = 'abc' OR status = 'published';

-- ✅ UNION ALL with indexed queries
SELECT * FROM posts WHERE author_id = 'abc'
UNION ALL
SELECT * FROM posts WHERE status = 'published' AND author_id != 'abc';

-- ❌ OFFSET for deep pagination (scans and discards rows)
SELECT * FROM posts ORDER BY created_at DESC LIMIT 20 OFFSET 10000;

-- ✅ Keyset/cursor pagination (uses index efficiently)
SELECT * FROM posts WHERE created_at < '2025-01-01' ORDER BY created_at DESC LIMIT 20;
```

## Backup & Recovery

### PostgreSQL

```bash
# Logical backup
pg_dump -Fc dbname > dbname_$(date +%Y%m%d).dump

# Restore
pg_restore -d dbname dbname_20250115.dump

# Continuous archiving (Point-in-Time Recovery)
# postgresql.conf:
#   wal_level = replica
#   archive_mode = on
#   archive_command = 'cp %p /var/lib/postgresql/archive/%f'
```

### MongoDB

```bash
# Full backup
mongodump --uri="mongodb://localhost:27017/mydb" --out=/backup/$(date +%Y%m%d)

# Restore
mongorestore --uri="mongodb://localhost:27017/mydb" /backup/20250115/mydb

# Oplog for point-in-time recovery
mongodump --oplog --uri="mongodb://localhost:27017"
```

## Error Handling

### Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| Connection refused | Server not running or wrong port | Check server status, verify port |
| Too many connections | Connection leak | Use connection pooling, close connections |
| Deadlock | Circular lock dependency | Retry with backoff, reduce transaction scope |
| Slow query | Missing index or bad plan | Run EXPLAIN, add index, rewrite query |
| Migration failed | Mid-state schema | Fix migration, run manually, mark as applied |
| Lock wait timeout | Long-running transaction | Identify blocker: `pg_locks` / `SHOW PROCESSLIST` |

### Connection Pooling

```python
# Python (using SQLAlchemy)
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool

engine = create_engine(
    "postgresql://user:pass@localhost/db",
    poolclass=QueuePool,
    pool_size=10,          # Persistent connections
    max_overflow=20,       # Additional connections allowed
    pool_timeout=30,       # Wait time for connection
    pool_recycle=3600,     # Recycle after 1 hour
    pool_pre_ping=True,    # Verify connection before use
)
```

## Tips

- Use UUIDs over auto-increment IDs for distributed systems; auto-increment for simple apps
- Always add indexes for foreign keys — most databases don't do this automatically
- Use `CONCURRENTLY` for index creation on production PostgreSQL (non-blocking)
- Test migrations on a production-sized dataset before running in production
- Enable query logging/profiling in development; review slow queries before deploy
- Set up automated backups and test restoration regularly — an untested backup isn't a backup
- For MongoDB, prefer embedding for read-heavy access patterns and referencing for write-heavy ones

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/database-manager/` (project-level) or `~/.cline/skills/database-manager/` (global)
2. **Activation**: Cline will suggest this skill when you work with database schemas, migrations, queries, or indexing
3. **Progressive loading**: Only metadata loads initially; full database patterns activate via `use_skill` when database work begins
