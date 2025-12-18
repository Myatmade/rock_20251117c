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

## Controls
- `←` / `p`: Previous group
- `→` / `n`: Next group
- Mouse hover: Show tooltip for the nearest point

## Notes
- The sketch normalizes inputs to 4 digits (e.g., `741` → `0741`).
- Pattern groups include: All Same, Ascending/Descending Sequences, Palindrome, AABB, ABAB, Year‑like, and Other.


