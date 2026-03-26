---
name: n8n-agent-cli
description: Manage n8n workflows, executions, variables, tags, credentials, users, and projects via @11x.agency/n8n-cli. Use this skill whenever the user wants to interact with their n8n instance — listing workflows, checking execution status, debugging failed runs, activating/deactivating workflows, managing variables, or any n8n API operation. Trigger on mentions of n8n, workflows, automations, executions, or n8n-cli.
---

# @11x.agency/n8n-cli

A lightweight CLI for the n8n REST API. Use it instead of the n8n MCP server when you need fast, low-overhead n8n operations.

**Package:** [@11x.agency/n8n-cli](https://www.npmjs.com/package/@11x.agency/n8n-cli)

## Install

```bash
npm install -g @11x.agency/n8n-cli
```

Or run any command directly without installing:

```bash
npx @11x.agency/n8n-cli <command>
```

## Prerequisites

The CLI needs two environment variables. Check they're set before running commands — if either is missing, the CLI exits with code 2:

```bash
export N8N_BASE_URL="https://your-n8n-instance.com"
export N8N_API_KEY="your-api-key"
```

If unsure whether the connection works, run `n8n-cli doctor` first.

## Progressive Disclosure

List commands return **summary fields only** to minimize token usage. Use `get` for full detail.

- `workflow list` → id, name, active, createdAt, updatedAt (no nodes/connections)
- `workflow get <id>` → full workflow with nodes, connections, settings

Override summary fields with `--fields`:
```bash
n8n-cli workflow list --fields id,name --json
```

## Output Modes

- `--json` — compact JSON (no whitespace, optimized for agents)
- `--quiet` — compact JSON (same as --json)
- default — pretty-printed JSON (human-readable)

## Pagination

All list commands support cursor-based pagination:
```bash
n8n-cli workflow list --limit 10 --json           # first 10
n8n-cli workflow list --limit 10 --cursor <cur>    # next page
```

Responses include `nextCursor` for the next page:
```json
{"data":[...],"nextCursor":"abc123"}
```

## Commands

### Workflows

```bash
n8n-cli workflow list --json                       # Summary: id, name, active
n8n-cli workflow list --active true --json          # Filter active only
n8n-cli workflow list --tags "production" --json    # Filter by tag
n8n-cli workflow list --name "Order" --json         # Filter by name
n8n-cli workflow get <id> --json                   # Full detail with nodes
n8n-cli workflow create '<json>'                   # Create from JSON
n8n-cli workflow update <id> '<json>'              # Update workflow
n8n-cli workflow delete <id>                       # Delete
n8n-cli workflow activate <id>                     # Turn on
n8n-cli workflow deactivate <id>                   # Turn off
n8n-cli workflow run <id>                          # Trigger, returns executionId
```

### Executions

```bash
n8n-cli execution list --json                      # Summary: id, workflowId, status
n8n-cli execution list --status failed --json      # Filter by status
n8n-cli execution list --workflow-id <id> --json   # Filter by workflow
n8n-cli execution list --include-data --json       # Include full execution data
n8n-cli execution get <id> --json                  # Full detail
n8n-cli execution retry <id>                       # Retry failed
n8n-cli execution stop <id>                        # Stop running
n8n-cli execution delete <id>                      # Delete
```

### Variables

```bash
n8n-cli variable list --json                       # All variables
n8n-cli variable get <id> --json                   # Get by ID
n8n-cli variable set <key> <value>                 # Create/update
n8n-cli variable delete <id>                       # Delete
```

### Tags

```bash
n8n-cli tag list --json                            # All tags
n8n-cli tag get <id> --json                        # Get by ID
n8n-cli tag create <name>                          # Create
n8n-cli tag update <id> <name>                     # Rename
n8n-cli tag delete <id>                            # Delete
```

### Credentials

```bash
n8n-cli credential list --json                     # Summary: id, name, type
n8n-cli credential get <id> --json                 # Full detail
n8n-cli credential create '<json>'                 # Create credential
n8n-cli credential delete <id>                     # Delete
n8n-cli credential schema <type>                   # Get schema for type
```

### Users

```bash
n8n-cli user list --json                           # Summary: id, email, role
n8n-cli user list --include-role --json             # Include role field
n8n-cli user get <id> --json                       # Full detail
```

### Projects

```bash
n8n-cli project list --json                        # Summary: id, name, type
n8n-cli project get <id> --json                    # Full detail
n8n-cli project create '<json>'                    # Create project
n8n-cli project update <id> '<json>'               # Update project
n8n-cli project delete <id>                        # Delete
```

### Audit & Diagnostics

```bash
n8n-cli audit generate                             # Security audit
n8n-cli audit generate --categories "credentials,nodes"
n8n-cli doctor                                     # Check API connectivity
```

## Common Patterns

**Debug a failed workflow:**
1. `n8n-cli execution list --status failed --json` — find failures (summary)
2. `n8n-cli execution get <id> --json` — inspect error details (full)
3. `n8n-cli workflow get <workflowId> --json` — examine workflow definition
4. `n8n-cli execution retry <id>` — retry

**Paginate through all workflows:**
```bash
n8n-cli workflow list --limit 20 --json
# read nextCursor from response, then:
n8n-cli workflow list --limit 20 --cursor <nextCursor> --json
```

**Get only IDs and names:**
```bash
n8n-cli workflow list --fields id,name --json
```

## Exit Codes

- `0` — success
- `1` — API error (bad request, not found, server error)
- `2` — missing configuration or arguments
