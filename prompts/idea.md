# IntelliJ settings for ktlint / Prettier

Findings from manually configuring IntelliJ against this repo's linters, captured for building a bootstrap step that
applies these settings automatically. `.idea/` is not versioned (see README), so nothing here is committed as-is, a
bootstrap mechanism needs to write/merge these settings into the developer's local `.idea/` on setup.

## Prerequisites confirmed by testing

- Prettier does **not** require a project-local `node_modules`. A globally installed package (`npm install -g prettier`)
  is picked up correctly by "Automatic Prettier configuration" mode, including reading the repo's local `.prettierrc`.
  This corrects an earlier assumption in this project's history that only project-local `node_modules` would be
  detected, that assumption was wrong.
- This presumably requires IntelliJ to have a working Node.js interpreter detected (usually automatic if `node`/`npm`
  are on `PATH`). Not stress-tested against a machine with no Node interpreter configured at all.
- `.prettierrc` in the repo root is picked up automatically, no extra Prettier settings needed for that.

## The three files

All three live under `.idea/` and don't exist at all on a totally clean project, IntelliJ only creates them once a
setting deviates from its default. That means **presence of the file is itself already a non-default signal**; a
bootstrap step can't assume "file doesn't exist yet" == "nothing to do" only for _new_ projects, it also needs to handle
repos where a teammate already has one of these files with their own additions.

For ktlint and Prettier there isn't much else in these files besides what's listed below, so an overwrite (rather than a
merge) is fine for those two. Inspections are more complicated, see the note under that file.

### `.idea/ktlint-plugin.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="com.nbadal.ktlint.KtlintProjectSettings">
    <ktlintMode>DISTRACT_FREE</ktlintMode>
    <ktlintRulesetVersion>DEFAULT</ktlintRulesetVersion>
  </component>
</project>
```

Corresponds to: Settings → Tools → KtLint → "Distract free" mode.

**Default that must be reset if overridden:** ktlint's "on save" (`formatOnSave`) defaults to `true`, which is why it's
absent above. Confirmed by toggling it off and seeing `<formatOnSave>false</formatOnSave>` appear, then back on and
seeing it disappear again. If an existing file has this key explicitly set to `false` (a teammate previously unchecked
it), the bootstrap should remove the key or force it to `true`, an overwrite with the file above handles this
automatically.

### `.idea/prettier.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="PrettierConfiguration">
    <option name="myConfigurationMode" value="AUTOMATIC" />
    <option name="myRunOnSave" value="true" />
    <option name="myFilesPattern" value="**/*.{js,ts,jsx,tsx,cjs,cts,mjs,mts,json,vue,astro,md,mdx}" />
  </component>
</project>
```

Corresponds to: Settings → Languages & Frameworks → JavaScript → Prettier → "Automatic Prettier configuration", `.md`
and `.mdx` added to "Run for files:", "Run on save" checked.

The default `myFilesPattern` (before adding `md,mdx`) is `**/*.{js,ts,jsx,tsx,cjs,cts,mjs,mts,json,vue,astro}`, IntelliJ
does not run Prettier against Markdown out of the box.

**Defaults that must be reset if overridden:** "Run on paste" (`runOnPaste`) and "Prefer Prettier configuration to IDE
code style" (`codeStyleSettingsModifierEnabled`) both default to `true`, which is why they're absent above. Same
confirmation method as `formatOnSave` above (toggle off, key appears as `false`; toggle back on, key disappears). An
overwrite with the file above resets both automatically.

### `.idea/inspectionProfiles/Project_Default.xml`

```xml
<component name="InspectionProjectProfileManager">
  <profile version="1.0">
    <option name="myName" value="Project Default" />
    <inspection_tool class="MarkdownIncorrectTableFormatting" enabled="false" level="WEAK WARNING" enabled_by_default="false" />
  </profile>
</component>
```

Corresponds to: Settings → Editor → Inspections → disabling the Markdown table formatting inspection (it fires false
positives against Prettier's table formatting, since it doesn't consider `.prettierrc`).

**This file is the one most likely to already exist with unrelated content** (a previous version of this repo's own
`.idea/` had an unrelated `ShellCheck` inspection entry in here). Overwriting was observed to silently delete that
existing, unrelated entry during manual testing, so a blind overwrite isn't safe here the way it is for the two files
above. Leaving this one for later, worth thinking through properly once we design the actual bootstrap mechanism.

## Bootstrap implementation notes

- `ktlint-plugin.xml` and `prettier.xml` can be a straight overwrite, there's little else in them and it naturally
  resets any overridden defaults.
- `inspectionProfiles/Project_Default.xml` needs real merge logic (or some other approach), deferred until the bootstrap
  mechanism is designed.
- After writing, IntelliJ needs a restart or project reload to pick up changes made outside the IDE (confirmed during
  manual testing, we cleared `.idea` and had to reopen for the reapplied settings to take effect).
