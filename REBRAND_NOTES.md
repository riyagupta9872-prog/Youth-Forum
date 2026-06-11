# REBRAND_NOTES.md — Youth Forum rebrand-pass checklist

**Context**: Youth-Forum is the "boys' version" of Sakhi-Sang, sharing the same codebase. The
workflow is: periodically copy-paste the ENTIRE Sakhi-Sang repo over this Youth-Forum folder,
then redo this rebrand pass to restore Youth-Forum-specific branding/config. Everything else
in the diff (functional changes, refactors, new features) is "planned" — leave it as-is.

## ⚠️ #1 PRIORITY — Firebase config (`js/config.js`)

**HIGH STAKES.** If missed, Youth-Forum silently reads/writes Sakhi-Sang's Firestore — real
user data ends up in the wrong database with NO error shown. Always check this FIRST.

```js
const firebaseConfig = {
  apiKey: "AIzaSyABnJ9ygYHA1PA04ncacruipAZjYyLNKZM",
  authDomain: "youth-forum-a6599.firebaseapp.com",
  projectId: "youth-forum-a6599",
  storageBucket: "youth-forum-a6599.firebasestorage.app",
  messagingSenderId: "367160904585",
  appId: "1:367160904585:web:bd136f734143f4fb052f58"
};
```

Verify via: `grep -A1 -E "apiKey|projectId|authDomain" js/config.js` — must say `youth-forum-a6599`,
NEVER `sakhi-sang-attendence-tracker`.

## Team names (Youth-Forum vs Sakhi-Sang)

**`Anant`** — NOT "Annat" (a typo that crept into a past pass — always double check spelling).

| Sakhi-Sang team | Youth-Forum team |
|---|---|
| Champaklata | Keshav |
| Chitralekha | Anant |
| Indulekha | Govind |
| Lalita | Madhav |
| Nilachal | Panchaali |
| Rangadevi | Janardhana |
| Sudevi / Tungavidya / Vishakha | (dropped — Youth-Forum has only 7 teams incl. Other) |
| Other | Other |

`TEAMS` array (single source of truth, `js/config.js`):
```js
const TEAMS = ['Keshav','Anant','Govind','Madhav','Panchaali','Janardhana','Other'];
```

## Field/label rename: "Gopi Dress" → "Dhoti Kurta"

Internal field naming is UNCHANGED — only the DISPLAY LABEL changes:
- Keep `gopiDress` / `gopi_dress` / DOM id `f-gopi` / CSS class `attire-label` exactly as-is.
- Change every user-facing string `"Gopi Dress"` → `"Dhoti Kurta"`.
- IMPORT_FIELDS aliases in `js/excel.js` and `js/db.js`: ADD `'Dhoti Kurta'` / `'dhoti kurta'`
  to the alias list (keep the old `'Gopi Dress'` aliases too, for backward-compat with old
  export files).

## Person-name rename: "Naveena Mataji" / "Naveena (Senior)" → "Jatin Prabhuji"

Level-3 coordinator label, appears in:
- `index.html` — `<option value="Naveena Mataji">` and `Level 3 — Naveena (Senior)`
- `js/ui-attendance.js` — `_CP_LEVELS[3].label`
- `js/ui-analytics.js` — `INTERACTION_LEVELS[3].name`

When fixing alignment-padded object literals (e.g. `_CP_LEVELS`, `INTERACTION_LEVELS`,
`_MONTHLY_TEAM_PALETTES`), preserve the column alignment of the `key:` that follows —
adjust the number of trailing spaces by the difference in label length, don't just
copy-paste with the old spacing.

## Sample/demo data in `js/excel.js`

Facilitator/reference/calling-by names in sample rows: `Anjali Mishra Mtg` → `Anjali Prabhuji`,
`Priya Devi` → `Priya Prabhuji`, `Neha Bhandari` → `Neha Prabhuji`. Sample team names follow the
table above (`Champaklata`→`Keshav`, `Lalita`→`Anant`).

`_MONTHLY_TEAM_PALETTES` — full Youth-Forum version (note Sakhi-Sang's alignment is NOT
column-aligned to 15 chars — match it exactly to avoid noisy diffs):
```js
const _MONTHLY_TEAM_PALETTES = {
  'Keshav':    ['C8E6C9','A5D6A7','81C784','66BB6A','4CAF50','388E3C'],
  'Anant':     ['BBDEFB','90CAF9','64B5F6','42A5F5','1E88E5','1565C0'],
  'Govind':    ['E1BEE7','CE93D8','BA68C8','AB47BC','8E24AA','6A1B9A'],
  'Madhav':    ['FFE0B2','FFCC80','FFB74D','FFA726','FB8C00','E65100'],
  'Panchaali':  ['B2EBF2','80DEEA','4DD0E1','26C6DA','00ACC1','00838F'],
  'Janardhana': ['FFF9C4','FFF59D','FFF176','FFEE58','FDD835','F9A825'],
  'Other':      ['F5F5F5','EEEEEE','E0E0E0','BDBDBD','9E9E9E','757575'],
};
```

## Plain-text branding strings

