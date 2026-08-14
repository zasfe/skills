#!/usr/bin/env bash
# example-skill — Skill 패키지 구조 점검.
#
#   bash scripts/example.sh <skill-directory>
#
# 종료 코드: 0 = OK, 1 = 규칙 위반, 2 = 사용법 오류
# 외부 의존성 없음(coreutils + bash). Skill 디렉터리 밖을 참조하지 않음.
set -uo pipefail

TARGET="${1:-}"
if [[ -z "${TARGET}" ]]; then
  echo "usage: bash example.sh <skill-directory>" >&2
  exit 2
fi
if [[ ! -d "${TARGET}" ]]; then
  echo "not a directory: ${TARGET}" >&2
  exit 2
fi

TARGET="${TARGET%/}"
NAME="$(basename "${TARGET}")"
FAILURES=()

add_failure() { FAILURES+=("$1"); }

# 1. SKILL.md 정확히 1개, 루트에 위치
mapfile -t FOUND < <(find "${TARGET}" -type f -name SKILL.md | sort)
if [[ ${#FOUND[@]} -eq 0 ]]; then
  add_failure "SKILL.md: 존재하지 않음"
elif [[ ${#FOUND[@]} -gt 1 ]]; then
  add_failure "SKILL.md: ${#FOUND[@]}개 발견 — Skill당 정확히 1개여야 함"
elif [[ "${FOUND[0]}" != "${TARGET}/SKILL.md" ]]; then
  add_failure "SKILL.md: 루트가 아닌 ${FOUND[0]} 에 위치"
fi

SKILL_MD="${TARGET}/SKILL.md"
if [[ -f "${SKILL_MD}" ]]; then
  # 2. frontmatter name / description
  FRONT="$(awk 'NR==1 && $0!="---"{exit} NR>1{if($0=="---") exit; print}' "${SKILL_MD}")"
  DECLARED_NAME="$(printf '%s\n' "${FRONT}" | sed -n 's/^name:[[:space:]]*//p' | head -1 | tr -d '"'"'"' \r')"
  DESCRIPTION="$(printf '%s\n' "${FRONT}" | sed -n 's/^description:[[:space:]]*//p' | head -1)"

  [[ -n "${DECLARED_NAME}" ]] || add_failure "frontmatter: name 없음"
  [[ -n "${DESCRIPTION}" ]] || add_failure "frontmatter: description 없음"

  # 3. directory-name == name
  if [[ -n "${DECLARED_NAME}" && "${DECLARED_NAME}" != "${NAME}" ]]; then
    add_failure "이름 불일치: directory=${NAME}, name=${DECLARED_NAME}"
  fi

  # 4. 이름 형식
  if [[ ! "${NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    add_failure "이름 형식: ${NAME} 은 lowercase-kebab-case가 아님"
  fi
fi

# 5. 허용되지 않은 최상위 항목
for entry in "${TARGET}"/*; do
  [[ -e "${entry}" ]] || continue
  base="$(basename "${entry}")"
  case "${base}" in
    SKILL.md|references|scripts|assets|templates) ;;
    *) add_failure "허용되지 않은 최상위 항목: ${base}" ;;
  esac
done

# 6. 개발 자료 혼입
for dev in research drafts evals fixtures regression benchmarks failed-cases notes; do
  if find "${TARGET}" -type d -name "${dev}" | grep -q .; then
    add_failure "개발 디렉터리 혼입: ${dev}/"
  fi
done

echo "대상: ${TARGET}"
if [[ ${#FAILURES[@]} -eq 0 ]]; then
  echo "RESULT: OK"
  exit 0
fi

echo "RESULT: FAIL"
echo "실패 항목:"
for f in "${FAILURES[@]}"; do
  echo "- ${f}"
done
exit 1
