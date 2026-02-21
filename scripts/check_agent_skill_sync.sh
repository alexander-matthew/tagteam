#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

extract_frontmatter_name() {
  local file="$1"
  awk '
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { exit }
    in_frontmatter && $1 == "name:" {
      sub(/^name:[[:space:]]*/, "", $0)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
      gsub(/^"/, "", $0)
      gsub(/"$/, "", $0)
      gsub(/^'\''/, "", $0)
      gsub(/'\''$/, "", $0)
      print $0
      exit
    }
  ' "$file"
}

collect_basenames() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    find "$dir" -maxdepth 1 -type f -name "*.md" -printf "%f\n" | sed 's/\.md$//' | sort -u
  fi
}

validate_file_names() {
  local errors=0

  while IFS= read -r plugin_dir; do
    [[ -z "$plugin_dir" ]] && continue

    if [[ -d "$plugin_dir/agents" ]]; then
      while IFS= read -r file; do
        [[ -z "$file" ]] && continue
        local base name
        base="$(basename "$file" .md)"
        name="$(extract_frontmatter_name "$file" || true)"
        if [[ -z "$name" ]]; then
          echo "ERROR: Missing frontmatter name in $file"
          errors=1
        elif [[ "$name" != "$base" ]]; then
          echo "ERROR: Frontmatter name mismatch in $file (name: $name, file: $base)"
          errors=1
        fi
      done < <(find "$plugin_dir/agents" -maxdepth 1 -type f -name "*.md" | sort)
    fi

    if [[ -d "$plugin_dir/skills" ]]; then
      while IFS= read -r file; do
        [[ -z "$file" ]] && continue
        local base name
        base="$(basename "$file" .md)"
        name="$(extract_frontmatter_name "$file" || true)"
        if [[ -z "$name" ]]; then
          echo "ERROR: Missing frontmatter name in $file"
          errors=1
        elif [[ "$name" != "$base" ]]; then
          echo "ERROR: Frontmatter name mismatch in $file (name: $name, file: $base)"
          errors=1
        fi
      done < <(find "$plugin_dir/skills" -maxdepth 1 -type f -name "*.md" | sort)
    fi
  done < <(find plugins -mindepth 1 -maxdepth 1 -type d | sort)

  return "$errors"
}

if [[ ! -d plugins ]]; then
  echo "No plugins directory found; nothing to check."
  exit 0
fi

if ! validate_file_names; then
  echo
  echo "Agent/skill metadata validation failed."
  exit 1
fi

failures=0

while IFS= read -r plugin_dir; do
  [[ -z "$plugin_dir" ]] && continue

  tmp_agents="$(mktemp)"
  tmp_skills="$(mktemp)"

  collect_basenames "$plugin_dir/agents" > "$tmp_agents"
  collect_basenames "$plugin_dir/skills" > "$tmp_skills"

  missing_skills="$(comm -23 "$tmp_agents" "$tmp_skills" || true)"
  missing_agents="$(comm -13 "$tmp_agents" "$tmp_skills" || true)"

  if [[ -n "$missing_skills" || -n "$missing_agents" ]]; then
    plugin_name="$(basename "$plugin_dir")"
    echo "Agent/skill parity failed for plugin: $plugin_name"

    if [[ -n "$missing_skills" ]]; then
      echo "  Missing skills in $plugin_dir/skills (expected <name>.md):"
      while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        echo "    - $name"
      done <<< "$missing_skills"
    fi

    if [[ -n "$missing_agents" ]]; then
      echo "  Missing agents in $plugin_dir/agents (expected <name>.md):"
      while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        echo "    - $name"
      done <<< "$missing_agents"
    fi

    failures=1
  fi

  rm -f "$tmp_agents" "$tmp_skills"
done < <(find plugins -mindepth 1 -maxdepth 1 -type d | sort)

if [[ "$failures" -ne 0 ]]; then
  echo
  echo "Fix parity, then rerun: bash scripts/check_agent_skill_sync.sh"
  exit 1
fi

echo "Agent/skill parity check passed."
