# TagTeam — Claude Code Plugin Marketplace

## Structure

```
plugins/<name>/                   # Each plugin gets its own directory
plugins/<name>/.claude-plugin/    # Plugin manifest lives here
plugins/<name>/plugin.json        # name, version, description, keywords
plugins/<name>/agents/            # Agent .md files with YAML frontmatter
plugins/<name>/skills/            # Skill .md files (if applicable)
plugins/<name>/hooks/             # Hook definitions (if applicable)
plugins/<name>/commands/          # Slash commands (if applicable)
```

`.claude-plugin/marketplace.json` at the repo root catalogs all plugins with relative `source` paths.

## Adding a New Plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` with required fields: `name`, `version`, `description`, `keywords`
2. Add agents/skills/hooks/commands under the plugin directory
3. Add an entry to `.claude-plugin/marketplace.json` with `name`, `description`, `source`, and `keywords`
4. Agent files must have valid YAML frontmatter (`name`, `description`, `tools`, `model`, `maxTurns`)

## Conventions

- Plugin names: lowercase, hyphenated (e.g., `doc-maintainer`)
- Agent names: lowercase, hyphenated, matching the filename without `.md`
- Descriptions: concise, start with what it does (not "This plugin...")
- Keywords: lowercase, relevant to discovery
