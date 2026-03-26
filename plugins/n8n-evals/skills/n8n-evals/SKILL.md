---
name: n8n-evals
description: Guide for setting up n8n's native evaluation framework to test AI workflows. Use when creating evals, evaluation triggers, test datasets, scoring metrics, or regression tests for any n8n workflow — especially AI Agent workflows. Also triggers on "n8n eval", "n8n testing", "evaluation trigger", "set metrics", "test my workflow", "regression test", or anything about measuring n8n workflow quality.
---

# n8n Native Evaluation Framework

How to set up automated evaluations for n8n workflows using the built-in evaluation nodes. This captures real lessons from production implementation — the gotchas here are things that cost hours to debug.

## Architecture Overview

Evals live **inside the same workflow** as production — not in a separate copy. The framework uses three special node types that work together:

```
Production path:
  Gmail Trigger → [pipeline] → AI Agent → Format Reply → Gmail Reply

Eval path (same workflow):
  Evaluation Trigger → Data Normalize → [same pipeline] → AI Agent → Format Reply
    → Check if Evaluating [true] → Set Outputs → Set Metrics
    → Check if Evaluating [false] → Gmail Reply (production, skipped during eval)
```

The key insight: both paths share the same processing pipeline. The only fork happens at the end, where eval mode skips the real action (sending email, posting message, etc.) and instead scores the output.

**Important:** The production trigger (e.g., Gmail Trigger) connects directly to the first pipeline node (e.g., Normalize Email). Only the Evaluation Trigger needs the Data Normalize bridge node, because it must convert sheet row format into the format the pipeline expects.

## The Evaluation Nodes

### 1. Evaluation Trigger (`n8n-nodes-base.evaluationTrigger`)

Reads test cases from a Google Sheet, one row at a time. Each row becomes one execution through the workflow.

- **Dataset**: Google Sheets (requires Google Sheets OAuth2 credential)
- **Document**: Your test dataset spreadsheet
- **Sheet**: The sheet tab with test data
- Connect its output to a **Data Normalize** node (NOT directly to the pipeline)

### 2. Check if Evaluating (`operation: "checkIfEvaluating"`)

An IF-style node with two outputs:
- **True branch** → eval path (Set Outputs → Set Metrics)
- **False branch** → production path (send email, etc.)

Place this after your main processing is done (e.g., after Format Reply).

### 3. Set Outputs (`operation: "setOutputs"`)

Writes actual results back to the Google Sheet so you can compare expected vs actual. Requires Google Sheets credential pointed at the same spreadsheet.

Map output columns like:
- `actual_output` → `{{ $('Format Email Reply').item.json.replyBody }}`

### 4. Set Metrics (`operation: "setMetrics"`)

Reports scores to the n8n **Evaluations** tab. This is where scoring happens.

**Two metric types:**

| Type | How it works | When to use |
|------|-------------|-------------|
| **Correctness (AI-based)** | Built-in LLM judge compares expectedAnswer vs actualAnswer | AI behavior evaluation — did the agent do the right thing? |
| **Custom metrics** | You define numeric metrics via expressions | Deterministic checks — did parsing work? Were tools called? |

## Metric Type: Correctness (AI-based)

This is the recommended starting point for evaluating AI agent behavior. It uses an LLM to compare the agent's output against a behavioral description.

### Configuration

In the Set Metrics node:
- **Metric**: Correctness (AI-based)
- **Expected Answer**: Expression pointing to your ground truth (e.g., `{{ $('Data Normalize').item.json._eval?.expected_behavior }}`)
- **Actual Answer**: Expression pointing to agent output (e.g., `{{ $('Format Email Reply').item.json.replyBody }}`)
- **Prompt**: Optional override — leave default unless scores feel off

### The `expected_behavior` Column

The key to making the correctness metric useful is writing good behavioral descriptions — not word-for-word expected output.

**Bad** (too rigid, will fail on valid variations):
```
Thank you for your interest! Could you please provide your height, weight, postcode, and whether you'll use the bike for delivery or commuting?
```

**Good** (describes what the agent SHOULD do):
```
Ask for height, weight, postcode, and purpose (delivery or commuting). Do NOT send pricing. No details are known yet.
```

**Good** (for a case where all info is present):
```
All 4 details complete (height 1.85m, weight 120kg, postcode B296db, purpose delivery). Send DELIVERY pricing: £35/week starter, £29/week after 2 months, £49/week flexi, £0 deposit (£149), £24.9 setup, £25 shipping. Include accessories link plutoebike.com/deliveryriders.
```

### Writing `expected_behavior` — Principles

1. **State what info is known vs missing** — "Height and postcode provided. Missing weight and purpose."
2. **State the correct action** — "Ask for weight and purpose. Do NOT send pricing yet."
3. **Include exact values when accuracy matters** — pricing amounts, URLs, specific facts
4. **Use negative instructions for guardrails** — "Do NOT send pricing", "Do NOT escalate", "Do NOT invent pricing for multiple bikes"
5. **Handle ambiguous cases** — "If asking about X, do Y. If asking about Z, do W."

