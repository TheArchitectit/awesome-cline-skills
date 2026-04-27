---
name: code-refactorer
description: Code refactoring guide covering design patterns, SOLID principles, dead code elimination, performance optimization, and safe refactoring workflows. This skill should be used when restructuring existing code, applying design patterns, reducing technical debt, improving code maintainability, or performing safe incremental refactoring.
---

# Code Refactorer

This skill provides structured guidance for refactoring code safely and effectively, covering design patterns, SOLID principles, dead code elimination, and incremental transformation workflows.

## Prerequisites

- Existing codebase to refactor
- Test suite (essential for safe refactoring)
- Version control (git) for incremental changes

## When to Use This Skill

- Restructuring code without changing behavior
- Applying design patterns to improve architecture
- Reducing technical debt and code complexity
- Eliminating dead code and unused dependencies
- Improving performance through code optimization
- Making code more maintainable and readable

## Refactoring Workflow

### The Golden Rule

**Refactor in small, verified steps.** Each step should:
1. Keep all tests passing
2. Change one thing at a time
3. Be independently committable
4. Be reversible if something goes wrong

### Step-by-Step Process

```
1. IDENTIFY  → What needs to change and why?
2. TEST      → Ensure existing tests cover the behavior
3. REFACTOR  → Make one small change
4. VERIFY    → Run tests, confirm behavior unchanged
5. COMMIT    → Save the increment
6. REPEAT    → Next small change
```

### Before Starting

- [ ] Green test suite — All tests passing before you touch anything
- [ ] Adequate coverage — Critical paths have tests
- [ ] Clean git state — No uncommitted changes
- [ ] Scoped goal — "Extract validation logic from controller" not "clean up the codebase"
- [ ] Time-boxed — Refactoring can expand infinitely; set a limit

### Safety Nets

| Net | Purpose | How |
|-----|---------|-----|
| **Tests** | Verify behavior preservation | Run full suite after each change |
| **Version control** | Revert if needed | Commit after each verified step |
| **Feature flags** | Incremental rollout | New code path behind a flag |
| **Pair programming** | Second pair of eyes | Especially for complex refactors |
| **Branching** | Isolate changes | Refactor on a branch, merge when done |

## SOLID Principles

### Single Responsibility Principle (SRP)

A module should have one reason to change.

```typescript
// ❌ God class doing everything
class UserService {
  createUser(data) { /* ... */ }
  sendWelcomeEmail(user) { /* ... */ }
  generateReport(userId) { /* ... */ }
  syncToCRM(user) { /* ... */ }
}

// ✅ Each class has one responsibility
class UserService {
  createUser(data) { /* ... */ }
}

class EmailService {
  sendWelcomeEmail(user) { /* ... */ }
}

class ReportService {
  generateReport(userId) { /* ... */ }
}

class CRMService {
  syncUser(user) { /* ... */ }
}
```

### Open/Closed Principle (OCP)

Open for extension, closed for modification.

```typescript
// ❌ Must modify to add new discount types
function calculateDiscount(order, type) {
  if (type === 'percentage') return order.total * 0.1;
  if (type === 'fixed') return 10;
  if (type === 'seasonal') return order.total * 0.2;
  // Every new discount type requires modifying this function
}

// ✅ Extend by adding new classes
interface Discount {
  calculate(order: Order): number;
}

class PercentageDiscount implements Discount {
  constructor(private rate: number) {}
  calculate(order: Order): number {
    return order.total * this.rate;
  }
}

class FixedDiscount implements Discount {
  constructor(private amount: number) {}
  calculate(order: Order): number {
    return this.amount;
  }
}

// New discount type = new class, no modification
class LoyaltyDiscount implements Discount {
  calculate(order: Order): number {
    return order.customer.yearsActive * 5;
  }
}
```

### Liskov Substitution Principle (LSP)

Subtypes must be substitutable for their base types.

```typescript
// ❌ Square violates Rectangle's contract
class Rectangle {
  setWidth(w) { this.width = w; }
  setHeight(h) { this.height = h; }
  area() { return this.width * this.height; }
}

class Square extends Rectangle {
  setWidth(w) { this.width = w; this.height = w; }  // Surprising side effect
  setHeight(h) { this.width = h; this.height = h; }  // Breaks expectations
}

// Code expecting Rectangle breaks with Square:
function resize(rectangle) {
  rectangle.setWidth(5);
  rectangle.setHeight(10);
  assert(rectangle.area() === 50);  // Fails with Square: area is 100
}

// ✅ Don't force inheritance where it doesn't fit
class Shape {
  area(): number { throw new Error('Not implemented'); }
}

class Rectangle extends Shape { /* independent width/height */ }
class Square extends Shape { /* single side */ }
```