Replace `Sakhi Sang` → `Youth Forum`, `sakhi_sang_*` filenames → `youth_forum_*`,
`sakhi-sang-vXX` → `youth-forum-vXX`, `SAKHI SANG –` → `YOUTH FORUM –` (watch for en-dash
`–` vs hyphen `-` mismatches when grepping/replacing — re-grep after replace_all to confirm
zero residuals). Files that typically need this:
- `index.html` — `<title>`, `apple-mobile-web-app-title` meta, auth screen logo `alt`+`<h2>`,
  header logo `alt`+`<h1>`
- `manifest.json` — `name`, `short_name`, `description`
- `sw.js` — `CACHE` version string (bump from current Youth-Forum version, e.g. v15→v16) AND
  the comment header (often mojibake/double-encoded UTF-8 — fix via Python byte-level
  `data.replace(b'Sakhi Sang', b'Youth Forum')`)
- `js/ui-ai-chat.js` — AI system prompt app name
- `icons/gen-icons.html`, `icons/icon.svg` — title/heading/SVG text
- `css/style.css` — header comment
- `js/ui-core.js` — signup-request email subject/body text
- `js/excel.js` — export filenames, "SAKHI SANG – Devotee Import Template" headers (×2)

## TEAMS `<option>` dropdowns in `index.html`

Multiple repeated 3-line blocks (10-space and 14-space indentation variants — collapse to
ONE line per occurrence using `replace_all` on each indentation pattern separately):
```html
<option>Keshav</option><option>Anant</option><option>Govind</option><option>Madhav</option><option>Panchaali</option><option>Janardhana</option><option>Other</option>
```

## One-time migration cleanup (`js/ui-core.js`)

Sakhi-Sang has a `Visakha` → `Vishakha` one-time migration (`DB.migrateTeamNameOnce`) that
fires for every super admin login. Youth-Forum has NO `Vishakha`/`Visakha` team — REMOVE
this migration call block entirely (it's harmless if left, since `migrateTeamNameOnce` would
just no-op, but it's dead code specific to Sakhi-Sang's history).

## Documentation files (CLAUDE.md, firestore.rules) — NEW recurring scope items

These two files now regularly come over with the paste and need a pass too:

- **`CLAUDE.md`** (Youth-Forum's own, not the shared parent one) — fix:
  - Header blurb: `**Sakhi-Sang** variant ... (Congregation-Forum, Youth-Forum)` →
    `**Youth Forum** variant ... (Congregation-Forum, Sakhi-Sang)`
  - `sakhi-sang-vXX` → `youth-forum-vXX` (×2: "Top 4 Footguns" + "Caching" sections)
  - TEAMS reference: replace the `Visakha`→`Vishakha` migration note with the actual
    Youth-Forum TEAMS list (`Keshav, Anant, Govind, Madhav, Panchaali, Janardhana, Other`)
  - The rest of the diff (role descriptions, collections list, removed sections) is
    "planned" — leave as-is.

- **`firestore.rules`** — usually a large diff (200+ lines) but almost all of it is
  substantive security-rules changes (planned). Only fix the comment header:
  `// SAKHI SANG — FIRESTORE SECURITY RULES` → `// YOUTH FORUM — FIRESTORE SECURITY RULES`.
  Grep the rest for `sakhi|vishakha|visakha|annat|champaklata|naveena` to be sure nothing
  else slipped in.

## Out-of-scope files (leave untouched even if `git status` shows them)

`REACT_MIGRATION_PRD.md`, `ROLES_AND_DATAFLOW.html`, `USER_GUIDE.md`,
`.claude/settings.local.json` — these are pre-existing leftover Sakhi-Sang references that
predate the current paste workflow and are not part of the rebrand checklist.

## Process / gotchas

1. **Edit one file at a time, sequentially** — do NOT batch multiple parallel `Edit`/
   `replace_all` calls targeting the SAME file. Parallel edits operate on stale snapshots and
   can silently revert each other.
2. **Always Read a file (or the relevant line range) before editing it** in a fresh tool-call
   sequence — Edit errors with "File has not been read yet" otherwise.
3. **Re-grep after every `replace_all`** to confirm zero residuals — visually identical
   strings can use different Unicode dash characters (`–` vs `-`) and only one variant
   matches.
4. **Match HEAD's exact spacing/alignment** when fixing object-literal tables (`excel.js`
   palettes, `_CP_LEVELS`, `INTERACTION_LEVELS`) — verify with
   `git diff HEAD -- <file>` afterward; the diff should show ONLY the intended
   word/spelling changes, nothing reformatted.
5. **Final verification** — run a project-wide grep for residual strings:
   ```
   grep -rniE "sakhi.sang|champaklata|chitralekha|indulekha|\blalita\b|nilachal|rangadevi|\bsudevi\b|tungavidya|vishakha|visakha|naveena|gopi.dress|annat\b" --include="*.js" --include="*.html" --include="*.json" --include="*.css" --include="*.md" --include="*.rules" .
   ```
   then `git status --porcelain` + `git diff HEAD --stat` to confirm the full file list was
   addressed, and re-check the Firebase config one more time.
