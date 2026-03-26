# n8n-agent-cli

A Claude Code plugin that teaches Claude how to use [@11x.agency/n8n-cli](https://github.com/robinsadeghpour/n8n-cli) to manage your n8n instance.

## What it does

The plugin gives Claude knowledge of all n8n-cli commands so it can:

- List, create, update, and delete workflows (with progressive disclosure — summaries by default)
- Debug failed executions and retry them
- Manage variables, tags, credentials, users, and projects
- Paginate through results with cursor-based pagination
- Select specific fields to minimize token usage
- Run security audits and check API connectivity

The skill triggers automatically whenever you mention n8n, workflows, executions, or automations.

## Prerequisites

Install the CLI:

```bash
npm install -g @11x.agency/n8n-cli
```

Or use npx without installing:

```bash
npx @11x.agency/n8n-cli doctor
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

## Links

- [@11x.agency/n8n-cli on npm](https://www.npmjs.com/package/@11x.agency/n8n-cli)
- [Source code on GitHub](https://github.com/robinsadeghpour/n8n-cli)