### Interface Segregation Principle (ISP)

No code should be forced to depend on methods it doesn't use.

```typescript
// ❌ Fat interface
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
}

// Robot forced to implement eat() and sleep()
class Robot implements Worker {
  work() { /* ... */ }
  eat() { throw new Error('Robots do not eat'); }
  sleep() { throw new Error('Robots do not sleep'); }
}

// ✅ Segregated interfaces
interface Workable { work(): void; }
interface Eatable { eat(): void; }
interface Sleepable { sleep(): void; }

class Robot implements Workable {
  work() { /* ... */ }
}

class Human implements Workable, Eatable, Sleepable {
  work() { /* ... */ }
  eat() { /* ... */ }
  sleep() { /* ... */ }
}
```

### Dependency Inversion Principle (DIP)

Depend on abstractions, not concretions.

```typescript
// ❌ High-level module depends on low-level module
class OrderService {
  private emailService = new SMTPEmailService();  // Tightly coupled
  
  placeOrder(order) {
    // ... order logic
    this.emailService.sendConfirmation(order);  // Can't swap for SES, SendGrid, etc.
  }
}

// ✅ Depend on abstraction
interface EmailService {
  send(to: string, subject: string, body: string): Promise<void>;
}

class OrderService {
  constructor(private emailService: EmailService) {}  // Injected dependency
  
  placeOrder(order) {
    // ... order logic
    this.emailService.send(order.email, 'Order Confirmed', '...');
  }
}

// Swap implementation without touching OrderService
new OrderService(new SESEmailService());
new OrderService(new SendGridEmailService());
new OrderService(new MockEmailService());  // Testing!
```

## Design Patterns (Most Useful for Refactoring)

### Strategy Pattern

Replace conditional logic with interchangeable strategies.

```typescript
// ❌ Growing switch statement
function calculateShipping(order, method) {
  switch (method) {
    case 'standard': return order.weight * 0.5 + 5;
    case 'express': return order.weight * 1.0 + 15;
    case 'overnight': return order.weight * 2.0 + 30;
    case 'international': return order.weight * 3.0 + 50;
    default: throw new Error(`Unknown method: ${method}`);
  }
}

// ✅ Strategy pattern
interface ShippingStrategy {
  calculate(order: Order): number;
  getEstimatedDays(): number;
}

const shippingStrategies = {
  standard: new StandardShipping(),
  express: new ExpressShipping(),
  overnight: new OvernightShipping(),
  international: new InternationalShipping(),
};

function calculateShipping(order: Order, method: string): number {
  const strategy = shippingStrategies[method];
  if (!strategy) throw new Error(`Unknown method: ${method}`);
  return strategy.calculate(order);
}
```

### Extract Method

The most common refactoring. Turn a code fragment into a method whose name explains its purpose.

```typescript
// ❌ Long method with embedded logic
function printOwing(invoice) {
  // Print banner
  console.log('*******************');
  console.log('*** Customer Owes ***');
  console.log('*******************');

  // Calculate outstanding
  let outstanding = 0;
  for (const order of invoice.orders) {
    outstanding += order.amount;
  }

  // Print details
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}

// ✅ Extracted methods with descriptive names
function printOwing(invoice: Invoice) {
  printBanner();
  const outstanding = calculateOutstanding(invoice);
  printDetails(invoice, outstanding);
}

function printBanner() {
  console.log('*******************');
  console.log('*** Customer Owes ***');
  console.log('*******************');
}

function calculateOutstanding(invoice: Invoice): number {
  return invoice.orders.reduce((sum, order) => sum + order.amount, 0);
}

function printDetails(invoice: Invoice, outstanding: number) {
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}
```

### Replace Conditional with Polymorphism

```typescript
// ❌ Type-checking conditionals
function getEmployeePay(employee) {
  switch (employee.type) {
    case 'fulltime': return employee.salary;
    case 'parttime': return employee.hours * employee.hourlyRate;
    case 'contractor': return employee.hours * employee.hourlyRate * 1.1;
    case 'intern': return Math.min(employee.hours * 15, 1000);
  }
}

// ✅ Polymorphic dispatch
abstract class Employee {
  abstract getPay(): number;
}

class FullTimeEmployee extends Employee {
  getPay() { return this.salary; }
}

class PartTimeEmployee extends Employee {
  getPay() { return this.hours * this.hourlyRate; }
}

// New types don't require modifying existing code
class ContractorEmployee extends Employee {
  getPay() { return this.hours * this.hourlyRate * 1.1; }
}
```

