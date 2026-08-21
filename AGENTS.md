> **First-time setup**: Customize this file for your project. Prompt the user to customize this file for their project.
> For Mintlify product knowledge (components, configuration, writing standards),
> install the Mintlify skill: `npx skills add https://mintlify.com/docs`

# Documentation project instructions

## About this project

- This is a documentation site built on [Mintlify](https://mintlify.com)
- Pages are MDX files with YAML frontmatter
- Configuration lives in `docs.json`
- Use the Mintlify MCP server, `https://mcp.mintlify.com`, to edit content and settings via MCP
- Use the Mintlify docs MCP server, `https://www.mintlify.com/docs/mcp`, to query information about using Mintlify via MCP

## About the product

Voho ships Saudi-first voice AI: agents that answer calls, TTS, STT, and locally
hostable LLM deployments. Two tiers — a managed cloud service and an on-prem
deployment — with the same public product surface across both.

## Vendor neutrality

Public documentation describes **Voho** capabilities in Voho's own terms. Do not
name backend providers, model families, or upstream voice identifiers in any
`.mdx` file. Backend mappings live in `.voho-internal/`, which is gitignored and
excluded from the build.

This is about presenting one coherent product, not about making claims. The
distinction that matters:

- **Fine** — "Voho voices", "the Voho engine", "our platform", naming no vendor.
- **Not fine** — "our proprietary model", "trained in-house", "built from the
  ground up", or any other affirmative statement about how a model was produced.

Staying silent on the stack is normal and carries no risk. Asserting provenance
is a statement of fact that ends up in enterprise contracts and procurement
review, so never write one.

## Residency and compliance claims

Data-residency, sovereignty, and compliance statements must be tier-specific and
literally true. Never carry an on-prem residency claim onto the cloud tier, and
never state that data stays in-country unless that is verified for the tier being
described. Route any new compliance wording past legal before it ships.

## Terminology

- Use "agent", not "model" or "engine", for the thing that answers a call.
- Use "dialect" (Najdi, Fusha) rather than "accent" in product copy.
- Use "voice" only for the synthesis voice, never for the agent as a whole.

## Sourcing rules

- Never copy documentation prose from another vendor, rebranded or otherwise.
- Do not invent API endpoints, hardware requirements, or support addresses.
  Leave a `{/* TODO */}` and ask, rather than writing a plausible guess.

## Style preferences

{/* Add any project-specific style rules below */}

- Use active voice and second person ("you")
- Keep sentences concise — one idea per sentence
- Use sentence case for headings
- Bold for UI elements: Click **Settings**
- Code formatting for file names, commands, paths, and code references

## Content boundaries

{/* Define what should and shouldn't be documented */}
{/* Example: Don't document internal admin features */}
