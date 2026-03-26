# Keyrock Brand System — Chart Generation Reference

> Single source of truth for all Keyrock brand rules applied to chart and data-visualisation generation.
> Keyrock is an institutional digital asset market maker.

---

## 1. Colour Palette

### 1.1 Primary Series — Blue Tones (up to 8 series)

Use these first for all standard data series. Ordered from most vibrant to darkest.

| Index | Hex | Reference |
|---|---|---|
| PRIMARY[0] | `#3867FF` | Default single-series colour (vibrant blue) |
| PRIMARY[1] | `#7696FF` | Mid-light blue |
| PRIMARY[2] | `#A9BDFF` | Soft blue |
| PRIMARY[3] | `#DEE2FF` | Pale blue |
| PRIMARY[4] | `#001FFF` | Pure blue |
| PRIMARY[5] | `#3636BB` | Deep blue-violet |
| PRIMARY[6] | `#22227E` | Navy |
| PRIMARY[7] | `#303052` | Dark slate |

### 1.2 Secondary Series — Purple (9+ series ONLY)

Extend into these **only** when a chart has more than 8 data series.

| Index | Hex | Reference |
|---|---|---|
| SECONDARY[0] | `#A580FF` | Light purple |
| SECONDARY[1] | `#592DC5` | Mid purple |
| SECONDARY[2] | `#371096` | Deep purple |

### 1.3 Accent — Orange (Highlighting ONLY)

Use **only** to highlight a specific series or data point. Never as a default data colour.

| Token | Hex | Usage |
|---|---|---|
| ACCENT_ORANGE | `#FF7800` | Primary highlight |
| ACCENT_ORANGE_LIGHT | `#FFBA7D` | Secondary / softer highlight |

### 1.4 Structural Colours

| Token | Hex | Usage |
|---|---|---|
| BG | `#FFFFFF` | Primary background |
| BG_PANEL | `#F8FAFC` | Card / panel background |
| BG_CARD | `#F1F5F9` | Elevated surface |
| TEXT_PRIMARY | `#1F1F1F` | Primary text, X-axis line |
| TEXT_MUTED | `#9B9B9B` | X and Y axis tick marks |
| GRID_COLOR | `#5F5F5F` | Horizontal gridlines |
| BORDER_COLOR | `#CBD5E1` | Borders |

### 1.5 Semantic Exceptions (Inline Only)

For contexts where directional colour is essential (waterfall charts, KPI trend indicators, scorecards), use these as **inline hex values** — they are not defined as named variables in the setup block.

| Hex | Usage |
|---|---|
| `#10B981` | Positive / success (green) |
| `#EF4444` | Negative / risk (red) |

---

## 2. Typography

### Text Specifications

| Element | Size | Weight | Colour |
|---|---|---|---|
| Title | 18px | Bold | `#1F1F1F` (TEXT_PRIMARY) |
| Subtitle | 12px | Regular | `#1F1F1F` (TEXT_PRIMARY) |
| Axis labels | 12px | Bold | `#1F1F1F` (TEXT_PRIMARY) |
| Tick labels | 10px | Regular | `#9B9B9B` (both X and Y axis) |
| Legend | 12px | Bold | `#1F1F1F` (TEXT_PRIMARY) |
| Data labels / Annotations | 12px | Bold | Series colour, or `#FF7800` / `#3867FF` / `#A580FF` |
| Source line | 8px | Regular | `#1F1F1F` (TEXT_PRIMARY) |

### Font Stack

- **Primary:** FK Grotesk Neue (bundled — TTF files in `~/.claude/keyrock/assets/fonts/`)
- **Fallback chain:** Inter, Inter Tight, Helvetica Neue, Helvetica, Arial, DejaVu Sans

### Kerning

Designer spec is **-10 tracking** for all text. FK Grotesk Neue's natural metrics provide tight tracking. matplotlib does not support CSS-style letter-spacing natively — the font's built-in tracking is the best approximation. For pixel-perfect kerning, export SVG and adjust in Figma or Illustrator.

### Headline Style

Bold, punchy headlines are preferred. Keep titles concise and informative.

---

## 3. Logo

### Files

Located in `~/.claude/keyrock/assets/`:

| File | Mode |
|---|---|
| `keyrock-logo-black.svg` | Light mode |
| `keyrock-logo-black.png` | Light mode |
| `keyrock-logo-white.svg` | Dark mode |
| `keyrock-logo-white.png` | Dark mode |

