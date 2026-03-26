# n8n-agent-cli

A Claude Code plugin that teaches Claude how to use [n8n-agent-cli](https://github.com/robinsadeghpour/n8n-cli) to manage your n8n instance.

## What it does

The plugin gives Claude knowledge of all n8n-agent-cli commands so it can:

- List, create, update, and delete workflows
- Debug failed executions and retry them
- Manage variables and tags
- Check API connectivity

The skill triggers automatically whenever you mention n8n, workflows, executions, or automations.

## Prerequisites

Install the CLI:

```bash
npm install -g n8n-agent-cli
```

Set your n8n credentials:

```bash
export N8N_BASE_URL="https://your-n8n-instance.com"
export N8N_API_KEY="your-api-key"
```

## Install

```
/plugin marketplace add 11x-agency/claude-marketplace
/plugin install n8n-agent-cli@11x-marketplace
```
