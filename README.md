# 4‑Digit Passwords & Their Frequencies (Processing)

Interactive Processing sketch that visualizes the frequency of 4‑digit passwords/PINs using the dataset in `data/4digitRockYouFrequencies_2kPlus.csv`. Points are grouped by simple patterns (e.g., All Same, Palindrome, AABB, Year‑like, Sequences) and you can navigate between groups and inspect values.

## Features
- Hover to see tooltip with `PW` and `Freq`.
- Highlight of top 5 most frequent values per group.
- Keyboard navigation: `←` `→` or `n`/`p` to change groups.
- “Other” group split into `0000–5000` and `5001–9999` sub‑ranges for readability.

## Repository Structure
- `rock_20251117c.pde`: Main Processing sketch.
- `data/4digitRockYouFrequencies_2kPlus.csv`: Input data (header included).
- `.gitignore`: Ignore macOS files.

## Data Format
CSV with headers:

```csv
digits,frequency
0741,2003
1355,2003
...
```

- `digits`: 4‑character string (left‑padded with zeros if needed).
- `frequency`: integer count (this file contains entries with frequency ≥ 2000).

## Requirements
- Processing 4 (or Processing 3) for macOS/Windows/Linux
	- Uses core `Table` API; no external libraries required.

## How to Run (GUI)
1. Open Processing.
2. File → Open → select `rock_20251117c.pde`.
3. Ensure the CSV exists at `data/4digitRockYouFrequencies_2kPlus.csv`.
4. Click Run.

## How to Run (CLI)
Install the `processing-java` tool from Processing (Tools → Install "processing-java"). Then run:

```zsh
processing-java \
	--sketch="/Users/erika/Documents/2025 ISSE third year fall semester/Data Visualization/rock_20251117c" \
	--run
```

If you have multiple Processing versions, you can also launch the app binary directly (GUI):

```zsh
open -a Processing "/Users/erika/Documents/2025 ISSE third year fall semester/Data Visualization/rock_20251117c/rock_20251117c.pde"
```

## Controls
- `←` / `p`: Previous group
- `→` / `n`: Next group
- Mouse hover: Show tooltip for the nearest point

## Notes
- The sketch normalizes inputs to 4 digits (e.g., `741` → `0741`).
- Pattern groups include: All Same, Ascending/Descending Sequences, Palindrome, AABB, ABAB, Year‑like, and Other.
- Fonts: uses `Arial` via `createFont("Arial", 12)`; your system should have Arial or a compatible substitute.

## Troubleshooting
- "Cannot find or load data": verify the file exists at `data/4digitRockYouFrequencies_2kPlus.csv` and the header is exactly `digits,frequency`.
- Nothing appears or labels overlap: try resizing the sketch window or reducing display scale.
- CLI errors: ensure `processing-java` is installed and that the `--sketch` path is quoted (paths contain spaces).

## Screenshot (optional)
Add a screenshot of a representative view here once the sketch is running.
