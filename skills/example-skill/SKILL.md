---
name: example-skill
description: Agent Skill 디렉터리가 패키지 규칙에 맞게 구성됐는지 점검할 때 사용 — SKILL.md가 1개인지, references/scripts/assets/templates 배치가 올바른지, 디렉터리명과 frontmatter name이 일치하는지, 개발 자료가 혼입되지 않았는지 검사. 특정 skill 디렉터리의 구조 점검 요청, 새 Skill 작성 전 참고 구현 확인, 배포된 Skill의 support file 설치 확인에 사용.
version: 0.1.1
---

# example-skill

Repository 구성 검증용 참고 구현(reference implementation)임.
동시에 **새 Skill을 작성할 때 복사해도 되는 최소 형태**를 보여줌.

## 사용 시점

사용해야 하는 경우:

- Skill 패키지 구조(`SKILL.md` + `references/` + `scripts/`)가 규칙에 맞는지 점검할 때
- 새 Skill을 만들기 전 참고 형태가 필요할 때
- 배포된 Skill이 support file까지 정상 설치되었는지 확인할 때

사용하지 않아야 하는 경우:

- 실제 도메인 작업(문서 작성, 코드 수정, 분석 등)을 요청받은 경우

## 절차

1. 점검 대상 Skill 디렉터리 경로를 확인한다.
2. `scripts/example.sh <경로>` 를 실행해 구조 점검 결과를 얻는다.
3. 출력의 `RESULT:` 줄을 확인한다. `RESULT: OK` 가 아니면 실패 항목을 그대로 보고한다.
   - 스크립트를 실행할 수 없거나 디렉터리 내용을 확인할 수 없으면 **점검을 수행한 것처럼
     판단하지 말 것**. 이 경우 `RESULT: UNKNOWN` 과 확인하지 못한 이유를 보고한다.
   - 실제로 확인한 항목만 근거로 삼는다. 확인하지 않은 항목을 통과로 단정하지 않는다.
4. 규칙의 근거·예외·설치 확인 방법이 필요하면 `references/example.md` 를 읽는다.
   설치 방법을 묻는 요청이면 해당 문서의 "설치 확인 방법" 절을 근거로 답한다.

```bash
bash scripts/example.sh /path/to/skills/my-skill
```

## 점검 항목

| 항목 | 기준 |
|---|---|
| SKILL.md | 디렉터리 루트에 정확히 1개 |
| frontmatter | `name`, `description` 존재 |
| 이름 일치 | `directory-name == name` |
| 지원 파일 | `references/`, `scripts/`, `assets/`, `templates/` 만 허용 |
| 개발 자료 | `evals/`, `research/`, `notes/` 등이 포함되지 않을 것 |

상세 근거는 `references/example.md` 참고.

## 출력 형식

점검 결과는 다음 형태로 보고한다.

```text
대상: <skill directory>
RESULT: OK | FAIL | UNKNOWN
실패 항목:
- <항목>: <이유>
```

| RESULT | 의미 |
|---|---|
| `OK` | 모든 점검 항목을 실제로 확인했고 위반 없음 |
| `FAIL` | 확인 결과 위반 항목 존재 — 실패 항목에 나열 |
| `UNKNOWN` | 점검을 수행할 수 없었음 — 사유를 함께 보고. 추측으로 `OK`를 쓰지 말 것 |
