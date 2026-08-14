# skills

Agent Skills release repository.

Built and published from the private development repository — **do not edit this
repository directly**. Fixes are made upstream and re-released.

## Available skills

| Skill | Description |
|---|---|
| _(none yet)_ | |

## Install

### skills CLI

```bash
npx skills add zasfe/skills --list
npx skills add zasfe/skills --skill <skill-name>
npx skills add zasfe/skills --skill <skill-name> -a claude-code -a codex
```

### Hermes Agent

```bash
hermes skills install zasfe/skills/skills/<skill-name> --yes
hermes skills list | grep <skill-name>
```

Repository tap:

```bash
hermes skills tap add zasfe/skills
```

## Layout

Every skill is a self-contained directory under `skills/`:

```text
skills/<skill-name>/
├── SKILL.md          # entrypoint (exactly one per skill)
├── references/       # detail loaded on demand
├── scripts/          # deterministic helpers
├── assets/
└── templates/
```