### Placement Rules

- **Default position:** Bottom-right corner
- **Size:** Approximately 8–10% of chart width
- **Clear space:** At least 10px from all chart edges
- **Always embedded** in output by default
- Logo brand black is `#171717`

### Mode Selection

- Light mode charts: use **black** logo variant
- Dark mode charts: use **white** logo variant

---

## 4. Source Lines

- **Default text:** "Source: Keyrock Research"
- User may override with a specific source string
- **Position:** Far-left of the chart (x=0.01), bottom
- **Format:** 8px, Regular, `#1F1F1F` (TEXT_PRIMARY)
- Encouraged by default; user can request omission

---

## 5. Number Formatting

| Scale | Format | Example |
|---|---|---|
| Trillions | `$X.XT` | $1.5T |
| Billions | `$X.XB` | $1.2B |
| Millions | `$X.XM` or `$XXXM` | $340M |
| Full numbers | Comma-separated thousands | $1,250,000 |

- **One decimal maximum** for abbreviated numbers
- Always prefix financial data with `$` (USD assumed unless stated)

---

## 6. Design Direction

### Do

- Institutional, clean, modern, understated
- Credible, polished, brand-consistent
- Balanced whitespace
- Subtle gridlines (low alpha)
- Branded but not loud

### Do Not

- Flashy or decorative
- Generic startup / SaaS aesthetic
- Overly busy annotations or ornaments
- Loud colour usage without purpose

---

## 7. Chart Colour Assignment Rules

Colours are assigned in this strict priority order:

1. **Primary blues first** — use `CHART_COLORS` (8 blue tones) for all standard data series
2. **Secondary purples only for 9+ series** — extend into `CHART_COLORS_EXTENDED` when more than 8 categories
3. **Accent orange for highlighting only** — use `ACCENT_ORANGE` to draw attention to a specific data point or series, never as a default data colour
4. **Single-series default:** `PRIMARY_DEFAULT` (`#3867FF`)
5. **Semantic exceptions:** For waterfall positive/negative, KPI trends, and scorecard status, use inline green (`#10B981`) and red (`#EF4444`) — see section 1.5
6. **Diverging colormaps:** Red (`#EF4444`) through white to `PRIMARY[0]` (`#3867FF`)
7. **Never** use background or text colours for data series

---

## 8. Layout Rules

### Margins and Spacing

- Margins: Generous but not wasteful
- Title padding: 15–20px above chart area
- Logo clear space: At least 10px from chart edges
- Source line: Below chart area, left-aligned

### Legend

- 12px, Bold
- Placement varies by chart type (refer to `chart-templates.md` for specifics)

### Aspect Ratios (Context-Adaptive)

| Context | Dimensions | Ratio |
|---|---|---|
| PDF report full-width | ~1200 x 700 | ~1.7:1 (landscape) |
| PDF report half-width | ~600 x 450 | ~1.33:1 (slightly taller) |
| Slide | ~1920 x 1080 | 16:9 |
| Social / web | ~1200 x 630 | ~2:1 |
| Square (social) | 1080 x 1080 | 1:1 |

---

## 9. Axis Rules

### Spines

- **Top spine:** Hidden
- **Right spine:** Hidden
- **Bottom spine (X-axis):** Visible, **2px** width, colour `#1F1F1F`
- **Left spine (Y-axis):** Hidden — no Y-axis line

### Tick Marks

- **Y-axis ticks:** 1px width, colour `#9B9B9B` — horizontal gridlines at tick positions extend the full chart width, serving as visual reference lines in place of the Y-axis spine
- **X-axis ticks:** 1px width, colour `#9B9B9B`
- **Placement:** Ticks on main data points only

### Gridlines

- **Horizontal gridlines** span the full chart width at Y-axis tick positions
- Alpha: 0.3, linewidth: 0.5
- No vertical gridlines by default

---

## 10. Annotation Rules

- Use annotations **only when they add clarity** — do not over-annotate
- If legend and axis labels communicate the message, annotations may not be needed

### Style Guidelines

| Element | Rule |
|---|---|
| Annotation colour | Match the annotated data series, or use `#FF7800` / `#3867FF` / `#A580FF` |
| Font size | 12px, Bold |
| Leader lines | Thin (1–1.5px), match data series colour |
| Callout boxes | BG_PANEL or BG_CARD background with accent-coloured border |
| Overall | Clean, not busy or cluttered |

