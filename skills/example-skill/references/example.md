# Skill 패키지 구조 규칙 — 상세

`SKILL.md`는 최소 절차만 담고, 근거와 예외는 이 문서에서 확인할 것 (progressive disclosure).

---

## 1. 왜 `SKILL.md`가 정확히 1개여야 하는가

Agent Skill의 기본 단위는 **하나의 디렉터리**이며, 해당 디렉터리의 진입점은 `SKILL.md` 하나임.
하위 디렉터리에 또 다른 `SKILL.md`가 있으면 Skill 탐색 도구가 이를 별개의 Skill로 인식하거나
설치 경로 검증에 실패할 수 있음.

금지:

```text
my-skill/
├── SKILL.md
└── references/
    └── aws/
        └── SKILL.md     # 금지
```

---

## 2. 왜 `directory-name == frontmatter name` 인가

설치 도구가 Skill을 찾는 경로와, Skill이 스스로 선언한 이름이 달라지면
설치 후 조회·갱신·삭제 과정에서 대상이 어긋남.

```text
skills/network-architecture/SKILL.md
  → frontmatter name: network-architecture   (일치)
```

이름은 `lowercase-kebab-case`를 사용:

```text
network-architecture
decision-analysis
meeting-note-visualizer
```

---

## 3. 허용되는 support 디렉터리

| 디렉터리 | 용도 |
|---|---|
| `references/` | 필요할 때만 읽는 상세 자료 |
| `scripts/` | 결정적으로 수행 가능한 작업 |
| `assets/` | 이미지·데이터 등 정적 자원 |
| `templates/` | 산출물 템플릿 |

이 외의 최상위 항목은 배포 대상에서 제외됨(allowlist). 런타임에 반드시 필요한 파일이라면
`development/<skill>/build.json`의 `extra`에 명시할 것.

---

## 4. 포함되면 안 되는 것

```text
research/  drafts/  evals/  fixtures/
regression/  benchmarks/  failed-cases/  notes/
```

위 디렉터리는 개발 자료이며 `development/<skill>/` 하위에만 존재해야 함.
배포 Artifact에 포함되면 Agent의 Context를 불필요하게 오염시키고,
비공개 자료가 공개 Repository로 유출될 수 있음.

시크릿(`.env`, 개인키, API 토큰)은 어떤 경우에도 포함 금지.

---

## 5. self-contained 요구사항

배포된 Skill은 **단독 설치 가능**해야 함.

- 상대 경로로 Skill 디렉터리 밖(`../`)을 참조하지 말 것
- 개발 Repository의 `shared/`를 런타임에 참조하지 말 것
- 공통 자료가 필요하면 Skill 내부에 포함시킬 것

---

## 6. 설치 확인 방법

구조 점검이 끝난 Skill이 실제로 설치되는지 확인할 때 사용하는 표준 경로.

### Hermes Agent

`references/`, `scripts/` 등 support file이 있는 **다중 파일 Skill은 반드시 GitHub
directory source**로 설치할 것.

```bash
hermes skills install <owner>/<repo>/skills/<skill-name> --yes
hermes skills list | grep <skill-name>
```

피할 것:

```bash
# raw SKILL.md URL — support 디렉터리가 함께 내려오지 않음
hermes skills install https://raw.githubusercontent.com/<owner>/<repo>/main/skills/<name>/SKILL.md

# Repository 전체 설치 — 버전에 따라 호환성 문제가 보고됨
hermes skills install <owner>/<repo>
```

Repository를 Tap으로 등록하는 방식도 가능하며, 이때 Skill Registry 경로는 `skills/`임.

```bash
hermes skills tap add <owner>/<repo>
```

### skills CLI

```bash
npx skills add <owner>/<repo> --list
npx skills add <owner>/<repo> --skill <skill-name>
npx skills add <owner>/<repo> --skill <skill-name> -a claude-code -a codex
```

### 설치 후 확인

설치된 디렉터리에 `SKILL.md`뿐 아니라 `references/`, `scripts/`의 파일이 함께
존재하는지 확인할 것. `SKILL.md`만 있으면 다중 파일 Skill 설치가 실패한 것임.

---

## 7. 예외 처리

| 상황 | 처리 |
|---|---|
| support 디렉터리가 비어 있음 | 디렉터리 자체를 만들지 말 것 |
| 플랫폼별 동작 차이 | Skill을 복제하지 말고 `SKILL.md` 내부에서 분기 |
| 자료가 매우 큼 | `references/`로 분리하고 `SKILL.md`에서는 파일명만 안내 |
| 스크립트가 외부 의존성 필요 | 의존성 확인 실패 시 명확한 오류 메시지로 종료 |