## Dead Code Elimination

### Finding Dead Code

```bash
# Find unused exports (TypeScript/JavaScript)
npx ts-prune

# Find unused CSS
npx purgecss --css styles.css --content index.html

# Find unused dependencies
npx depcheck

# Find large unused files
find src -type f -mtime +365 -name "*.ts" | head -20

# Git: find files not changed in 6+ months
git log --diff-filter=A --summary --since="6 months ago" --name-only --pretty=format:
```

### Elimination Checklist

1. **Search for references** — IDE "Find Usages" across the project
2. **Check for dynamic access** — `obj[method]()` or `eval()` may hide references
3. **Check external consumers** — Public API may be used by other projects
4. **Mark deprecated first** — Add `@deprecated` JSDoc, log warnings
5. **Remove after grace period** — Wait one release cycle, then delete
6. **Don't comment out code** — Git remembers everything; commenting out is dead code that confuses

```typescript
// ❌ Commented-out code (git remembers it)
// function oldCalculation(data) {
//   return data.x * data.y + data.z;
// }

// ✅ Delete it. If needed, find it in git history
// git log -p -- oldModule.js

// ✅ When deprecating first
/**
 * @deprecated Use calculateV2() instead. Will be removed in v3.0.
 */
function calculateV1(data: Data): number {
  console.warn('calculateV1 is deprecated. Use calculateV2.');
  return calculateV2(data);
}
```

## Performance Optimization

### Measure First

```bash
# Profile before optimizing
# Node.js
node --prof app.js
node --prof-process isolate-*.log

# Python
python -m cProfile -s cumulative app.py

# Browser
# Chrome DevTools → Performance tab → Record → Analyze
```

### Common Optimization Patterns

| Pattern | When to Apply | Impact |
|---------|--------------|--------|
| **Memoization** | Pure functions called repeatedly | Cache results → O(1) repeat calls |
| **Lazy loading** | Expensive computations not always needed | Compute on first access |
| **Batching** | Multiple similar operations | Reduce N calls to 1 |
| **Debouncing** | Frequent events (resize, input) | Execute after pause |
| **Indexing** | Repeated searches in collections | O(n) → O(1) lookups |
| **Pagination** | Large data sets | Process/display subsets |

```typescript
// Memoization
function memoize<T extends (...args: any[]) => any>(fn: T): T {
  const cache = new Map<string, ReturnType<T>>();
  return ((...args: Parameters<T>) => {
    const key = JSON.stringify(args);
    if (cache.has(key)) return cache.get(key);
    const result = fn(...args);
    cache.set(key, result);
    return result;
  }) as T;
}

// Lazy initialization
class ExpensiveResource {
  private _data: Data | null = null;
  
  get data(): Data {
    if (!this._data) {
      this._data = this.loadExpensiveData();  // Only when first accessed
    }
    return this._data;
  }
}
```

## Error Handling

### Common Refactoring Mistakes

| Mistake | Why It's Dangerous | Prevention |
|---------|-------------------|------------|
| Big bang refactor | High risk, hard to revert | Small incremental steps |
| Refactor without tests | No safety net | Write characterization tests first |
| Changing behavior + structure | Bugs hide in mixed changes | One or the other, never both |
| Renaming without find-all | Broken references | IDE refactoring tools, not manual |
| Ignoring external consumers | Breaking public API | Check all callers before changing signatures |

### When to Stop Refactoring

- Tests start failing unexpectedly → Stop, revert, investigate
- The change is no longer small → Re-evaluate scope
- You're "polishing" without measurable benefit → Ship it
- New feature work is blocked too long → Refactor later

## Tips

- Refactor on a green test suite — if tests are red, fix bugs first
- Use your IDE's refactoring tools (rename, extract method, move) — they handle references you might miss
- Read Martin Fowler's "Refactoring" catalog for the full pattern library
- If you can't write a good commit message for a refactor step, the step is too broad
- Characterization tests (tests that document current behavior) are valid even if the current behavior is imperfect — lock it down before changing it
- Flag new technical debt: `// TODO(refactor): extract validation logic` — makes it findable later
- Refactoring is not a phase — it's a continuous activity woven into feature work

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/code-refactorer/` (project-level) or `~/.cline/skills/code-refactorer/` (global)
2. **Activation**: Cline will suggest this skill when you request code restructuring, pattern application, or technical debt reduction
3. **Progressive loading**: Metadata is always in context; detailed refactoring patterns load on demand via `use_skill`