### Custom Prompt (Override)

The default correctness prompt works well for most cases. Only override it if:
- Scores don't match your gut feeling (passing things that should fail, or vice versa)
- You need domain-specific evaluation logic
- The default is too lenient or too strict

The prompt field is in the Set Metrics node UI. The built-in parser expects the LLM to output a **single score between 0 and 1** — do not ask for JSON or multi-criteria output (it will break the parser).

**When to graduate to a custom prompt:**
1. Run evals with the default prompt first
2. Review cases where the score disagrees with your judgment
3. If there's a pattern (e.g., always passes even with wrong pricing), add domain rules to the prompt
4. Keep it simple — add the specific rule that catches the failure, don't rewrite everything

## Metric Type: Custom Metrics

For deterministic checks that don't need an LLM judge. Add a **Code node** between Set Outputs and Set Metrics to calculate scores.

```javascript
const evalData = $('Data Normalize').first().json._eval || {};
const formatReply = $('Format Email Reply').first().json;
const normalizeOut = $('Normalize Email').first().json;
const metrics = {};

// Pipeline: email parsed correctly
if (evalData.expected_senderEmail) {
  metrics.email_parsed = (normalizeOut.senderEmail === evalData.expected_senderEmail) ? 1 : 0;
}

// Pipeline: quotes stripped correctly
if (evalData.expected_bodyText) {
  const actual = ($('Strip Quoted Text').first().json.bodyText || '').trim();
  const expected = (evalData.expected_bodyText || '').trim();
  metrics.quotes_stripped = (actual === expected) ? 1 : 0;
}

// AI: contains required phrases
if (evalData.expected_contains) {
  const required = evalData.expected_contains.split('|');
  const output = (formatReply.replyBody || '').toLowerCase();
  metrics.contains_required = required.every(p => output.includes(p.toLowerCase().trim())) ? 1 : 0;
}

return [{ json: { ...metrics, test_id: evalData.test_id || 'unknown' } }];
```

Configure in Set Metrics UI: metric type "Custom metrics", add each metric name + expression.

**Note:** Custom metrics config doesn't reliably persist via API. Always configure in the n8n UI.

## Google Sheet Structure

### Required Columns

| Column | Purpose |
|---|---|
| `test_id` | Unique ID (e.g., T-01) |
| `test_name` | Human-readable scenario description |

### Input Columns (match your workflow's trigger format)

| Column | Purpose |
|---|---|
| `raw_from` | Email sender (string or JSON object) |
| `raw_subject` | Email subject line |
| `raw_body` | Email body text |
| `conversation_history` | JSON array of prior messages for multi-turn tests |

### Expected Columns (ground truth)

| Column | Purpose | Used by |
|---|---|---|
| `expected_behavior` | Behavioral description of correct agent response | Correctness metric (AI judge) |
| `expected_senderEmail` | Correct parsed email | Custom metric (deterministic) |
| `expected_senderName` | Correct parsed name | Custom metric (deterministic) |
| `expected_bodyText` | Correct stripped body text | Custom metric (deterministic) |
| `expected_skip` | "TRUE" if email should be skipped (self-send) | Custom metric |
| `expected_contains` | Pipe-separated phrases that MUST appear in output | Custom metric |
| `expected_not_contains` | Pipe-separated phrases that must NOT appear | Custom metric |
| `expected_escalation` | "TRUE" if agent should escalate | Custom metric |

### Output Columns (filled by Set Outputs)

| Column | Purpose |
|---|---|
| `actual_output` | Agent's actual response text |

### Test Case Categories

1. **Pipeline tests** (deterministic, should be 100%): Input parsing, quote stripping, email normalization
2. **AI behavior tests** (probabilistic, target 90%+): Correct conversation flow, right pricing, right links
3. **Guardrail tests** (should be 100%): Escalation cases, no hallucination, no forbidden content

**Important:** Use fake `@example.com` emails in test data, never real customer emails.

## Data Normalize Node

This is the bridge between the Evaluation Trigger (sheet rows) and the production pipeline. It converts sheet column names into the format the pipeline expects.

