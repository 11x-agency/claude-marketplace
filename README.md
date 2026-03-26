# 11x Claude Plugins

A [Claude Code plugin marketplace](https://docs.anthropic.com/en/docs/claude-code) by **[11x Agency](https://11x.agency)** — AI-powered automation tools.

## Plugins

| Plugin | Description | Invoke |
|--------|-------------|--------|
| **n8n-agent-cli** | Manage n8n workflows, executions, variables, and tags via the n8n-agent-cli | `/n8n-agent-cli` |

## Install

Add the marketplace to Claude Code:

```
/plugin marketplace add 11x-agency/claude-marketplace
```

Then enable the plugins you want. They'll be available as slash commands in any project.

## Project Setup

To auto-enable plugins for a specific project, add to `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "11x-marketplace": {
      "source": {
        "source": "github",
        "repo": "11x-agency/claude-marketplace"
      }
    }
  },
  "enabledPlugins": {
    "n8n-agent-cli@11x-marketplace": true
  }
}
```

## Structure

```
.claude-plugin/
  marketplace.json        # Plugin catalog
plugins/
  n8n-agent-cli/
    .claude-plugin/
      plugin.json
    skills/
      n8n-agent-cli/
        SKILL.md
    README.md
```

## Contributing

Each plugin lives in `plugins/<name>/`. To add a new plugin:

1. Create `plugins/<name>/.claude-plugin/plugin.json`
2. Add your skill at `plugins/<name>/skills/<name>/SKILL.md`
3. Add a `README.md` to `plugins/<name>/`
4. Register it in `.claude-plugin/marketplace.json`
5. Bump the version in both `plugin.json` and `marketplace.json`

## License

MIT
