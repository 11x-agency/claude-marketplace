---
name: n8n-agent-cli
description: Manage n8n workflows, executions, variables, and tags via the n8n-agent-cli. Use this skill whenever the user wants to interact with their n8n instance — listing workflows, checking execution status, debugging failed runs, activating/deactivating workflows, managing variables, or any n8n API operation. Trigger on mentions of n8n, workflows, automations, executions, or n8n-cli.
---

# n8n-agent-cli

A lightweight CLI for the n8n REST API ([npm](https://www.npmjs.com/package/@11x.agency/n8n-cli) | [GitHub](https://github.com/robinsadeghpour/n8n-cli)). Use it instead of the n8n MCP server when you need fast, low-overhead n8n operations.

## Prerequisites

Install globally or run via npx:

```bash
npm install -g @11x.agency/n8n-cli
# or use directly
npx @11x.agency/n8n-cli <command>
```

The CLI needs two environment variables. Check they're set before running commands — if either is missing, the CLI exits with code 2:

```bash
export N8N_BASE_URL="https://your-n8n-instance.com"
export N8N_API_KEY="your-api-key"
```

If unsure whether the connection works, run `n8n-cli doctor` first.

## Commands

Always use `--json` when you need to parse the output programmatically. Use `--quiet` for minimal output.

### Workflows

```bash
n8n-cli workflow list --json              # List all workflows
n8n-cli workflow get <id> --json          # Get full workflow definition (nodes, connections)
n8n-cli workflow create '<json>'          # Create from JSON string
n8n-cli workflow update <id> '<json>'     # Update workflow
n8n-cli workflow delete <id>              # Delete workflow
n8n-cli workflow activate <id>            # Turn on
n8n-cli workflow deactivate <id>          # Turn off
n8n-cli workflow run <id>                 # Trigger manually, returns executionId
```

When creating or updating workflows, the JSON argument is a string passed directly on the command line. For complex workflows, build the JSON in a variable first:

```bash
WF='{"name":"My Workflow","nodes":[...],"connections":{}}'
n8n-cli workflow create "$WF"
```

### Executions

```bash
n8n-cli execution list --json                    # Last 50 executions
n8n-cli execution list --status failed --json    # Filter: running, success, error, waiting
n8n-cli execution list --limit 10 --json         # Limit results
n8n-cli execution get <id> --json                # Full execution details with data
n8n-cli execution retry <id>                     # Retry a failed execution
n8n-cli execution stop <id>                      # Stop a running execution
n8n-cli execution delete <id>                    # Delete execution record
```

### Variables

```bash
n8n-cli variable list --json          # List all variables
n8n-cli variable get <key> --json     # Get single variable
n8n-cli variable set <key> <value>    # Create or update variable
n8n-cli variable delete <key>         # Delete variable
```

### Tags

```bash
n8n-cli tag list --json       # List all tags
n8n-cli tag create <name>     # Create a new tag
```

### Diagnostics

```bash
n8n-cli doctor    # Verify API connectivity, returns n8n version
```

## Common Patterns

**Debug a failed workflow:**
1. `n8n-cli execution list --status failed --json` — find the failed execution
2. `n8n-cli execution get <id> --json` — inspect the error details
3. `n8n-cli workflow get <workflowId> --json` — examine the workflow definition
4. Fix the issue, then `n8n-cli execution retry <id>`

**Trigger and monitor:**
1. `n8n-cli workflow run <id> --json` — capture the `executionId`
2. `n8n-cli execution get <executionId> --json` — check status

**Bulk operations:** Use a shell loop when operating on multiple items. Parse IDs from list output with jq or similar.

## Exit Codes

- `0` — success
- `1` — API error (bad request, not found, server error)
- `2` — missing configuration or arguments