```javascript
const input = $input.first().json;
const isEval = !!input.raw_from || !!input.test_id;

if (isEval) {
  const row = input;
  let from = row.raw_from || '';
  try { from = JSON.parse(from); } catch(e) { /* string format, keep as-is */ }

  return [{
    json: {
      from,
      subject: row.raw_subject || '(no subject)',
      text: row.raw_body || '',
      id: 'eval-' + (row.test_id || 'unknown'),
      threadId: 'eval-thread-' + (row.test_id || 'unknown'),
      _isEval: true,
      _eval: {
        test_id: row.test_id,
        test_name: row.test_name,
        expected_senderEmail: row.expected_senderEmail,
        expected_senderName: row.expected_senderName,
        expected_bodyText: row.expected_bodyText,
        expected_skip: row.expected_skip,
        expected_tools: row.expected_tools,
        expected_no_tools: row.expected_no_tools,
        expected_contains: row.expected_contains,
        expected_not_contains: row.expected_not_contains,
        expected_escalation: row.expected_escalation,
        conversation_history: row.conversation_history,
        expected_behavior: row.expected_behavior
      }
    }
  }];
} else {
  return $input.all();
}
```

**Important:** Only the Evaluation Trigger connects to Data Normalize. The production trigger (Gmail, WhatsApp, etc.) connects directly to the first pipeline node.

## Critical Gotchas

### Gotcha 1: `$execution.mode` is NOT `'evaluation'`

When the Evaluation Trigger runs, `$execution.mode` returns `'manual'`, NOT `'evaluation'`. You **cannot** use `$execution.mode === 'evaluation'` to detect eval runs.

**Solution:** Detect eval data by checking for fields that only exist in eval inputs:

```javascript
const input = $input.first().json;
const isEval = !!input.raw_from || !!input.test_id;
```

### Gotcha 2: The `_isEval` Flag Gets Lost Through Code Nodes

Every Code node creates a new output object, dropping `_isEval`. The AI Agent node drops ALL upstream fields.

**Solution:** Every Code node must explicitly pass the flag through:

```javascript
// In every code node that creates new output:
const upstream = $input.first().json;
const output = { /* your normal output */ };

if (upstream._isEval) {
  output._isEval = true;
  output._eval = upstream._eval;
}

return [{ json: output }];
```

For nodes **after** the AI Agent (which drops everything), read from an earlier node:

```javascript
const original = $('Strip Quoted Text').item.json;
if (original._isEval) {
  output._isEval = true;
  output._eval = original._eval;
}
```

### Gotcha 3: Sub-Node Expression Context

Sub-nodes (like Postgres Chat Memory under an AI Agent) have different expression contexts. `$('Node Name')` references may not work. Don't try to dynamically change sub-node behavior based on eval flags.

### Gotcha 4: API Cannot Configure Credential-Dependent Nodes

The Evaluation Trigger and Set Outputs nodes require Google Sheets OAuth2 credentials. You **cannot** push these via the n8n API — the credential reference won't bind.

**Solution:** Add these nodes via the n8n UI manually. Configure everything else via API/MCP.

### Gotcha 5: Custom Prompt Must Output a Number

The built-in correctness metric parser expects the LLM to return a single 0-1 score. If your custom prompt asks for JSON or multi-criteria output, the parser will fail with:

```
Failed to evaluate correctness - Unexpected token 'B', 'Based on t'... is not valid JSON
```

**Solution:** Keep the default prompt, or write a custom one that ends with just a number. Use `expected_behavior` descriptions to encode your evaluation criteria instead of a complex prompt.

### Gotcha 6: Activation Fails with Unconfigured Credential Nodes

If any node requires a credential that isn't set, the workflow won't activate. When deploying via API, either disable credential-dependent nodes first or configure them in the UI before activating.

## Running Evals

1. Open the workflow in n8n
2. Click **"Evaluate all"** next to the Evaluation Trigger node
3. n8n runs each test case row-by-row
4. Results appear in the **Evaluations** tab with metric scores
5. Set Outputs writes `actual_output` back to the Google Sheet for manual review

## When to Run Evals

| Trigger | Run evals |
|---|---|
| System prompt change | Yes — all tests |
| Code node change (normalize, strip, format) | Yes — pipeline tests |
| Before deploying to production | Yes — all tests |
| Weekly | Yes — catches model drift |

## Multi-Turn Conversation Tests

For testing conversation flows (e.g., a delivery rider providing info across multiple emails):

1. Add a `conversation_history` column to your sheet with JSON arrays of prior messages
2. Before the AI Agent (eval mode only), seed the chat memory with this history
3. Use a unique session key per test: `eval-{test_id}-{timestamp}`
4. Clean up eval sessions after the run

## Debugging Failed Evals

1. Check the execution in n8n's Executions tab — click into the failed run
2. Inspect each node's output to find where the data diverged
3. Common issues:
   - `_isEval` flag lost → check the code node that's dropping it
   - Wrong node reference → `$('Node Name')` is case-sensitive and must match exactly
   - Empty metrics → Report Metrics node needs manual UI configuration
   - "Column names updated" error → Sheet columns changed after Set Outputs was configured; reconfigure in UI
   - "Failed to evaluate correctness" → Custom prompt returning non-numeric output; simplify or remove prompt override
   - Postgres Chat Memory error → Data Normalize node missing; eval trigger data went directly into pipeline in wrong format
