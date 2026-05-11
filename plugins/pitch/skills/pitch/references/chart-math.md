# Chart math — SVG bar geometry

Each phase chart is an SVG with viewBox `0 0 150 78`. The chart area runs from `y=10` (top, $80k) to `y=60` (bottom, $0). X-axis labels sit at `y=70`.

## Y-axis (shared across all 3 charts)

- $80k → y=10
- $40k → y=35
- $0  → y=60

So 1 pixel of height = $80k / 50 = $1,600. To place a bar of height representing `$N`:

```
height = (N / 80000) * 50
y = 60 - height
```

## Bar widths and spacing

**3-month phases (Build, Compound)** — 3 bars across:
- bar width: 28
- x positions: 22, 70, 118
- center-x for x-axis labels: 36, 84, 132

**6-month phase (Scale)** — 6 bars across:
- bar width: 14
- x positions: 22, 44, 66, 88, 110, 132
- center-x for x-axis labels: 29, 51, 73, 95, 117, 139

## Example: Build phase (M1 = $5.6k, M2 = $11.2k, M3 = $16.8k)

```
M1: height = (5600/80000) * 50 = 3.5,  y = 60 - 3.5 = 56.5
M2: height = (11200/80000) * 50 = 7,    y = 60 - 7 = 53
M3: height = (16800/80000) * 50 = 10.5, y = 60 - 10.5 = 49.5
```

Resulting SVG:
```html
<rect x="22"  y="56.5" width="28" height="3.5"/>
<rect x="70"  y="53"   width="28" height="7"/>
<rect x="118" y="49.5" width="28" height="10.5"/>
```

## Example: Compound phase with upside (M10–M12)

The Compound chart has TWO bar groups: a solid base (the guaranteed minimum continuing) and a faded portion on top (the ICP #2 upside).

For each month, base goes from `y_base = 60 - base_height` upward by `base_height` pixels. The upside sits ON TOP of the base, so its `y_upside = y_base - upside_height` and its height is `upside_height`.

```
M12 base = $67.2k  → base_height = 42,    y_base = 18
M12 upside = $12k  → upside_height = 7.5, y_upside = 18 - 7.5 = 10.5
```

SVG:
```html
<!-- base (solid clay 0.65 opacity) -->
<rect x="118" y="18"   width="28" height="42"/>
<!-- upside (faded clay 0.30 opacity) -->
<rect x="118" y="10.5" width="28" height="7.5"/>
```

## Y-axis labels (always include all three on every chart)

```html
<text x="20" y="13" text-anchor="end" class="pc-yaxis">$80k</text>
<text x="20" y="38" text-anchor="end" class="pc-yaxis">$40k</text>
<text x="20" y="62" text-anchor="end" class="pc-yaxis">$0</text>
```

## X-axis labels (always include under every chart)

```html
<!-- 3-bar layout -->
<text x="36"  y="70" text-anchor="middle" class="pc-xaxis">M1</text>
<text x="84"  y="70" text-anchor="middle" class="pc-xaxis">M2</text>
<text x="132" y="70" text-anchor="middle" class="pc-xaxis">M3</text>
```

## Sanity check before rendering

- All `y` values for bars should be between 10 and 60.
- `y + height` should equal 60 for solid base bars (they sit on the axis).
- For upside bars, `y_upside + upside_height` should equal `y_base` (no gap).
- Bars shouldn't exceed width=28 (3-bar) or width=14 (6-bar).