---

## 11. Accessibility

- Ensure sufficient contrast between data colours and background
- The primary blue palette provides adequate contrast on `#FFFFFF`
- When using inline semantic green/red, add **pattern or marker differentiation** for colour-blind friendliness

---

## 12. Matplotlib Global Defaults (Python)

Every generated chart script must begin with this setup block.

### 12.1 Light Mode Setup (Default)

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import matplotlib.font_manager as fm
import numpy as np
import os

# === REGISTER FK GROTESK NEUE FONTS ===
_font_dir = os.path.expanduser('~/.claude/keyrock/assets/fonts')
for _ttf in ['FKGroteskNeue-Regular.ttf', 'FKGroteskNeue-Medium.ttf',
             'FKGroteskNeue-Bold.ttf', 'FKGroteskNeue-Light.ttf']:
    _path = os.path.join(_font_dir, _ttf)
    if os.path.exists(_path):
        fm.fontManager.addfont(_path)

# === KEYROCK BRAND PALETTE — LIGHT MODE (DEFAULT) ===
BG = '#FFFFFF'
BG_PANEL = '#F8FAFC'
BG_CARD = '#F1F5F9'

TEXT_PRIMARY = '#1F1F1F'
TEXT_MUTED = '#9B9B9B'

# Primary series colours (blue tones, up to 8 series)
PRIMARY = ['#3867FF', '#7696FF', '#A9BDFF', '#DEE2FF', '#001FFF', '#3636BB', '#22227E', '#303052']
PRIMARY_DEFAULT = PRIMARY[0]

# Secondary series colours (purple, 9+ series only)
SECONDARY = ['#A580FF', '#592DC5', '#371096']

# Accent colours (highlighting only — never as default data colour)
ACCENT_ORANGE = '#FF7800'
ACCENT_ORANGE_LIGHT = '#FFBA7D'

# Chart colour cycles
CHART_COLORS = PRIMARY.copy()
CHART_COLORS_EXTENDED = PRIMARY + SECONDARY

# Axis styling
X_AXIS_COLOR = TEXT_PRIMARY    # #1F1F1F — X-axis line only
TICK_COLOR = TEXT_MUTED        # #9B9B9B — both X and Y tick marks
GRID_COLOR = '#5F5F5F'
BORDER_COLOR = '#CBD5E1'

# Kerning note: Designer spec is -10 tracking for all text.
# FK Grotesk Neue has naturally tight tracking in its font metrics.
# matplotlib does not support letter-spacing adjustment. The font's
# default tracking is the closest achievable approximation.

plt.rcParams.update({
    'font.family': 'sans-serif',
    'font.sans-serif': ['FK Grotesk Neue', 'Inter', 'Inter Tight', 'Helvetica Neue', 'Helvetica', 'Arial', 'DejaVu Sans'],
    'font.size': 12,
    'text.color': TEXT_PRIMARY,
    'axes.facecolor': BG,
    'figure.facecolor': BG,
    'axes.edgecolor': BORDER_COLOR,
    'axes.labelcolor': TEXT_PRIMARY,
    'axes.labelweight': 'bold',
    'axes.labelsize': 12,
    'xtick.color': TICK_COLOR,
    'ytick.color': TICK_COLOR,
    'xtick.labelsize': 10,
    'ytick.labelsize': 10,
    'grid.color': GRID_COLOR,
    'grid.alpha': 0.3,
    'legend.fontsize': 12,
})

LOGO_PATH = os.path.expanduser('~/.claude/keyrock/assets/keyrock-logo-black.png')
```

### 12.2 Dark Mode Override

> **Note:** The new palette was specified for light mode only. Dark mode structural colours have been adapted to work with the new data colours. PRIMARY and SECONDARY palettes are used identically in both modes. This adaptation is pending designer review.

When dark mode is requested, apply this block **after** the light mode setup:

```python
# === DARK MODE OVERRIDE ===
BG = '#0B1A2E'
BG_PANEL = '#122240'
BG_CARD = '#1A2D4A'
TEXT_PRIMARY = '#FFFFFF'
TEXT_MUTED = '#9B9B9B'
X_AXIS_COLOR = '#FFFFFF'
TICK_COLOR = '#9B9B9B'
GRID_COLOR = '#1E3A5F'
BORDER_COLOR = '#2D4A6F'

