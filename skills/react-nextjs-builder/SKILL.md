---
name: react-nextjs-builder
description: React and Next.js development guide covering component architecture, SSR/SSG strategies, API routes, state management, and performance optimization. This skill should be used when building React applications, Next.js projects, designing component hierarchies, implementing server-side rendering, or creating full-stack React apps with API routes.
---

# React & Next.js Builder

This skill provides structured guidance for building modern React and Next.js applications, covering component architecture, rendering strategies, API design, and production best practices.

## Prerequisites

- Node.js 18+ and npm/pnpm
- React 18+ and Next.js 13+ (App Router)
- TypeScript (strongly recommended)

## When to Use This Skill

- Building new React or Next.js applications
- Designing component architecture and hierarchies
- Choosing between SSR, SSG, ISR, and CSR rendering strategies
- Creating API routes and server actions
- Implementing state management patterns
- Optimizing React application performance

## Component Architecture

### Component Design Principles

1. **Single Responsibility** — Each component does one thing well
2. **Composition over Props** — Use children and slots over prop drilling
3. **Colocation** — Keep related code close (tests, styles, utilities near components)
4. **Extraction Threshold** — Extract when a component is reused 3+ times or exceeds ~150 lines

### Component Categories

| Category | Purpose | Example |
|----------|---------|---------|
| **Page** | Route-level layout, data fetching | `app/dashboard/page.tsx` |
| **Layout** | Shared structure across routes | `app/layout.tsx` |
| **Feature** | Domain-specific UI block | `components/dashboard/StatsGrid.tsx` |
| **UI** | Generic, reusable primitives | `components/ui/Button.tsx` |
| **Provider** | Context wrappers | `components/providers/AuthProvider.tsx` |

### Project Structure (App Router)

```
src/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Route group (no URL segment)
│   │   ├── login/
│   │   └── register/
│   ├── (dashboard)/       # Route group with layout
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── settings/
│   ├── api/               # API routes
│   │   └── health/
│   ├── layout.tsx         # Root layout
│   └── page.tsx           # Home page
├── components/
│   ├── ui/                # Generic UI primitives (Button, Input, Dialog)
│   ├── features/          # Domain-specific components
│   │   ├── auth/
│   │   └── dashboard/
│   └── providers/         # Context providers
├── lib/                   # Shared utilities
│   ├── api.ts             # API client helpers
│   ├── utils.ts           # Pure utility functions
│   └── validations.ts     # Zod schemas
├── hooks/                 # Custom React hooks
├── types/                 # TypeScript type definitions
└── styles/                # Global styles, Tailwind config
```

### Component Template

```tsx
// components/ui/Card.tsx
import { type ReactNode } from 'react'

interface CardProps {
  children: ReactNode
  title?: string
  variant?: 'default' | 'bordered' | 'elevated'
  className?: string
}

export function Card({ 
  children, 
  title, 
  variant = 'default',
  className = '' 
}: CardProps) {
  const variantClasses = {
    default: 'bg-white rounded-lg p-6',
    bordered: 'bg-white rounded-lg p-6 border border-gray-200',
    elevated: 'bg-white rounded-lg p-6 shadow-md',
  }

  return (
    <div className={`${variantClasses[variant]} ${className}`}>
      {title && <h3 className="text-lg font-semibold mb-4">{title}</h3>}
      {children}
    </div>
  )
}
```

## Rendering Strategies

### Decision Matrix

| Strategy | When to Use | Data Freshness | Performance |
|----------|-------------|---------------|-------------|
| **SSG** | Static content, blogs, docs | Build time | ⚡ Fastest |
| **ISR** | Semi-dynamic, product pages | Revalidation period | ⚡ Fast |
| **SSR** | Personalized, real-time data | Every request | 🔄 Moderate |
| **CSR** | Highly interactive, auth-gated | Client fetch | 🐢 Varies |
| **Streaming** | Heavy pages, progressive load | Hybrid | ⚡ Per section |

### Server vs Client Components

```tsx
// ✅ Server Component (default in App Router)
// - Data fetching directly
// - Access backend resources
// - Reduce client JavaScript
// No "use client" directive needed

// app/dashboard/page.tsx
import { getUser } from '@/lib/auth'
import { DashboardClient } from './DashboardClient'

export default async function DashboardPage() {
  const user = await getUser()  // Direct async in server component
  
  return (
    <div>
      <h1>Welcome, {user.name}</h1>
      {/* Client component for interactivity */}
      <DashboardClient initialData={user.preferences} />
    </div>
  )
}

// ✅ Client Component (opt-in with "use client")
// - Event handlers (onClick, onChange)
// - React hooks (useState, useEffect)
// - Browser-only APIs
// - State management

// app/dashboard/DashboardClient.tsx
'use client'

import { useState } from 'react'

interface DashboardClientProps {
  initialData: UserPreferences
}

export function DashboardClient({ initialData }: DashboardClientProps) {
  const [data, setData] = useState(initialData)
  
  return (
    <button onClick={() => setData(refresh(data))}>
      Refresh
    </button>
  )
}
```

### Static Generation with ISR

```tsx
// app/blog/[slug]/page.tsx
interface BlogPost {
  title: string
  content: string
  publishedAt: string
}

interface PageProps {
  params: { slug: string }
}

// Generate static pages at build time
export async function generateStaticParams() {
  const posts = await fetch('https://api.example.com/posts').then(r => r.json())
  return posts.map((post: { slug: string }) => ({ slug: post.slug }))
}

// Revalidate every hour (ISR)
export const revalidate = 3600

export default async function BlogPostPage({ params }: PageProps) {
  const post: BlogPost = await fetch(
    `https://api.example.com/posts/${params.slug}`,
    { next: { revalidate: 3600 } }
  ).then(r => r.json())

  return (
    <article>
      <h1>{post.title}</h1>
      <time>{post.publishedAt}</time>
      <div>{post.content}</div>
    </article>
  )
}
```

## API Routes & Server Actions

### API Route Handlers

```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'

const CreateUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
})

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const page = parseInt(searchParams.get('page') || '1')
  const limit = parseInt(searchParams.get('limit') || '10')

  const users = await db.user.findMany({
    skip: (page - 1) * limit,
    take: limit,
  })

  return NextResponse.json({ users, page, limit })
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const validated = CreateUserSchema.parse(body)
    
    const user = await db.user.create({ data: validated })
    return NextResponse.json(user, { status: 201 })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', details: error.errors },
        { status: 400 }
      )
    }
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
```

### Server Actions

```tsx
// app/actions/create-post.ts
'use server'

import { revalidatePath } from 'next/cache'
import { z } from 'zod'

const CreatePostSchema = z.object({
  title: z.string().min(1).max(200),
  content: z.string().min(1),
})

export async function createPost(formData: FormData) {
  const validated = CreatePostSchema.parse({
    title: formData.get('title'),
    content: formData.get('content'),
  })

  const post = await db.post.create({ data: validated })

  // Revalidate the blog page to show new post
  revalidatePath('/blog')
  
  return { success: true, post }
}

// Usage in client component
'use client'

import { useTransition } from 'react'
import { createPost } from '@/app/actions/create-post'

export function CreatePostForm() {
  const [isPending, startTransition] = useTransition()

  return (
    <form action={(formData) => {
      startTransition(() => createPost(formData))
    }}>
      <input name="title" required />
      <textarea name="content" required />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Creating...' : 'Create Post'}
      </button>
    </form>
  )
}
```

## State Management

### State Location Strategy

| State Type | Location | Example |
|-----------|----------|---------|
| **URL state** | Search params, hash | Filters, pagination, current tab |
| **Server state** | Server cache, SWR/TanStack Query | API data, user session |
| **Form state** | Server actions, react-hook-form | Form inputs, validation |
| **Global client state** | Zustand, Jotai | Theme, sidebar open, notifications |
| **Local component state** | useState, useReducer | Toggle, input value, animation |

### Zustand Pattern

```tsx
// stores/auth-store.ts
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface User {
  id: string
  name: string
  email: string
}

interface AuthState {
  user: User | null
  token: string | null
  login: (user: User, token: string) => void
  logout: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      login: (user, token) => set({ user, token }),
      logout: () => set({ user: null, token: null }),
    }),
    { name: 'auth-storage' }
  )
)
```

## Performance Optimization

### Built-in Optimizations

```tsx
import Image from 'next/image'
import Link from 'next/link'
import dynamic from 'next/dynamic'

// ✅ Image optimization (automatic WebP, lazy loading, responsive)
<Image
  src="/hero.jpg"
  alt="Hero image"
  width={1200}
  height={600}
  priority  // Above the fold
  sizes="(max-width: 768px) 100vw, 50vw"
/>

// ✅ Link prefetching (prefetches visible links)
<Link href="/about" prefetch={true}>About</Link>

// ✅ Dynamic imports (code splitting)
const HeavyChart = dynamic(() => import('@/components/HeavyChart'), {
  loading: () => <div className="h-64 animate-pulse bg-gray-100" />,
  ssr: false,  // Skip SSR if browser-only
})
```

### Performance Checklist

- [ ] Use Server Components by default; add `'use client'` only when needed
- [ ] Lazy load heavy components below the fold
- [ ] Use `next/image` for all images with proper `sizes`
- [ ] Implement streaming with `Suspense` for slow data
- [ ] Minimize client-side JavaScript bundle size
- [ ] Use `revalidate` / ISR instead of full SSR for cacheable pages
- [ ] Run `next build` and check the bundle analyzer output

## Error Handling

### Error Boundaries

```tsx
// app/error.tsx (must be client component)
'use client'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen">
      <h2 className="text-2xl font-bold mb-4">Something went wrong</h2>
      <p className="text-gray-600 mb-6">{error.message}</p>
      <button onClick={reset} className="px-4 py-2 bg-blue-600 text-white rounded">
        Try again
      </button>
    </div>
  )
}

// app/not-found.tsx
export default function NotFound() {
  return (
    <div className="text-center py-20">
      <h1 className="text-6xl font-bold">404</h1>
      <p className="mt-4 text-gray-600">Page not found</p>
    </div>
  )
}
```

### Loading States

```tsx
// app/dashboard/loading.tsx (automatic Suspense fallback)
export default function Loading() {
  return (
    <div className="animate-pulse space-y-4">
      <div className="h-8 bg-gray-200 rounded w-1/4" />
      <div className="h-64 bg-gray-200 rounded" />
    </div>
  )
}
```

## Tips

- Default to Server Components; only use `'use client'` when you need interactivity
- Use route groups `(folder)` for organization without affecting URLs
- Co-locate loading, error, and not-found files with their routes
- Validate all API inputs with Zod on both client and server
- Use `generateStaticParams` for pages with known URL segments
- Prefer server actions over API routes for mutations from your own frontend
- Install `@next/bundle-analyzer` to inspect what ships to the client

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/react-nextjs-builder/` (project-level) or `~/.cline/skills/react-nextjs-builder/` (global)
2. **Activation**: Cline will suggest this skill when you're building React or Next.js applications or components
3. **Progressive loading**: Only metadata loads initially; full React/Next.js patterns activate via `use_skill` when web work begins
