# n8n-evals

A Claude Code plugin that guides you through setting up n8n's native evaluation framework for AI workflows.

## What it does

The plugin teaches Claude how to:

- Set up evaluation triggers with Google Sheets test datasets
- Configure correctness metrics (AI-based) and custom metrics (deterministic)
- Write effective `expected_behavior` descriptions for LLM judges
- Build Data Normalize bridge nodes between eval and production paths
- Handle multi-turn conversation testing
- Avoid critical gotchas (lost `_isEval` flags, credential binding, expression context)

The skill triggers automatically on mentions of n8n evals, evaluation triggers, test datasets, scoring metrics, or regression testing.

## Install

```
/plugin marketplace add 11x-agency/claude-marketplace
/plugin install n8n-evals@11x-marketplace
```