# PRIMARY, SECONDARY, ACCENT colours stay identical (high-saturation, work on dark)

plt.rcParams.update({
    'text.color': TEXT_PRIMARY,
    'axes.facecolor': BG,
    'figure.facecolor': BG,
    'axes.edgecolor': BORDER_COLOR,
    'axes.labelcolor': TEXT_PRIMARY,
    'xtick.color': TICK_COLOR,
    'ytick.color': TICK_COLOR,
    'grid.color': GRID_COLOR,
    'grid.alpha': 0.2,
})

LOGO_PATH = os.path.expanduser('~/.claude/keyrock/assets/keyrock-logo-white.png')
```

---

## 13. Axis Styling Helper (matplotlib)

```python
def style_axes(ax, grid_axis='y'):
    """Apply Keyrock brand axis styling.
    grid_axis: 'y' (default), 'x', 'both', or None to disable grid.
    """
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.spines['bottom'].set_color(X_AXIS_COLOR)
    ax.spines['bottom'].set_linewidth(2)

    ax.tick_params(axis='y', colors=TICK_COLOR, labelsize=10, width=1, length=4)
    ax.tick_params(axis='x', colors=TICK_COLOR, labelsize=10, width=1, length=4)

    if grid_axis:
        ax.grid(axis=grid_axis, alpha=0.3, linewidth=0.5, zorder=0, color=GRID_COLOR)
```

---

## 14. Logo Placement Pattern (matplotlib)

```python
def add_keyrock_logo(fig, logo_path=LOGO_PATH, size=0.08, position='bottom-right', padding=0.02):
    """Add Keyrock logo to chart. size is fraction of figure width."""
    try:
        logo = mpimg.imread(logo_path)
        aspect = logo.shape[1] / logo.shape[0]  # width/height
        logo_width = size
        logo_height = logo_width / aspect * (fig.get_figwidth() / fig.get_figheight())

        if position == 'bottom-right':
            x = 1 - padding - logo_width
            y = padding
        elif position == 'bottom-left':
            x = padding
            y = padding
        elif position == 'top-right':
            x = 1 - padding - logo_width
            y = 1 - padding - logo_height
        elif position == 'top-left':
            x = padding
            y = 1 - padding - logo_height

        logo_ax = fig.add_axes([x, y, logo_width, logo_height])
        logo_ax.imshow(logo)
        logo_ax.axis('off')
    except FileNotFoundError:
        pass  # Skip logo if file not found
```

---

## 15. Export Pattern (matplotlib)

```python
def export_chart(fig, name, output_dir='.', dpi=250, formats=('svg', 'png', 'pdf')):
    """Export chart in multiple formats. SVG is master."""
    os.makedirs(output_dir, exist_ok=True)
    for fmt in formats:
        path = os.path.join(output_dir, f'{name}.{fmt}')
        fig.savefig(path, dpi=dpi, bbox_inches='tight',
                    facecolor=fig.get_facecolor(), edgecolor='none',
                    format=fmt)
    plt.close(fig)
```

---

## Quick Reference — Colour Hex Cheat Sheet

```
Primary Series (blue tones, use first):
PRIMARY[0]  #3867FF   Default / vibrant blue
PRIMARY[1]  #7696FF   Mid-light blue
PRIMARY[2]  #A9BDFF   Soft blue
PRIMARY[3]  #DEE2FF   Pale blue
PRIMARY[4]  #001FFF   Pure blue
PRIMARY[5]  #3636BB   Deep blue-violet
PRIMARY[6]  #22227E   Navy
PRIMARY[7]  #303052   Dark slate

Secondary (purple, 9+ series only):
SECONDARY[0]  #A580FF  Light purple
SECONDARY[1]  #592DC5  Mid purple
SECONDARY[2]  #371096  Deep purple

Accent (highlighting only):
ACCENT_ORANGE        #FF7800
ACCENT_ORANGE_LIGHT  #FFBA7D

Semantic exceptions (inline hex only):
Positive   #10B981   (green)
Negative   #EF4444   (red)

Structural:
BG           #FFFFFF   TEXT_PRIMARY  #1F1F1F
TEXT_MUTED   #9B9B9B   GRID_COLOR   #5F5F5F
```
