# TagTeam

```
  ╔════════════════════════════════════════════╗
  ║                                            ║
  ║   ████████  █████   ██████  ████████       ║
  ║      ██    ██   ██ ██          ██          ║
  ║      ██    ███████ ██   ███    ██          ║
  ║      ██    ██   ██ ██    ██    ██          ║
  ║      ██    ██   ██  ██████     ██          ║
  ║                                            ║
  ║   ████████ ████████  █████  ███    ███     ║
  ║      ██    ██       ██   ██ ████  ████     ║
  ║      ██    ██████   ███████ ██ ████ ██     ║
  ║      ██    ██       ██   ██ ██  ██  ██     ║
  ║      ██    ████████ ██   ██ ██      ██     ║
  ║                                            ║
  ║    your skills + my skills ... tag team     ║
  ╚════════════════════════════════════════════╝
```

> *"Your skills... plus my skills... in the ring... tag team."* — Nacho Libre

A curated marketplace of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugins. Browse, install, and share skills and agents that make Claude Code better at real work.

## Available Plugins

| Plugin | Description | Keywords |
|--------|-------------|----------|
| [doc-maintainer](plugins/doc-maintainer) | Paired agents that keep project documentation lean and accurate | `documentation` `claude-md` `maintenance` `review` |

## Installation

### Install the full marketplace

```bash
/plugin marketplace add alexander-matthew/tagteam
```

This gives you access to all plugins in the catalog. Browse and enable the ones relevant to your project.

### Install a single plugin

```bash
/plugin add alexander-matthew/tagteam/plugins/doc-maintainer
```

## Using doc-maintainer

The doc-maintainer plugin provides two agents designed to work as a tag team:

1. **document-maintainer** — Reviews and updates CLAUDE.md after feature work. Deletes stale content, updates outdated facts, adds only non-obvious info.
2. **documentation-janitor** — Reviews the maintainer's changes for quality. Flags bloat, slop, and unnecessary additions. Read-only auditor.

**Typical workflow:**
1. Finish a feature or refactor
2. Run the document-maintainer agent to update docs
3. Run the documentation-janitor agent to verify the changes are clean

## Contributing

Want to add a plugin to the marketplace? PRs welcome.

1. Create your plugin under `plugins/<plugin-name>/`
2. Include a `.claude-plugin/plugin.json` with name, version, description, and keywords
3. Add your agents, skills, hooks, or commands
4. Add an entry to `.claude-plugin/marketplace.json`
5. Open a PR

## License

MIT

## Agent/Skill Sync Guardrails

TagTeam enforces parity between plugin agents and skills by filename:

- `plugins/<plugin>/agents/<name>.md`
- `plugins/<plugin>/skills/<name>.md`

Run manually:

```bash
bash scripts/check_agent_skill_sync.sh
```

Install local pre-commit hook (one-time per clone):

```bash
bash scripts/install_git_hooks.sh
```

CI also enforces parity on push and pull requests via `.github/workflows/agent-skill-sync.yml`.
