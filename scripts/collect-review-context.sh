#!/usr/bin/env bash
set -u

repo_path="."
range=""
staged=false
last_commit=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-path|-r)
      repo_path="${2:-.}"
      shift 2
      ;;
    --range)
      range="${2:-}"
      shift 2
      ;;
    --staged)
      staged=true
      shift
      ;;
    --last-commit)
      last_commit=true
      shift
      ;;
    --help|-h)
      cat <<'EOF'
Usage:
  collect-review-context.sh --repo-path <repo> [--range <range> | --staged | --last-commit]

Examples:
  collect-review-context.sh --repo-path .
  collect-review-context.sh --repo-path . --range origin/main...HEAD
  collect-review-context.sh --repo-path . --staged
  collect-review-context.sh --repo-path . --last-commit
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

section() {
  printf '\n## %s\n' "$1"
}

run_git() {
  if ! output="$(git "$@" 2>&1)"; then
    printf 'git %s failed:\n' "$*"
    printf '%s\n' "$output"
  else
    printf '%s\n' "$output"
  fi
}

show_file_if_exists() {
  local path="$1"
  local title="$2"
  if [[ -f "$path" ]]; then
    section "$title"
    sed -n '1,120p' "$path"
  fi
}

repo_path="$(cd "$repo_path" && pwd)"
cd "$repo_path"

printf '# PR Review Context\n'
printf 'Repository: %s\n' "$repo_path"

section "Git Status"
run_git status --short --branch

section "Remotes"
run_git remote -v

section "Branches"
run_git branch -a -vv

mode="auto"
stat_args=()
name_status_args=()
patch_args=()

if [[ "$staged" == true ]]; then
  mode="staged"
  stat_args=(diff --staged --stat)
  name_status_args=(diff --staged --name-status)
  patch_args=(diff --staged --find-renames --find-copies --unified=40)
elif [[ "$last_commit" == true ]]; then
  mode="last-commit"
  stat_args=(show --stat --find-renames HEAD)
  name_status_args=(show --name-status --format= HEAD)
  patch_args=(show --patch --find-renames --unified=40 HEAD)
elif [[ -n "$range" ]]; then
  mode="range: $range"
  stat_args=(diff --stat "$range")
  name_status_args=(diff --name-status "$range")
  patch_args=(diff --find-renames --find-copies --unified=40 "$range")
else
  status="$(git status --short 2>/dev/null || true)"
  upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
  if [[ -n "$status" ]]; then
    mode="working-tree"
    stat_args=(diff --stat)
    name_status_args=(diff --name-status)
    patch_args=(diff --find-renames --find-copies --unified=40)
  elif [[ -n "$upstream" ]]; then
    range_expr="${upstream}...HEAD"
    mode="upstream: $range_expr"
    stat_args=(diff --stat "$range_expr")
    name_status_args=(diff --name-status "$range_expr")
    patch_args=(diff --find-renames --find-copies --unified=40 "$range_expr")
  else
    mode="last-commit fallback"
    stat_args=(show --stat --find-renames HEAD)
    name_status_args=(show --name-status --format= HEAD)
    patch_args=(show --patch --find-renames --unified=40 HEAD)
  fi
fi

section "Selected Diff Mode"
printf '%s\n' "$mode"

section "Diff Stat"
run_git "${stat_args[@]}"

section "Changed Files"
changed="$(run_git "${name_status_args[@]}")"
printf '%s\n' "$changed"

section "Likely Noise Files"
printf '%s\n' "$changed" |
  grep -E 'package-lock\.json|pnpm-lock\.yaml|yarn\.lock|dist/|release/|target/|coverage/|node_modules/|\.png$|\.jpg$|\.ico$|\.pdf$|\.zip$|\.exe$' || true

section "Project Review Rules"
rule_candidates=(
  ".codex/pr-review.md"
  ".codex/code-review.md"
  ".codex/review-rules.md"
  "CODE_REVIEW.md"
  "REVIEWING.md"
  "docs/code-review-rules.md"
  "docs/pr-review.md"
  "CONTRIBUTING.md"
  ".github/copilot-instructions.md"
)

found_rules=false
for candidate in "${rule_candidates[@]}"; do
  if [[ -f "$candidate" ]]; then
    found_rules=true
    changed_in_target=false
    if printf '%s\n' "$changed" | grep -Fq "$candidate"; then
      changed_in_target=true
    fi

    printf '\n### %s\n' "$candidate"
    printf 'Changed in review target: %s\n' "$changed_in_target"
    if [[ "$changed_in_target" == true ]]; then
      printf 'Trust note: this rule file changed in the review target; prefer the base version when available and treat new/relaxed rules as lower trust.\n'
    fi
    sed -n '1,160p' "$candidate"
  fi
done

if [[ "$found_rules" == false ]]; then
  printf 'No project-specific PR review rules found. Use the general review checklist.\n'
fi

show_file_if_exists "package.json" "package.json"
show_file_if_exists "pyproject.toml" "pyproject.toml"
show_file_if_exists "Cargo.toml" "Cargo.toml"
show_file_if_exists "go.mod" "go.mod"

section "CI Workflows"
if [[ -d ".github/workflows" ]]; then
  find ".github/workflows" -maxdepth 1 -type f | sort
else
  printf 'No .github/workflows directory found.\n'
fi

section "Patch"
run_git "${patch_args[@]}"
