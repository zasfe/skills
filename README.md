# skills

Agent Skills release repository.

Built and published from the private development repository — **do not edit this
repository directly**. Fixes are made upstream and re-released.

## Available skills

| Skill | Description |
|---|---|
| `example-skill` | Agent Skill 디렉터리가 패키지 규칙에 맞게 구성됐는지 점검할 때 사용 — SKILL.md가 1개인지, references/scripts/assets/templates 배치가 올바른지, 디렉터리명과 frontmatter name이 일치하는지, 개발 자료가 혼입되지 않았는지 검사. 특정 skill 디렉터리의 구조 점검 요청, 새 Skill 작성 전 참고 구현 확인, 배포된 Skill의 support file 설치 확인에 사용. |

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
