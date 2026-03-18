# Keyrock Chart Templates Reference

> Reusable matplotlib code patterns for every supported chart type.
> All templates assume brand palette variables and helper functions from `brand-system.md` are defined earlier in the script.

---

## Table of Contents

### Standard Data Charts
1. [Vertical Bar Chart](#1-vertical-bar-chart)
2. [Horizontal Bar Chart](#2-horizontal-bar-chart)
3. [Stacked Bar Chart](#3-stacked-bar-chart)
4. [Line Chart](#4-line-chart)
5. [Area Chart](#5-area-chart)
6. [Scatter Plot](#6-scatter-plot)
7. [Pie / Donut Chart](#7-pie--donut-chart)
8. [Heatmap](#8-heatmap)
9. [Waterfall Chart](#9-waterfall-chart)
10. [Combo Chart](#10-combo-chart)

### Diagrams and Special Formats
11. [Timeline / Gantt](#11-timeline--gantt)
12. [Flowchart / Process Flow](#12-flowchart--process-flow)
13. [Flywheel / Circular Diagram](#13-flywheel--circular-diagram)
14. [Convergence Diagram](#14-convergence-diagram)
15. [Scorecard / Table](#15-scorecard--table)
16. [KPI / Metric Cards](#16-kpi--metric-cards)
17. [Comparison Table](#17-comparison-table)
18. [Treemap](#18-treemap)
19. [Sankey Diagram](#19-sankey-diagram)

### Shared Conventions
- [Title Patterns](#title-patterns)
- [Source Lines](#source-lines)
- [Number Formatting](#number-formatting)
- [Grid and Spine Rules](#grid-and-spine-rules)
- [Legend Patterns](#legend-patterns)
- [Data Label Patterns](#data-label-patterns)
- [Axis Rules](#axis-rules)

---

## Shared Conventions

### Title Patterns

```python
# Single title
ax.set_title('Chart Title Here', fontsize=22, color=TEXT_PRIMARY, weight='bold', pad=20, loc='center')

# Title + subtitle
fig.suptitle('Main Title', fontsize=22, weight='bold', color=TEXT_PRIMARY, y=0.98)
ax.set_title('Subtitle text here', fontsize=12, color=TEXT_PRIMARY, pad=10)
```

### Source Lines

```python
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)
```

### Number Formatting

```python
def format_number(val):
    """Format number as $1.2B / $340M / $1.5T"""
    if abs(val) >= 1e12:
        return f'${val/1e12:.1f}T'
    elif abs(val) >= 1e9:
        return f'${val/1e9:.1f}B'
    elif abs(val) >= 1e6:
        return f'${val/1e6:.0f}M'
    elif abs(val) >= 1e3:
        return f'${val/1e3:.0f}K'
    else:
        return f'${val:.0f}'
```

### Colour Cycle Selection

Choose the right colour cycle based on the number of data series/categories:

```python
# 2–4 categories: use standard accents
colors = CHART_COLORS[:n_categories]

# 5+ categories: use extended palette (preferred for multi-category charts)
colors = CHART_COLORS_EXTENDED[:n_categories]
```

The primary palette (`CHART_COLORS` / `PRIMARY`) provides 8 blue tones — from bright `#3867FF` through periwinkle, cornflower, and slate — that form a cohesive, institutional sequence for most charts. For 9+ categories, `CHART_COLORS_EXTENDED` (`PRIMARY + SECONDARY`) appends three purple tones to extend the palette without breaking visual harmony.

When semantic meaning applies (e.g., `#10B981` green = positive, `#EF4444` red = negative), inline semantic hex values override the cycle regardless of category count. Use `ACCENT_ORANGE` (`#FF7800`) only for deliberate highlighting or milestone markers, never as a series colour.

### Grid and Spine Rules

```python
# Always remove top, right, and left spines
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.spines['left'].set_visible(False)

# Bottom spine (X-axis line): visible, 2px
ax.spines['bottom'].set_color(X_AXIS_COLOR)
ax.spines['bottom'].set_linewidth(2)

# Light mode grid
ax.grid(axis='y', alpha=0.3, linewidth=0.5)

# Dark mode grid
ax.grid(axis='y', alpha=0.15, linewidth=0.5)

# Bar charts: y-axis grid only
# Scatter plots: both axes
# Line charts: y-axis only (or both if helpful)
```

### Legend Patterns

```python
# Bar charts — legend above chart or integrated into title
ax.legend(loc='upper left', framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# Line charts — upper-left or upper-right
ax.legend(loc='upper left', framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# Pie/donut — labels on chart, no separate legend

# General pattern
ax.legend(framealpha=0.8, edgecolor='none', facecolor=BG)
```

### Data Label Patterns

```python
# Bar chart value labels
for bar in bars:
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width() / 2, height + offset,
            format_number(height), ha='center', va='bottom',
            fontsize=12, color=TEXT_PRIMARY, weight='bold')

# Horizontal bar value labels
for bar in bars:
    width = bar.get_width()
    ax.text(width + offset, bar.get_y() + bar.get_height() / 2,
            format_number(width), ha='left', va='center',
            fontsize=12, color=TEXT_PRIMARY, weight='bold')

# Line chart endpoint annotation
ax.annotate(f'{y_values[-1]:.1f}%',
            xy=(x_values[-1], y_values[-1]),
            xytext=(10, 0), textcoords='offset points',
            fontsize=12, color=line_color, weight='bold')
```

### Axis Rules

```python
# Apply standard Keyrock axis styling (defined in brand-system.md section 13)
style_axes(ax)  # default: y-axis grid only
style_axes(ax, grid_axis='x')   # for horizontal bar charts
style_axes(ax, grid_axis='both') # for scatter plots
style_axes(ax, grid_axis=None)   # no grid

# Rotate x-axis labels if dates or long labels
ax.tick_params(axis='x', rotation=45)
plt.setp(ax.get_xticklabels(), ha='right')

# Y-axis label when unit not obvious
ax.set_ylabel('Volume (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
```

---

## Standard Data Charts

---

### 1. Vertical Bar Chart

**When to use:** Comparing discrete categories — revenue by quarter, volume by exchange, counts by type. The default workhorse chart for categorical comparisons.

**Recommended dimensions:**
- Report/web: `figsize=(10, 6)`
- Slide (wide): `figsize=(12, 6)`
- Compact/dashboard: `figsize=(8, 5)`

**Colour assignment:**
- Single series: `PRIMARY_DEFAULT` for all bars, or `PRIMARY[4]` if extra contrast is needed
- Grouped: cycle through `CHART_COLORS` in order — one colour per series
- Highlight a specific bar: use `ACCENT_ORANGE` for the bar to call out, rest in `PRIMARY_DEFAULT`

**Key styling rules:**
- Bar width 0.6 for single series, adjusted for grouped
- Y-axis grid only, alpha=0.3
- Value labels above bars — only for key values or when fewer than ~10 bars
- No top/right spines

#### Single Series Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
categories = ['BTC', 'ETH', 'SOL', 'XRP', 'ADA', 'AVAX']
values = [42.5e9, 18.3e9, 8.7e9, 6.2e9, 3.1e9, 2.8e9]

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Bars ---
bars = ax.bar(categories, values, width=0.6, color=PRIMARY_DEFAULT, edgecolor='none', zorder=3)

# --- Value labels ---
for bar in bars:
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width() / 2, height + max(values) * 0.02,
            format_number(height), ha='center', va='bottom',
            fontsize=12, color=TEXT_PRIMARY, weight='bold')

# --- Styling ---
ax.set_title('24h Trading Volume by Asset', fontsize=22, color=TEXT_PRIMARY,
             weight='bold', pad=20, loc='center')
ax.set_ylabel('Volume (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax)
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: format_number(x)))

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'vertical_bar_single')
```

#### Grouped Bar Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
categories = ['Q1 2025', 'Q2 2025', 'Q3 2025', 'Q4 2025']
series_labels = ['CEX', 'DEX', 'OTC']
data = {
    'CEX': [120e9, 135e9, 128e9, 142e9],
    'DEX': [45e9, 62e9, 58e9, 71e9],
    'OTC': [18e9, 22e9, 25e9, 30e9],
}

x = np.arange(len(categories))
n_series = len(series_labels)
bar_width = 0.25

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Bars ---
for i, (label, vals) in enumerate(data.items()):
    offset = (i - n_series / 2 + 0.5) * bar_width
    bars = ax.bar(x + offset, vals, bar_width, label=label,
                  color=CHART_COLORS[i], edgecolor='none', zorder=3)

# --- Styling ---
ax.set_title('Quarterly Trading Volume by Venue Type', fontsize=22,
             color=TEXT_PRIMARY, weight='bold', pad=20, loc='center')
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.set_ylabel('Volume (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax)
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: format_number(x)))
ax.legend(loc='upper left', framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'vertical_bar_grouped')
```

**Variation notes:**
- To highlight one bar: create a colours list where one entry is `ACCENT_ORANGE` and the rest are `PRIMARY_DEFAULT`
- For many categories (>8): consider switching to horizontal bar chart
- For negative values: bars extend below zero — add `ax.axhline(y=0, color=GRID_COLOR, linewidth=0.8)` as a baseline

---

### 2. Horizontal Bar Chart

**When to use:** Rankings, comparisons where category labels are long, or when there are many categories (>8). Natural reading order — top-to-bottom for rankings.

**Recommended dimensions:**
- Standard: `figsize=(10, 6)`
- Many categories (10+): `figsize=(10, 8)` or taller
- Compact: `figsize=(8, 5)`

**Colour assignment:**
- Single series: `PRIMARY_DEFAULT` for all bars
- Grouped: cycle through `CHART_COLORS`
- Top-N highlight: `PRIMARY_DEFAULT` for top items, `GRID_COLOR` or lighter blue for rest

**Key styling rules:**
- Value labels to the right of bars
- Categories on y-axis — reverse order so #1 is at top
- X-axis grid only (horizontal lines become vertical in horizontal bar)
- Bar height 0.6 for single series

#### Single Series Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data (pre-sorted descending) ---
categories = ['Binance', 'Coinbase', 'OKX', 'Bybit', 'Kraken',
              'Bitfinex', 'KuCoin', 'Gate.io']
values = [28.5e9, 12.3e9, 9.8e9, 7.4e9, 5.1e9, 3.8e9, 3.2e9, 2.1e9]

# Reverse for bottom-to-top plotting (so #1 is at top)
categories = categories[::-1]
values = values[::-1]

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Bars ---
bars = ax.barh(categories, values, height=0.6, color=PRIMARY_DEFAULT, edgecolor='none', zorder=3)

# --- Value labels ---
max_val = max(values)
for bar in bars:
    width = bar.get_width()
    ax.text(width + max_val * 0.02, bar.get_y() + bar.get_height() / 2,
            format_number(width), ha='left', va='center',
            fontsize=12, color=TEXT_PRIMARY, weight='bold')

# --- Styling ---
ax.set_title('24h Spot Volume by Exchange', fontsize=22, color=TEXT_PRIMARY,
             weight='bold', pad=20, loc='center')
ax.set_xlabel('Volume (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax, grid_axis='x')
ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: format_number(x)))

# Expand x-axis for label room
ax.set_xlim(0, max(values) * 1.15)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'horizontal_bar_single')
```

#### Grouped Horizontal Bar Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
categories = ['Binance', 'Coinbase', 'OKX', 'Bybit', 'Kraken']
series_labels = ['Spot', 'Derivatives']
data = {
    'Spot':        [28.5e9, 12.3e9, 9.8e9, 7.4e9, 5.1e9],
    'Derivatives': [45.2e9, 8.1e9, 22.4e9, 18.9e9, 3.2e9],
}

# Reverse for top-to-bottom ranking
categories = categories[::-1]
for key in data:
    data[key] = data[key][::-1]

y = np.arange(len(categories))
n_series = len(series_labels)
bar_height = 0.35

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Bars ---
for i, (label, vals) in enumerate(data.items()):
    offset = (i - n_series / 2 + 0.5) * bar_height
    ax.barh(y + offset, vals, bar_height, label=label,
            color=CHART_COLORS[i], edgecolor='none', zorder=3)

# --- Styling ---
ax.set_title('Exchange Volume: Spot vs Derivatives', fontsize=22,
             color=TEXT_PRIMARY, weight='bold', pad=20, loc='center')
ax.set_yticks(y)
ax.set_yticklabels(categories)
ax.set_xlabel('Volume (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax, grid_axis='x')
ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: format_number(x)))
ax.legend(loc='lower right', framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'horizontal_bar_grouped')
```

**Variation notes:**
- For top-3 highlight: `colors = [PRIMARY_DEFAULT if i >= len(categories)-3 else '#B0BEC5' for i in range(len(categories))]` (remember data is reversed)
- For percentage bars: set `ax.set_xlim(0, 100)` and add `%` suffix to labels
- For diverging bars (e.g., sentiment): center at zero, use `PRIMARY_DEFAULT` for positive, `'#EF4444'` for negative

---

### 3. Stacked Bar Chart

**When to use:** Showing composition of a total across categories. Each bar represents a whole, segments show parts. Good for market share over time, portfolio allocation breakdown.

**Recommended dimensions:**
- Standard: `figsize=(10, 6)`
- Wide (many categories): `figsize=(12, 6)`

**Colour assignment:**
- Cycle through `CHART_COLORS` for each segment
- Largest segment at bottom, smallest at top
- Use opacity variation for 6+ segments to avoid clutter

**Key styling rules:**
- Y-axis grid only
- Optional: percentage labels inside segments (only if segment is large enough)
- Total value label above each bar

#### Vertical Stacked Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
categories = ['2021', '2022', '2023', '2024', '2025']
segments = ['Bitcoin', 'Ethereum', 'Stablecoins', 'DeFi Tokens', 'Other']
data = np.array([
    [850e9, 520e9, 380e9, 920e9, 1100e9],    # Bitcoin
    [420e9, 280e9, 210e9, 480e9, 580e9],      # Ethereum
    [130e9, 190e9, 250e9, 310e9, 400e9],      # Stablecoins
    [95e9,  60e9,  45e9,  120e9, 180e9],       # DeFi Tokens
    [105e9, 70e9,  55e9,  90e9,  140e9],       # Other
])

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Stacked bars ---
bottom = np.zeros(len(categories))
for i, (segment, row) in enumerate(zip(segments, data)):
    ax.bar(categories, row, width=0.6, bottom=bottom, label=segment,
           color=CHART_COLORS[i], edgecolor='none', zorder=3)
    bottom += row

# --- Total labels ---
totals = data.sum(axis=0)
for j, total in enumerate(totals):
    ax.text(j, total + max(totals) * 0.02, format_number(total),
            ha='center', va='bottom', fontsize=12, color=TEXT_PRIMARY, weight='bold')

# --- Styling ---
ax.set_title('Crypto Market Capitalisation by Segment', fontsize=22,
             color=TEXT_PRIMARY, weight='bold', pad=20, loc='center')
ax.set_ylabel('Market Cap (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax)
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: format_number(x)))
ax.legend(loc='upper left', framealpha=0.8, edgecolor='none', facecolor=BG,
          fontsize=12, ncol=3, prop={'weight': 'bold'})

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'stacked_bar_vertical')
```

#### Horizontal Stacked Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
categories = ['Portfolio A', 'Portfolio B', 'Portfolio C', 'Portfolio D']
segments = ['BTC', 'ETH', 'Stablecoins', 'Alts']
# Percentages that sum to 100 per category
data = np.array([
    [45, 55, 40, 30],   # BTC
    [25, 20, 25, 35],   # ETH
    [20, 15, 25, 15],   # Stablecoins
    [10, 10, 10, 20],   # Alts
])

# Reverse for top-to-bottom
categories = categories[::-1]
data = data[:, ::-1]

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 5), facecolor=BG)
ax.set_facecolor(BG)

# --- Stacked bars ---
left = np.zeros(len(categories))
for i, (segment, row) in enumerate(zip(segments, data)):
    bars = ax.barh(categories, row, height=0.6, left=left, label=segment,
                   color=CHART_COLORS[i], edgecolor='none', zorder=3)
    # Percentage labels inside segments (only if wide enough)
    for j, (bar, val) in enumerate(zip(bars, row)):
        if val >= 12:  # Only label segments >= 12%
            ax.text(left[j] + val / 2, bar.get_y() + bar.get_height() / 2,
                    f'{val}%', ha='center', va='center',
                    fontsize=12, color='white', weight='bold')
    left += row

# --- Styling ---
ax.set_title('Portfolio Allocation Comparison', fontsize=22,
             color=TEXT_PRIMARY, weight='bold', pad=20, loc='center')
ax.set_xlabel('Allocation (%)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
ax.set_xlim(0, 100)
style_axes(ax, grid_axis='x')
ax.legend(loc='lower right', framealpha=0.8, edgecolor='none', facecolor=BG,
          fontsize=12, ncol=2, prop={'weight': 'bold'})

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'stacked_bar_horizontal')
```

**Variation notes:**
- 100% stacked: normalize each column to sum to 100, set x/y-limit to 100
- For segment labels inside bars, only show if segment is wide enough (>12% of total)
- For many segments (6+), consider grouping smaller ones into "Other"

---

### 4. Line Chart

**When to use:** Time series data, trends over time, continuous data. Best for showing change patterns, cycles, and trajectories. Use for price history, adoption curves, performance metrics.

**Recommended dimensions:**
- Standard: `figsize=(12, 6)`
- Compact: `figsize=(10, 5)`
- Dashboard panel: `figsize=(8, 4)`

**Colour assignment:**
- Single line: `PRIMARY_DEFAULT`
- Multi-series: cycle through `CHART_COLORS` in order
- Benchmark/reference line: `TEXT_MUTED` with dashed style
- Area fill under line: same colour at `alpha=0.15`

**Key styling rules:**
- Line width 2.0-2.5 for primary series, 1.5 for secondary
- Y-axis grid, subtle
- Annotate endpoints with values
- Optional: shade area under line for emphasis
- Date formatting: use `mdates` for time axes

#### Single Line Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np
from datetime import datetime, timedelta

# --- Data ---
dates = [datetime(2024, 1, 1) + timedelta(days=i*7) for i in range(52)]
values = np.cumsum(np.random.randn(52) * 2) + 50  # Simulated price data
# For real data, replace with actual values

# --- Figure ---
fig, ax = plt.subplots(figsize=(12, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Line ---
ax.plot(dates, values, color=PRIMARY_DEFAULT, linewidth=2.5, zorder=3)

# --- Optional area fill ---
ax.fill_between(dates, values, alpha=0.15, color=PRIMARY_DEFAULT, zorder=2)

# --- Endpoint annotation ---
ax.annotate(f'${values[-1]:.0f}',
            xy=(dates[-1], values[-1]),
            xytext=(10, 5), textcoords='offset points',
            fontsize=10, color=PRIMARY_DEFAULT, weight='bold')

# --- Styling ---
ax.set_title('BTC Weekly Price (2024)', fontsize=22, color=TEXT_PRIMARY,
             weight='bold', pad=20, loc='center')
ax.set_ylabel('Price (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax)
ax.xaxis.set_major_formatter(mdates.DateFormatter('%b %Y'))
ax.xaxis.set_major_locator(mdates.MonthLocator(interval=2))
plt.setp(ax.get_xticklabels(), rotation=45, ha='right')

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'line_single')
```

#### Multi-Series Line Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np
from datetime import datetime, timedelta

# --- Data ---
months = [datetime(2024, m, 1) for m in range(1, 13)]
series = {
    'BTC Dominance':  [48.2, 49.1, 50.3, 51.8, 52.4, 51.9, 53.1, 54.2, 53.8, 52.5, 51.0, 50.5],
    'ETH Dominance':  [18.5, 18.2, 17.8, 17.1, 16.8, 17.2, 16.5, 16.0, 16.3, 17.1, 17.8, 18.0],
    'Stablecoin Share': [8.2, 8.5, 8.8, 9.1, 9.4, 9.8, 10.1, 10.5, 10.8, 11.0, 11.2, 11.5],
}

# --- Figure ---
fig, ax = plt.subplots(figsize=(12, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Lines ---
for i, (label, values) in enumerate(series.items()):
    ax.plot(months, values, color=CHART_COLORS[i], linewidth=2.5,
            label=label, zorder=3, marker='o', markersize=4)
    # Endpoint annotation
    ax.annotate(f'{values[-1]:.1f}%',
                xy=(months[-1], values[-1]),
                xytext=(10, 0), textcoords='offset points',
                fontsize=12, color=CHART_COLORS[i], weight='bold')

# --- Styling ---
ax.set_title('Market Dominance Trends (2024)', fontsize=22, color=TEXT_PRIMARY,
             weight='bold', pad=20, loc='center')
ax.set_ylabel('Market Share (%)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax)
ax.xaxis.set_major_formatter(mdates.DateFormatter('%b'))
ax.legend(loc='upper right', framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# Expand x-axis for endpoint labels
ax.set_xlim(months[0] - timedelta(days=5), months[-1] + timedelta(days=30))

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'line_multi')
```

**Variation notes:**
- Dashed reference line: `ax.axhline(y=50, color=TEXT_MUTED, linestyle='--', linewidth=1, alpha=0.5, label='Baseline')`
- Shaded region between two lines: `ax.fill_between(dates, series1, series2, alpha=0.15, color=PRIMARY_DEFAULT)`
- Log scale: `ax.set_yscale('log')` — useful for crypto price history
- Confidence interval: plot two boundary lines and `fill_between` them

---

### 5. Area Chart

**When to use:** Stacked areas show how parts compose a total over time. Good for market composition, TVL breakdown, volume contribution over time.

**Recommended dimensions:**
- Standard: `figsize=(12, 6)`
- Wide: `figsize=(14, 6)`

**Colour assignment:**
- Cycle through `CHART_COLORS` with `alpha=0.7` for fills
- Largest area at bottom
- Edge lines: same colour, full opacity, linewidth=1.5

**Key styling rules:**
- Y-axis grid only
- Edge lines on top of fill areas
- Legend in reverse order (matches visual top-to-bottom)

#### Stacked Area Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np
from datetime import datetime, timedelta

# --- Data ---
months = [datetime(2024, m, 1) for m in range(1, 13)]
labels = ['Ethereum', 'BSC', 'Solana', 'Arbitrum', 'Other']
data = np.array([
    [55, 58, 62, 65, 68, 72, 75, 80, 82, 85, 88, 92],    # Ethereum
    [18, 17, 16, 15, 14, 14, 13, 13, 12, 12, 11, 11],     # BSC
    [8,  10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30],     # Solana
    [5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15, 16],     # Arbitrum
    [4,  4,  5,  5,  6,  6,  7,  7,  8,  8,  9,  9],      # Other
])  # Values in billions

# --- Figure ---
fig, ax = plt.subplots(figsize=(12, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Stacked area ---
colors_fill = [c for c in CHART_COLORS[:len(labels)]]
ax.stackplot(months, data, labels=labels, colors=colors_fill, alpha=0.7, zorder=2)

# --- Edge lines for definition ---
cumulative = np.cumsum(data, axis=0)
for i in range(len(labels)):
    ax.plot(months, cumulative[i], color=CHART_COLORS[i], linewidth=1.5, zorder=3)

# --- Styling ---
ax.set_title('DeFi TVL by Chain (2024)', fontsize=22, color=TEXT_PRIMARY,
             weight='bold', pad=20, loc='center')
ax.set_ylabel('TVL (USD Billions)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax)
ax.xaxis.set_major_formatter(mdates.DateFormatter('%b'))

# Legend in reverse order to match visual stacking
handles, leg_labels = ax.get_legend_handles_labels()
ax.legend(handles[::-1], leg_labels[::-1], loc='upper left',
          framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'area_stacked')
```

**Variation notes:**
- 100% stacked area: normalize columns to sum to 100
- Single area (not stacked): use `fill_between` with `alpha=0.2` under a single line
- For percentage display: `ax.set_ylim(0, 100)` and `ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{x:.0f}%'))`

---

### 6. Scatter Plot

**When to use:** Showing relationships between two continuous variables. Correlation analysis, risk-return plots, market cap vs volume comparisons. Optional: add trend line to show linear or polynomial fit.

**Recommended dimensions:**
- Standard: `figsize=(10, 8)` (slightly square)
- Wide context: `figsize=(12, 8)`

**Colour assignment:**
- Single group: `PRIMARY_DEFAULT` with `alpha=0.6`
- Multiple groups: cycle `CHART_COLORS`, `alpha=0.6`
- Trend line: `PRIMARY[5]` or `TEXT_MUTED`, dashed

**Key styling rules:**
- Both x and y grid, very subtle
- Point size can encode a third variable (bubble chart)
- Equal aspect ratio if comparing same-unit axes
- Label outliers or notable points

#### Scatter Plot Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
np.random.seed(42)
n = 40
market_cap = np.random.lognormal(mean=22, sigma=1.5, size=n)  # USD
volume_24h = market_cap * np.random.uniform(0.02, 0.15, size=n)
labels = [f'Token {i+1}' for i in range(n)]

# Notable points to label
notable_indices = [0, 5, 12]
notable_labels = ['BTC', 'ETH', 'SOL']

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 8), facecolor=BG)
ax.set_facecolor(BG)

# --- Scatter ---
ax.scatter(market_cap, volume_24h, c=PRIMARY_DEFAULT, alpha=0.6, s=60,
           edgecolors='white', linewidth=0.5, zorder=3)

# --- Trend line ---
log_mc = np.log10(market_cap)
log_vol = np.log10(volume_24h)
z = np.polyfit(log_mc, log_vol, 1)
p = np.poly1d(z)
x_trend = np.linspace(log_mc.min(), log_mc.max(), 100)
ax.plot(10**x_trend, 10**p(x_trend), color=PRIMARY[5], linewidth=2,
        linestyle='--', alpha=0.7, zorder=2, label='Trend')

# --- Label notable points ---
for idx, label in zip(notable_indices, notable_labels):
    ax.annotate(label,
                xy=(market_cap[idx], volume_24h[idx]),
                xytext=(12, 8), textcoords='offset points',
                fontsize=12, color=TEXT_PRIMARY, weight='bold',
                arrowprops=dict(arrowstyle='->', color=TEXT_MUTED, lw=0.8))

# --- Styling ---
ax.set_title('Market Cap vs 24h Volume', fontsize=22, color=TEXT_PRIMARY,
             weight='bold', pad=20, loc='center')
ax.set_xlabel('Market Cap (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
ax.set_ylabel('24h Volume (USD)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
ax.set_xscale('log')
ax.set_yscale('log')
style_axes(ax, grid_axis='both')
ax.legend(loc='upper left', framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'scatter_plot')
```

**Variation notes:**
- Bubble chart: use `s=sizes_array` where sizes encode a third variable — add a note or size legend
- Colour groups: `ax.scatter(x[mask], y[mask], c=CHART_COLORS[i], label=group_name)`
- Quadrant lines: `ax.axhline(y=median_y, ...)` and `ax.axvline(x=median_x, ...)` with text in each quadrant
- R-squared annotation: compute and display in a text box

---

### 7. Pie / Donut Chart

**When to use:** Use sparingly — only for showing parts of a whole when there are 2-5 categories. Prefer bar charts for more categories. Best for market share, portfolio allocation at a single point in time.

**Recommended dimensions:**
- Standard: `figsize=(8, 8)`
- With side legend: `figsize=(10, 7)`

**Colour assignment:**
- Cycle through `CHART_COLORS`
- Largest slice first (at 12 o'clock, clockwise)
- Highlight slice: `explode` parameter

**Key styling rules:**
- Donut preferred over pie (use `wedgeprops=dict(width=0.4)`)
- Labels on chart with percentage
- Centre text for donut: total value or key metric
- No separate legend — labels on slices

#### Donut Chart Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt

# --- Data ---
labels = ['Ethereum', 'Solana', 'Arbitrum', 'BSC', 'Other']
sizes = [58.2, 15.4, 10.8, 8.3, 7.3]
colors = CHART_COLORS[:len(labels)]
explode = (0.03, 0, 0, 0, 0)  # Slight emphasis on largest

# --- Figure ---
fig, ax = plt.subplots(figsize=(8, 8), facecolor=BG)
ax.set_facecolor(BG)

# --- Donut ---
wedges, texts, autotexts = ax.pie(
    sizes, labels=labels, colors=colors, explode=explode,
    autopct='%1.1f%%', startangle=90, counterclock=False,
    wedgeprops=dict(width=0.4, edgecolor=BG, linewidth=2),
    pctdistance=0.8,
    textprops={'fontsize': 11, 'color': TEXT_PRIMARY}
)

# Style percentage text
for autotext in autotexts:
    autotext.set_fontsize(9)
    autotext.set_weight('bold')
    autotext.set_color('white')

# --- Centre text ---
ax.text(0, 0, '$92B\nTotal TVL', ha='center', va='center',
        fontsize=16, weight='bold', color=TEXT_PRIMARY)

# --- Title ---
ax.set_title('DeFi TVL by Chain', fontsize=22, color=TEXT_PRIMARY,
             weight='bold', pad=30)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'donut_chart')
```

**Variation notes:**
- Full pie (not donut): remove `width=0.4` from `wedgeprops`
- Nested donut: two `ax.pie()` calls with different `radius` and `width` parameters
- More than 5 categories: aggregate small ones into "Other"
- No percentages below 3% on slices — they get too cramped

---

### 8. Heatmap

**When to use:** Correlation matrices, time-based intensity data (hour-of-day vs day-of-week), cross-tabulation comparisons. Shows magnitude through colour intensity.

**Recommended dimensions:**
- Square matrix: `figsize=(10, 8)`
- Rectangular: adjust to match data shape
- Dashboard: `figsize=(8, 6)`

**Colour assignment:**
- Sequential: `PRIMARY_DEFAULT`-based custom colormap (white to blue)
- Diverging: `'#EF4444'` (negative) through white to `PRIMARY_DEFAULT` (positive)
- Use `matplotlib.colors.LinearSegmentedColormap`

**Key styling rules:**
- Cell value labels inside cells (if grid is not too dense)
- Clean cell borders in background colour
- Colour bar on right side
- Rotate column labels if needed

#### Heatmap Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import numpy as np

# --- Data ---
assets = ['BTC', 'ETH', 'SOL', 'XRP', 'ADA', 'AVAX', 'DOT', 'MATIC']
n = len(assets)
# Simulated correlation matrix
np.random.seed(42)
raw = np.random.randn(100, n)
raw[:, 1] = raw[:, 0] * 0.7 + raw[:, 1] * 0.3  # ETH correlated with BTC
corr = np.corrcoef(raw.T)

# --- Diverging colormap: red -> white -> blue ---
cmap_diverging = mcolors.LinearSegmentedColormap.from_list(
    'keyrock_diverging', ['#EF4444', '#FFFFFF', PRIMARY_DEFAULT])

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 8), facecolor=BG)
ax.set_facecolor(BG)

# --- Heatmap ---
im = ax.imshow(corr, cmap=cmap_diverging, vmin=-1, vmax=1, aspect='auto')

# --- Cell labels ---
for i in range(n):
    for j in range(n):
        val = corr[i, j]
        text_color = 'white' if abs(val) > 0.6 else TEXT_PRIMARY
        ax.text(j, i, f'{val:.2f}', ha='center', va='center',
                fontsize=12, color=text_color, weight='bold')

# --- Axes ---
ax.set_xticks(range(n))
ax.set_yticks(range(n))
ax.set_xticklabels(assets, fontsize=12, color=TEXT_PRIMARY)
ax.set_yticklabels(assets, fontsize=12, color=TEXT_PRIMARY)
ax.tick_params(length=0)

# --- Colour bar ---
cbar = plt.colorbar(im, ax=ax, fraction=0.046, pad=0.04)
cbar.ax.tick_params(labelsize=10, colors=TEXT_PRIMARY)
cbar.outline.set_visible(False)

# --- Title ---
ax.set_title('Asset Correlation Matrix (90-Day)', fontsize=22,
             color=TEXT_PRIMARY, weight='bold', pad=20)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'heatmap_correlation')
```

**Variation notes:**
- Sequential heatmap (all positive): use `mcolors.LinearSegmentedColormap.from_list('keyrock_seq', ['#FFFFFF', PRIMARY_DEFAULT])`
- Time heatmap (hour vs day): reshape data into 24x7 grid, label axes accordingly
- Large matrix (>12x12): omit cell text labels, rely on colour only
- Mask diagonal: `corr[np.diag_indices_from(corr)] = np.nan` and use `ax.imshow` with masked array

---

### 9. Waterfall Chart

**When to use:** Showing how an initial value is affected by sequential positive and negative changes to reach a final total. Revenue bridges, P&L breakdowns, portfolio attribution analysis.

**Recommended dimensions:**
- Standard: `figsize=(12, 6)`
- Compact: `figsize=(10, 5)`

**Colour assignment:**
- Starting/ending totals: `PRIMARY[4]`
- Positive changes: `'#10B981'` (semantic green)
- Negative changes: `'#EF4444'` (semantic red)
- Connector lines: `GRID_COLOR`

**Key styling rules:**
- Floating bars from running total
- Connector lines between bars
- Value labels on each bar
- Y-axis grid

#### Waterfall Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
categories = ['Q4 Revenue', 'New Clients', 'Upsells', 'Churn',
              'Price Increase', 'FX Impact', 'Q1 Revenue']
values = [45.0, 8.2, 3.5, -4.1, 2.8, -1.4, 0]  # Last is calculated
is_total = [True, False, False, False, False, False, True]

# Calculate running total and final value
running = []
cumulative = 0
for i, (val, total) in enumerate(zip(values, is_total)):
    if total and i == 0:
        cumulative = val
        running.append(0)
    elif total:
        values[i] = cumulative  # Set final total
        running.append(0)
    else:
        running.append(cumulative)
        cumulative += val

# --- Figure ---
fig, ax = plt.subplots(figsize=(12, 6), facecolor=BG)
ax.set_facecolor(BG)

# --- Bars ---
bar_colors = []
for i, (val, total) in enumerate(zip(values, is_total)):
    if total:
        bar_colors.append(PRIMARY[4])       # #001FFF — totals
    elif val >= 0:
        bar_colors.append('#10B981')        # Semantic green — positive
    else:
        bar_colors.append('#EF4444')        # Semantic red — negative

bottoms = []
heights = []
for i, (val, total) in enumerate(zip(values, is_total)):
    if total:
        bottoms.append(0)
        heights.append(val)
    else:
        if val >= 0:
            bottoms.append(running[i])
            heights.append(val)
        else:
            bottoms.append(running[i] + val)
            heights.append(abs(val))

bars = ax.bar(categories, heights, bottom=bottoms, width=0.6,
              color=bar_colors, edgecolor='none', zorder=3)

# --- Connector lines ---
for i in range(len(categories) - 1):
    if is_total[i]:
        y_connect = values[i]
    else:
        y_connect = running[i] + values[i]
    ax.plot([i + 0.3, i + 0.7], [y_connect, y_connect],
            color=GRID_COLOR, linewidth=1, zorder=2)

# --- Value labels ---
for i, bar in enumerate(bars):
    val = values[i]
    top = bottoms[i] + heights[i]
    label = f'${abs(val):.1f}M'
    if not is_total[i]:
        label = f'+${val:.1f}M' if val >= 0 else f'-${abs(val):.1f}M'
    ax.text(bar.get_x() + bar.get_width() / 2, top + 0.5,
            label, ha='center', va='bottom',
            fontsize=12, color=TEXT_PRIMARY, weight='bold')

# --- Styling ---
ax.set_title('Revenue Bridge: Q4 2024 to Q1 2025', fontsize=22,
             color=TEXT_PRIMARY, weight='bold', pad=20, loc='center')
ax.set_ylabel('Revenue (USD Millions)', fontsize=12, color=TEXT_PRIMARY, weight='bold')
style_axes(ax)
plt.setp(ax.get_xticklabels(), rotation=30, ha='right')

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'waterfall')
```

**Variation notes:**
- Percentage waterfall: show percentage changes instead of absolute values
- Colour by category instead of direction: use specific colours for specific business drivers
- Add a baseline line: `ax.axhline(y=starting_value, color=TEXT_MUTED, linestyle='--', linewidth=0.8, alpha=0.5)`

---

### 10. Combo Chart

**When to use:** When two related metrics with different scales need to be shown together. Bar + line on dual axes. Examples: volume bars with price line, count bars with percentage line.

**Recommended dimensions:**
- Standard: `figsize=(12, 6)`
- Wide: `figsize=(14, 6)`

**Colour assignment:**
- Bars: `PRIMARY_DEFAULT` (primary metric)
- Line: `PRIMARY[4]` (secondary metric on right axis)
- Clearly differentiate — bars and line should never share a colour

**Key styling rules:**
- Left y-axis for bars, right y-axis for line
- Right y-axis label and ticks match line colour
- Left y-axis label and ticks match bar colour
- Legend distinguishes both series
- Grid from left axis only

#### Combo Chart Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import numpy as np

# --- Data ---
months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
volume = [12.5e9, 14.2e9, 18.1e9, 15.8e9, 13.4e9, 16.7e9,
          19.3e9, 22.1e9, 20.5e9, 17.8e9, 15.2e9, 21.4e9]
price = [42500, 43800, 47200, 45100, 43600, 46800,
         49200, 52100, 50800, 48300, 44900, 51200]

# --- Figure ---
fig, ax1 = plt.subplots(figsize=(12, 6), facecolor=BG)
ax1.set_facecolor(BG)
ax2 = ax1.twinx()

# --- Bars (left axis) ---
bars = ax1.bar(months, volume, width=0.6, color=PRIMARY_DEFAULT, alpha=0.8,
               edgecolor='none', zorder=2, label='Volume')

# --- Line (right axis) ---
line = ax2.plot(months, price, color=PRIMARY[4], linewidth=2.5,
                marker='o', markersize=5, zorder=3, label='BTC Price')

# --- Left axis styling ---
ax1.set_ylabel('24h Volume (USD)', fontsize=12, color=PRIMARY_DEFAULT, weight='bold')
ax1.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: format_number(x)))
ax1.tick_params(axis='y', colors=PRIMARY_DEFAULT, labelsize=10, width=1, length=4)
ax1.tick_params(axis='x', colors=TICK_COLOR, labelsize=10, width=1, length=4)

# --- Right axis styling ---
ax2.set_ylabel('BTC Price (USD)', fontsize=12, color=PRIMARY[4], weight='bold')
ax2.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'${x:,.0f}'))
ax2.tick_params(axis='y', colors=PRIMARY[4], labelsize=10, width=1, length=4)

# --- Spine styling ---
ax1.spines['top'].set_visible(False)
ax2.spines['top'].set_visible(False)
ax1.spines['left'].set_visible(False)
ax1.spines['bottom'].set_color(X_AXIS_COLOR)
ax1.spines['bottom'].set_linewidth(2)
ax2.spines['right'].set_color(PRIMARY[4])
ax2.spines['right'].set_linewidth(2)
ax1.spines['right'].set_visible(False)

# --- Grid (from left axis only) ---
ax1.grid(axis='y', alpha=0.3, linewidth=0.5, zorder=0, color=GRID_COLOR)

# --- Combined legend ---
bars_legend = plt.Rectangle((0, 0), 1, 1, fc=PRIMARY_DEFAULT, alpha=0.8)
from matplotlib.lines import Line2D
line_legend = Line2D([0], [0], color=PRIMARY[4], linewidth=2.5, marker='o', markersize=5)
ax1.legend([bars_legend, line_legend], ['Volume', 'BTC Price'],
           loc='upper left', framealpha=0.8, edgecolor='none', facecolor=BG, fontsize=12, prop={'weight': 'bold'})

# --- Title ---
ax1.set_title('BTC Volume and Price (2024)', fontsize=22,
              color=TEXT_PRIMARY, weight='bold', pad=20, loc='center')

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'combo_chart')
```

**Variation notes:**
- Stacked bars + line: combine stacked bar technique with right-axis line
- Multiple lines on right axis: add more `ax2.plot()` calls
- Bar groups + line: combine grouped bars from template #1 with an overlay line
- Ensure line `zorder` is higher than bars so line draws on top

---

## Diagrams and Special Formats

---

### 11. Timeline / Gantt

**When to use:** Showing events, milestones, or durations along a time axis. Regulatory timelines, project phases, roadmaps. Horizontal bars represent duration; markers show point events.

**Recommended dimensions:**
- Standard: `figsize=(14, 7)`
- Many items: `figsize=(14, 10)` or taller
- Compact: `figsize=(12, 6)`

**Colour assignment:**
- Category-based: assign each category a colour from `CHART_COLORS`
- Status-based: `'#10B981'` (complete), `PRIMARY_DEFAULT` (in progress), `PRIMARY[1]` (planned), `TEXT_MUTED` (deferred)
- Milestones: `ACCENT_ORANGE` diamond markers

**Key styling rules:**
- Horizontal bars along time axis
- Category labels on y-axis
- Clean date formatting on x-axis
- Optional vertical "today" line
- Group related items visually

#### Timeline / Gantt Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import matplotlib.patches as mpatches
from datetime import datetime, timedelta

# --- Data ---
tasks = [
    {'name': 'MiCA Implementation', 'start': '2024-01-01', 'end': '2024-12-30',
     'category': 'EU', 'color': PRIMARY[0]},
    {'name': 'DORA Compliance', 'start': '2024-06-01', 'end': '2025-01-17',
     'category': 'EU', 'color': PRIMARY[0]},
    {'name': 'UK FCA Crypto Rules', 'start': '2024-03-01', 'end': '2024-09-30',
     'category': 'UK', 'color': PRIMARY[1]},
    {'name': 'US Stablecoin Bill', 'start': '2024-04-01', 'end': '2025-03-31',
     'category': 'US', 'color': PRIMARY[2]},
    {'name': 'Basel Crypto Framework', 'start': '2024-01-01', 'end': '2025-06-30',
     'category': 'Global', 'color': SECONDARY[0]},
    {'name': 'HK Licensing Regime', 'start': '2024-02-01', 'end': '2024-08-31',
     'category': 'APAC', 'color': PRIMARY[4]},
    {'name': 'Japan Stablecoin Law', 'start': '2024-06-01', 'end': '2024-12-31',
     'category': 'APAC', 'color': PRIMARY[4]},
]

milestones = [
    {'name': 'MiCA Full Effect', 'date': '2024-12-30', 'category': 'EU'},
    {'name': 'DORA Deadline', 'date': '2025-01-17', 'category': 'EU'},
]

# Parse dates
for t in tasks:
    t['start_dt'] = datetime.strptime(t['start'], '%Y-%m-%d')
    t['end_dt'] = datetime.strptime(t['end'], '%Y-%m-%d')
for m in milestones:
    m['date_dt'] = datetime.strptime(m['date'], '%Y-%m-%d')

# --- Figure ---
fig, ax = plt.subplots(figsize=(14, 7), facecolor=BG)
ax.set_facecolor(BG)

# --- Bars ---
bar_height = 0.6
y_positions = list(range(len(tasks)))
for i, task in enumerate(tasks):
    duration = (task['end_dt'] - task['start_dt']).days
    ax.barh(i, duration, left=task['start_dt'], height=bar_height,
            color=task['color'], alpha=0.85, edgecolor='none', zorder=3)
    # Label inside or beside bar
    mid_date = task['start_dt'] + timedelta(days=duration / 2)
    ax.text(mid_date, i, task['name'], ha='center', va='center',
            fontsize=12, color='white', weight='bold', zorder=4)

# --- Milestones ---
for m in milestones:
    # Find y-position of matching category
    matching = [i for i, t in enumerate(tasks) if t['category'] == m['category']]
    if matching:
        y = matching[0]
        ax.plot(m['date_dt'], y, marker='D', color=ACCENT_ORANGE, markersize=10,
                zorder=5, markeredgecolor=BG, markeredgewidth=1.5)

# --- Today line ---
today = datetime(2025, 1, 15)  # Replace with datetime.now() in production
ax.axvline(x=today, color=ACCENT_ORANGE, linewidth=1.5, linestyle='--', alpha=0.7, zorder=2)
ax.text(today, len(tasks) - 0.5, ' Today', fontsize=12, color=ACCENT_ORANGE,
        va='bottom', weight='bold')

# --- Styling ---
ax.set_yticks(y_positions)
ax.set_yticklabels([t['name'] for t in tasks], fontsize=12, color=TEXT_PRIMARY)
ax.invert_yaxis()
ax.xaxis.set_major_formatter(mdates.DateFormatter('%b %Y'))
ax.xaxis.set_major_locator(mdates.MonthLocator(interval=2))
plt.setp(ax.get_xticklabels(), rotation=45, ha='right')
style_axes(ax, grid_axis='x')

# --- Category legend ---
unique_cats = {}
for t in tasks:
    if t['category'] not in unique_cats:
        unique_cats[t['category']] = t['color']
legend_patches = [mpatches.Patch(color=c, label=cat) for cat, c in unique_cats.items()]
ax.legend(handles=legend_patches, loc='lower right', framealpha=0.8,
          edgecolor='none', facecolor=BG, fontsize=12, ncol=3, prop={'weight': 'bold'})

# --- Title ---
fig.suptitle('Global Crypto Regulatory Timeline', fontsize=22,
             weight='bold', color=TEXT_PRIMARY, y=0.98)
ax.set_title('Key frameworks and compliance deadlines', fontsize=12,
             color=TEXT_PRIMARY, pad=10)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.93])
add_keyrock_logo(fig)
export_chart(fig, 'timeline_gantt')
```

**Variation notes:**
- Milestone-only timeline: use only markers along a horizontal line, no bars
- Grouped rows: add horizontal separators between categories with `ax.axhline()`
- Progress bars: overlay a darker bar at `progress_pct * duration` width
- Vertical timeline: transpose axes, dates on y-axis

---

### 12. Flowchart / Process Flow

**When to use:** Showing sequential steps in a process, decision trees, system architecture, or workflow. Use for explaining tokenisation pipelines, compliance processes, trade execution flows.

**Recommended dimensions:**
- Horizontal flow: `figsize=(14, 6)`
- Vertical flow: `figsize=(8, 12)`
- Complex: `figsize=(14, 10)`

**Colour assignment:**
- Process steps: `PRIMARY_DEFAULT` (fill), white text
- Decision nodes: `PRIMARY[3]` (#DEE2FF pale blue fill), dark text
- Start/end: `PRIMARY[4]` (fill), white text
- Arrows: `TEXT_MUTED`

**Key styling rules:**
- Rounded rectangles for process steps
- Diamonds for decisions (or rounded boxes with "?" prefix)
- Consistent box sizing
- Clear arrow paths with FancyArrowPatch
- Centre-aligned text in boxes

#### Flowchart Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

# --- Data ---
steps = [
    {'id': 0, 'text': 'Client\nOnboarding', 'x': 1, 'y': 5, 'type': 'start'},
    {'id': 1, 'text': 'KYC/AML\nVerification', 'x': 3.5, 'y': 5, 'type': 'process'},
    {'id': 2, 'text': 'Risk\nAssessment', 'x': 6, 'y': 5, 'type': 'decision'},
    {'id': 3, 'text': 'Account\nApproved', 'x': 8.5, 'y': 6.5, 'type': 'process'},
    {'id': 4, 'text': 'Enhanced\nDue Diligence', 'x': 8.5, 'y': 3.5, 'type': 'process'},
    {'id': 5, 'text': 'Trading\nEnabled', 'x': 11, 'y': 5, 'type': 'end'},
]

connections = [
    (0, 1, ''), (1, 2, ''), (2, 3, 'Pass'), (2, 4, 'Flag'),
    (3, 5, ''), (4, 5, 'Cleared'),
]

# Box dimensions
box_w, box_h = 2.0, 1.4

# Colour mapping
type_colors = {
    'start': PRIMARY[4],
    'process': PRIMARY_DEFAULT,
    'decision': PRIMARY[3],
    'end': PRIMARY[4],
}

# --- Figure ---
fig, ax = plt.subplots(figsize=(14, 8), facecolor=BG)
ax.set_facecolor(BG)
ax.set_xlim(-0.5, 13)
ax.set_ylim(1.5, 8)
ax.set_aspect('equal')
ax.axis('off')

# --- Draw boxes ---
for step in steps:
    color = type_colors[step['type']]
    text_color = 'white' if step['type'] != 'decision' else TEXT_PRIMARY
    bbox = FancyBboxPatch(
        (step['x'] - box_w / 2, step['y'] - box_h / 2), box_w, box_h,
        boxstyle='round,pad=0.15', facecolor=color, edgecolor='none',
        zorder=3)
    ax.add_patch(bbox)
    ax.text(step['x'], step['y'], step['text'], ha='center', va='center',
            fontsize=12, color=text_color, weight='bold', zorder=4)

# --- Draw arrows ---
for src_id, dst_id, label in connections:
    src = steps[src_id]
    dst = steps[dst_id]
    # Determine arrow start and end points
    if dst['x'] > src['x']:  # Horizontal right
        start = (src['x'] + box_w / 2, src['y'])
        end = (dst['x'] - box_w / 2, dst['y'])
    elif dst['y'] > src['y']:  # Vertical up
        start = (src['x'], src['y'] + box_h / 2)
        end = (dst['x'], dst['y'] - box_h / 2)
    else:  # Vertical down
        start = (src['x'], src['y'] - box_h / 2)
        end = (dst['x'], dst['y'] + box_h / 2)

    arrow = FancyArrowPatch(
        start, end,
        arrowstyle='->', mutation_scale=20,
        color=TEXT_MUTED, linewidth=2, zorder=2,
        connectionstyle='arc3,rad=0.1' if src['y'] != dst['y'] else 'arc3,rad=0')
    ax.add_patch(arrow)

    # Label on arrow
    if label:
        mid_x = (start[0] + end[0]) / 2
        mid_y = (start[1] + end[1]) / 2
        ax.text(mid_x, mid_y + 0.3, label, ha='center', va='bottom',
                fontsize=12, color=TEXT_PRIMARY,
                bbox=dict(boxstyle='round,pad=0.2', facecolor=BG,
                         edgecolor='none', alpha=0.8))

# --- Title ---
fig.suptitle('Client Onboarding Process', fontsize=22,
             weight='bold', color=TEXT_PRIMARY, y=0.96)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

add_keyrock_logo(fig)
export_chart(fig, 'flowchart')
```

**Variation notes:**
- Vertical flow: swap x/y coordinates, arrange top-to-bottom
- Decision diamonds: use `matplotlib.patches.RegularPolygon` with 4 sides rotated 45 degrees, or just use rounded boxes with amber colour
- Branching: use `connectionstyle='arc3,rad=0.2'` for curved arrows
- Sub-processes: nest boxes within a larger dashed rectangle
- Swim lanes: add horizontal bands with light background colours for different departments

---

### 13. Flywheel / Circular Diagram

**When to use:** Showing cyclical processes, reinforcing loops, virtuous/vicious cycles. Each node feeds into the next in a circle. Good for business model explanations, ecosystem dynamics.

**Recommended dimensions:**
- Standard: `figsize=(10, 10)`
- With annotations: `figsize=(12, 10)`

**Colour assignment:**
- Nodes: cycle through `CHART_COLORS`
- Arrows: `TEXT_MUTED` or lighter version of node colours
- Centre: `BG` with title text

**Key styling rules:**
- Nodes arranged in a circle
- Curved arrows between nodes
- Clean labels inside or beside nodes
- Optional centre label describing the cycle

#### Flywheel Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import numpy as np

# --- Data ---
nodes = [
    'Deeper\nLiquidity',
    'Tighter\nSpreads',
    'More\nTraders',
    'Higher\nVolume',
    'Better\nData',
    'Smarter\nAlgos',
]
center_text = 'Market Making\nFlywheel'
n_nodes = len(nodes)

# --- Layout ---
radius = 3.2
angles = np.linspace(90, 90 - 360, n_nodes, endpoint=False)  # Start at top, clockwise
angles_rad = np.deg2rad(angles)
node_positions = [(radius * np.cos(a), radius * np.sin(a)) for a in angles_rad]

# --- Figure ---
fig, ax = plt.subplots(figsize=(10, 10), facecolor=BG)
ax.set_facecolor(BG)
ax.set_xlim(-5.5, 5.5)
ax.set_ylim(-5.5, 5.5)
ax.set_aspect('equal')
ax.axis('off')

# --- Draw nodes ---
node_w, node_h = 2.0, 1.2
for i, (pos, label) in enumerate(zip(node_positions, nodes)):
    color = CHART_COLORS[i % len(CHART_COLORS)]
    bbox = FancyBboxPatch(
        (pos[0] - node_w / 2, pos[1] - node_h / 2), node_w, node_h,
        boxstyle='round,pad=0.2', facecolor=color, edgecolor='none',
        zorder=3)
    ax.add_patch(bbox)
    ax.text(pos[0], pos[1], label, ha='center', va='center',
            fontsize=12, color='white', weight='bold', zorder=4)

# --- Draw arrows between nodes ---
arrow_radius = radius * 0.85  # Slightly inside the node circle
for i in range(n_nodes):
    j = (i + 1) % n_nodes
    # Arrow from node i to node j, along the circle
    angle_start = angles_rad[i] - np.deg2rad(18)
    angle_end = angles_rad[j] + np.deg2rad(18)
    start = (arrow_radius * np.cos(angle_start), arrow_radius * np.sin(angle_start))
    end = (arrow_radius * np.cos(angle_end), arrow_radius * np.sin(angle_end))

    arrow = FancyArrowPatch(
        start, end,
        arrowstyle='->', mutation_scale=25,
        color=TEXT_MUTED, linewidth=2.5, zorder=2,
        connectionstyle=f'arc3,rad=0.3')
    ax.add_patch(arrow)

# --- Centre label ---
ax.text(0, 0, center_text, ha='center', va='center',
        fontsize=16, color=TEXT_PRIMARY, weight='bold',
        bbox=dict(boxstyle='round,pad=0.5', facecolor=BG,
                 edgecolor=GRID_COLOR, linewidth=1.5))

# --- Title ---
fig.suptitle('The Liquidity Flywheel', fontsize=22,
             weight='bold', color=TEXT_PRIMARY, y=0.96)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

add_keyrock_logo(fig)
export_chart(fig, 'flywheel')
```

**Variation notes:**
- Fewer nodes (3-4): increase node size, wider spacing
- More nodes (7-8): decrease node size, tighter spacing
- Bidirectional arrows: add arrows in both directions between some nodes
- Annotated flywheel: add small text descriptions outside the circle near each arrow
- Nested flywheel: smaller inner circle with secondary cycle

---

### 14. Convergence Diagram

**When to use:** Multiple inputs or trends flowing into a single focal point or outcome. "Several forces creating one result." Good for showing how regulatory, market, and tech trends converge on tokenised assets, etc.

**Recommended dimensions:**
- Standard: `figsize=(14, 8)`
- Vertical: `figsize=(10, 10)`

**Colour assignment:**
- Input streams: each gets a colour from `CHART_COLORS`
- Focal point: `PRIMARY_DEFAULT` or prominent colour
- Arrows/lines: match input stream colours

**Key styling rules:**
- Input boxes arranged in arc or column on left
- Focal point box/circle on right (or centre)
- Curved lines from inputs to focal point
- Fade or gradient effect along lines (optional)

#### Convergence Diagram Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch, Circle
import numpy as np

# --- Data ---
inputs = [
    {'text': 'Regulatory\nClarity', 'desc': 'MiCA, Basel III'},
    {'text': 'Institutional\nDemand', 'desc': 'ETF inflows, custody'},
    {'text': 'Technology\nMaturity', 'desc': 'L2 scaling, interop'},
    {'text': 'Market\nInfrastructure', 'desc': 'Prime brokerage'},
    {'text': 'Talent\nMigration', 'desc': 'TradFi to crypto'},
]
focal_point = 'Institutional\nAdoption'

n_inputs = len(inputs)

# --- Figure ---
fig, ax = plt.subplots(figsize=(14, 8), facecolor=BG)
ax.set_facecolor(BG)
ax.set_xlim(-1, 13)
ax.set_ylim(-1, 9)
ax.set_aspect('equal')
ax.axis('off')

# --- Input positions (left side, vertically distributed) ---
input_x = 1.5
y_positions = np.linspace(7.5, 0.5, n_inputs)
box_w, box_h = 2.4, 1.2

for i, (inp, y) in enumerate(zip(inputs, y_positions)):
    color = CHART_COLORS[i]
    # Box
    bbox = FancyBboxPatch(
        (input_x - box_w / 2, y - box_h / 2), box_w, box_h,
        boxstyle='round,pad=0.15', facecolor=color, edgecolor='none', zorder=3)
    ax.add_patch(bbox)
    ax.text(input_x, y, inp['text'], ha='center', va='center',
            fontsize=12, color='white', weight='bold', zorder=4)
    # Description below box
    ax.text(input_x, y - box_h / 2 - 0.25, inp['desc'],
            ha='center', va='top', fontsize=12, color=TEXT_MUTED)

# --- Focal point (right side) ---
focal_x, focal_y = 10.5, 4.0
focal_r = 1.5
circle = Circle((focal_x, focal_y), focal_r, facecolor=PRIMARY_DEFAULT,
                edgecolor='none', zorder=3, alpha=0.9)
ax.add_patch(circle)
# Outer glow ring
circle_glow = Circle((focal_x, focal_y), focal_r + 0.2, facecolor='none',
                      edgecolor=PRIMARY_DEFAULT, linewidth=2, zorder=2, alpha=0.3)
ax.add_patch(circle_glow)
ax.text(focal_x, focal_y, focal_point, ha='center', va='center',
        fontsize=14, color='white', weight='bold', zorder=4)

# --- Arrows from inputs to focal point ---
for i, y in enumerate(y_positions):
    start = (input_x + box_w / 2, y)
    end = (focal_x - focal_r - 0.1, focal_y + (y - focal_y) * 0.2)
    arrow = FancyArrowPatch(
        start, end,
        arrowstyle='->', mutation_scale=20,
        color=CHART_COLORS[i], linewidth=2.5, alpha=0.7, zorder=2,
        connectionstyle='arc3,rad=0.15')
    ax.add_patch(arrow)

# --- Title ---
fig.suptitle('Forces Converging on Institutional Crypto Adoption', fontsize=22,
             weight='bold', color=TEXT_PRIMARY, y=0.96)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

add_keyrock_logo(fig)
export_chart(fig, 'convergence_diagram')
```

**Variation notes:**
- Radial convergence: inputs arranged in a circle, focal point at centre
- Divergence diagram: reverse — one source expanding to multiple outcomes
- Two-stage convergence: inputs converge to intermediate nodes, which converge to final focal point
- Add icons: use Unicode symbols or matplotlib markers inside input boxes

---

### 15. Scorecard / Table

**When to use:** Structured data display with colour-coded status indicators. Comparison of entities across multiple criteria. Compliance checklists, feature matrices, risk assessments.

**Recommended dimensions:**
- Standard: `figsize=(12, 6)` — adjust height based on row count
- Wide: `figsize=(14, 8)`
- Rule of thumb: `height = 1 + 0.6 * n_rows`

**Colour assignment:**
- Status indicators: `'#10B981'` (pass/good), `ACCENT_ORANGE` (warning/partial), `'#EF4444'` (fail/poor)
- Header row: `PRIMARY_DEFAULT` background, white text
- Alternating row backgrounds: `BG` and slightly tinted `BG`

**Key styling rules:**
- No matplotlib axes — use `ax.table()` or manual text placement
- Clean cell borders or no borders
- Consistent column alignment
- Header row visually distinct

#### Scorecard Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch

# --- Data ---
headers = ['Exchange', 'Liquidity', 'Regulation', 'Security', 'Fee Tier', 'Overall']
rows = [
    ['Binance',   'High',   'Partial', 'Strong', 'Low',    'A'],
    ['Coinbase',  'High',   'Full',    'Strong', 'Medium', 'A'],
    ['OKX',       'Medium', 'Partial', 'Medium', 'Low',    'B+'],
    ['Kraken',    'Medium', 'Full',    'Strong', 'Medium', 'A-'],
    ['Bybit',     'Medium', 'Partial', 'Medium', 'Low',    'B'],
    ['KuCoin',    'Low',    'Minimal', 'Medium', 'Low',    'C+'],
]

# Status colour mapping
status_colors = {
    'High': '#10B981', 'Full': '#10B981', 'Strong': '#10B981', 'Low': '#10B981', 'A': '#10B981', 'A-': '#10B981',
    'Medium': ACCENT_ORANGE, 'Partial': ACCENT_ORANGE, 'B+': ACCENT_ORANGE, 'B': ACCENT_ORANGE,
    'Low': ACCENT_ORANGE, 'Minimal': '#EF4444', 'C+': '#EF4444', 'C': '#EF4444',
}
# Override 'Low' context-specifically
fee_colors = {'Low': '#10B981', 'Medium': ACCENT_ORANGE, 'High': '#EF4444'}

n_cols = len(headers)
n_rows = len(rows)
col_widths = [1.8, 1.2, 1.2, 1.2, 1.2, 1.0]
total_w = sum(col_widths)
row_h = 0.6

# --- Figure ---
fig_h = 2 + (n_rows + 1) * row_h
fig, ax = plt.subplots(figsize=(12, fig_h), facecolor=BG)
ax.set_facecolor(BG)
ax.set_xlim(0, total_w + 1)
ax.set_ylim(0, (n_rows + 2) * row_h + 1)
ax.axis('off')

# Starting position
start_x = 0.5
start_y = (n_rows + 1) * row_h + 0.5

# --- Header row ---
x_pos = start_x
for j, (header, w) in enumerate(zip(headers, col_widths)):
    rect = FancyBboxPatch((x_pos, start_y), w - 0.05, row_h,
                           boxstyle='round,pad=0.05', facecolor=PRIMARY_DEFAULT,
                           edgecolor='none', zorder=2)
    ax.add_patch(rect)
    ax.text(x_pos + w / 2, start_y + row_h / 2, header,
            ha='center', va='center', fontsize=12, color='white',
            weight='bold', zorder=3)
    x_pos += w

# --- Data rows ---
for i, row in enumerate(rows):
    y = start_y - (i + 1) * row_h
    row_bg = BG if i % 2 == 0 else (GRID_COLOR if BG == '#FFFFFF' else '#0F2035')
    x_pos = start_x
    for j, (cell, w) in enumerate(zip(row, col_widths)):
        rect = FancyBboxPatch((x_pos, y), w - 0.05, row_h,
                               boxstyle='round,pad=0.05', facecolor=row_bg,
                               edgecolor='none', zorder=1)
        ax.add_patch(rect)
        # Determine text colour and optional status dot
        text_color = TEXT_PRIMARY
        if j > 0 and j < n_cols:  # Status columns
            if j == 4:  # Fee column (Low is good)
                dot_color = fee_colors.get(cell, TEXT_MUTED)
            else:
                dot_color = status_colors.get(cell, TEXT_MUTED)
            # Status dot
            ax.plot(x_pos + 0.25, y + row_h / 2, 'o', color=dot_color,
                    markersize=6, zorder=3)
            ax.text(x_pos + w / 2 + 0.1, y + row_h / 2, cell,
                    ha='center', va='center', fontsize=12,
                    color=TEXT_PRIMARY, zorder=3)
        else:
            align = 'left' if j == 0 else 'center'
            offset = 0.15 if j == 0 else 0
            ax.text(x_pos + offset + w / 2 * (0 if j == 0 else 1),
                    y + row_h / 2, cell,
                    ha=align, va='center', fontsize=12,
                    color=TEXT_PRIMARY, weight='bold' if j == 0 else 'normal',
                    zorder=3)
        x_pos += w

# --- Title ---
fig.suptitle('Exchange Scorecard', fontsize=22, weight='bold',
             color=TEXT_PRIMARY, y=0.97)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.93])
add_keyrock_logo(fig)
export_chart(fig, 'scorecard')
```

**Variation notes:**
- Checkbox style: replace status dots with unicode checkmarks/crosses
- Progress bars in cells: draw small horizontal bars proportional to value
- Sortable by column: pre-sort data before rendering
- Wider tables: reduce font size or use horizontal scrolling metaphor with ellipsis

---

### 16. KPI / Metric Cards

**When to use:** Dashboard-style callout for key numbers. Headline metrics, performance summaries. 2-6 large numbers displayed prominently with labels and trend indicators.

**Recommended dimensions:**
- 3 cards in row: `figsize=(14, 4)`
- 4 cards: `figsize=(14, 4)`
- 2 rows of 3: `figsize=(14, 7)`

**Colour assignment:**
- Card background: slightly tinted BG (light: `#F8FAFB`, dark: `#0F2035`)
- Metric value: `TEXT_PRIMARY`
- Trend up: `'#10B981'` (inline green)
- Trend down: `'#EF4444'` (inline red)
- Neutral: `TEXT_MUTED`
- Accent border on left: matches metric category colour from `CHART_COLORS`

**Key styling rules:**
- Large numbers (fontsize 28-36)
- Subtitle/label below (fontsize 11)
- Trend indicator with arrow and percentage
- Cards evenly spaced
- Optional sparkline under each metric

#### KPI Cards Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Rectangle

# --- Data ---
metrics = [
    {'label': 'Total Volume (24h)', 'value': '$142.3B',
     'change': '+12.4%', 'trend': 'up', 'color': PRIMARY_DEFAULT},
    {'label': 'Active Markets', 'value': '2,847',
     'change': '+89', 'trend': 'up', 'color': PRIMARY[1]},
    {'label': 'Avg Spread (BPS)', 'value': '3.2',
     'change': '-0.8', 'trend': 'up', 'color': PRIMARY[2]},  # Lower spread is good
    {'label': 'Fill Rate', 'value': '94.7%',
     'change': '-1.2%', 'trend': 'down', 'color': PRIMARY[4]},
]

n_cards = len(metrics)

# --- Figure ---
fig, axes = plt.subplots(1, n_cards, figsize=(14, 4), facecolor=BG)
fig.subplots_adjust(wspace=0.3)

card_bg = '#F8FAFB' if BG == '#FFFFFF' else '#0F2035'

for i, (ax, metric) in enumerate(zip(axes, metrics)):
    ax.set_facecolor(BG)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 10)
    ax.axis('off')

    # Card background
    card = FancyBboxPatch((0.3, 0.5), 9.4, 9,
                           boxstyle='round,pad=0.3', facecolor=card_bg,
                           edgecolor=GRID_COLOR, linewidth=0.5, zorder=1)
    ax.add_patch(card)

    # Accent bar on left
    accent = Rectangle((0.3, 0.5), 0.25, 9,
                        facecolor=metric['color'], edgecolor='none', zorder=2)
    ax.add_patch(accent)

    # Label
    ax.text(5.2, 7.5, metric['label'], ha='center', va='center',
            fontsize=12, color=TEXT_MUTED, zorder=3)

    # Value (large)
    ax.text(5.2, 5.0, metric['value'], ha='center', va='center',
            fontsize=30, color=TEXT_PRIMARY, weight='bold', zorder=3)

    # Trend indicator
    trend_color = '#10B981' if metric['trend'] == 'up' else '#EF4444'
    arrow = '\u25B2' if metric['trend'] == 'up' else '\u25BC'  # Unicode triangles
    ax.text(5.2, 2.5, f'{arrow} {metric["change"]}', ha='center', va='center',
            fontsize=12, color=trend_color, weight='bold', zorder=3)

# --- Title ---
fig.suptitle('Market Making Dashboard', fontsize=22, weight='bold',
             color=TEXT_PRIMARY, y=1.02)

# --- Source ---
fig.text(0.01, -0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.02, 1, 0.95])
add_keyrock_logo(fig)
export_chart(fig, 'kpi_cards')
```

**Variation notes:**
- With sparklines: add a small `ax.plot()` below each metric value using a secondary axes
- 2-row layout: use `plt.subplots(2, 3, ...)`
- Comparison cards: show "Current" vs "Previous" with delta
- Status colour background: tint entire card background based on status

---

### 17. Comparison Table

**When to use:** Side-by-side comparison of 2-4 items across multiple attributes. Product comparisons, feature matrices, service tier comparisons. More visual than a plain scorecard.

**Recommended dimensions:**
- 2 items: `figsize=(10, 8)`
- 3 items: `figsize=(12, 8)`
- 4 items: `figsize=(14, 8)`
- Adjust height based on number of attributes

**Colour assignment:**
- Column headers: each item gets a colour from `CHART_COLORS`
- Checkmarks/present: `'#10B981'` (inline green)
- Crosses/absent: `'#EF4444'` (inline red)
- Partial: `ACCENT_ORANGE`
- Attribute labels: `TEXT_PRIMARY`

**Key styling rules:**
- Column per item, rows per attribute
- Visual indicators (checkmarks, bars, stars) rather than plain text where possible
- Header row with item names in their colours
- Alternating row shading

#### Comparison Table Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch

# --- Data ---
items = ['Keyrock', 'Competitor A', 'Competitor B']
item_colors = [PRIMARY[0], PRIMARY[4], SECONDARY[0]]
attributes = [
    'Deep Liquidity',
    '24/7 Coverage',
    'Multi-Exchange',
    'Custom Pairs',
    'Regulatory License',
    'Transparent Reporting',
    'API Integration',
    'Dedicated Support',
]
# Values: True (check), False (cross), 'Partial' (dash)
data = [
    [True,  True,     True],       # Deep Liquidity
    [True,  True,     False],      # 24/7 Coverage
    [True,  'Partial', True],      # Multi-Exchange
    [True,  False,    'Partial'],  # Custom Pairs
    [True,  True,     False],      # Regulatory License
    [True,  False,    False],      # Transparent Reporting
    [True,  True,     True],       # API Integration
    [True,  'Partial', True],      # Dedicated Support
]

n_items = len(items)
n_attrs = len(attributes)
col_w = 2.5
attr_col_w = 3.0
row_h = 0.7
total_w = attr_col_w + n_items * col_w

# --- Figure ---
fig_h = 2.5 + (n_attrs + 1) * row_h
fig, ax = plt.subplots(figsize=(12, fig_h), facecolor=BG)
ax.set_facecolor(BG)
ax.set_xlim(0, total_w + 0.5)
ax.set_ylim(0, (n_attrs + 2) * row_h + 0.5)
ax.axis('off')

start_x = 0.25
start_y = (n_attrs + 1) * row_h

# --- Header row ---
# Attribute column header
ax.text(start_x + attr_col_w / 2, start_y + row_h / 2, 'Feature',
        ha='center', va='center', fontsize=12, color=TEXT_MUTED, weight='bold')

for j, (item, color) in enumerate(zip(items, item_colors)):
    x = start_x + attr_col_w + j * col_w
    rect = FancyBboxPatch((x, start_y), col_w - 0.1, row_h,
                           boxstyle='round,pad=0.05', facecolor=color,
                           edgecolor='none', zorder=2)
    ax.add_patch(rect)
    ax.text(x + col_w / 2, start_y + row_h / 2, item,
            ha='center', va='center', fontsize=12, color='white',
            weight='bold', zorder=3)

# --- Data rows ---
for i, (attr, row) in enumerate(zip(attributes, data)):
    y = start_y - (i + 1) * row_h
    row_bg = BG if i % 2 == 0 else (GRID_COLOR if BG == '#FFFFFF' else '#0F2035')

    # Row background
    rect = FancyBboxPatch((start_x, y), total_w - 0.1, row_h,
                           boxstyle='round,pad=0.02', facecolor=row_bg,
                           edgecolor='none', zorder=0)
    ax.add_patch(rect)

    # Attribute label
    ax.text(start_x + 0.2, y + row_h / 2, attr,
            ha='left', va='center', fontsize=12, color=TEXT_PRIMARY, zorder=1)

    # Values
    for j, val in enumerate(row):
        x = start_x + attr_col_w + j * col_w + col_w / 2
        if val is True:
            ax.text(x, y + row_h / 2, '\u2713', ha='center', va='center',
                    fontsize=16, color='#10B981', weight='bold', zorder=1)
        elif val is False:
            ax.text(x, y + row_h / 2, '\u2717', ha='center', va='center',
                    fontsize=16, color='#EF4444', weight='bold', zorder=1)
        else:
            ax.text(x, y + row_h / 2, '\u2014', ha='center', va='center',
                    fontsize=16, color=ACCENT_ORANGE, weight='bold', zorder=1)

# --- Title ---
fig.suptitle('Market Maker Comparison', fontsize=22, weight='bold',
             color=TEXT_PRIMARY, y=0.97)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.93])
add_keyrock_logo(fig)
export_chart(fig, 'comparison_table')
```

**Variation notes:**
- Star ratings: use filled/empty star unicode characters
- Progress bars: draw small horizontal bars in cells for numeric comparisons
- Highlight winner: bold or outline the winning column
- Pricing tier tables: add a price row at top with font size emphasis

---

### 18. Treemap

**When to use:** Hierarchical data where you need to show proportional size relationships. Market cap distribution, portfolio weighting, sector breakdown. Each rectangle's area is proportional to its value.

**Recommended dimensions:**
- Standard: `figsize=(12, 8)`
- Wide: `figsize=(14, 8)`

**Colour assignment:**
- Cycle through `CHART_COLORS` by top-level category
- Sub-categories: lighter/darker variants of parent colour
- Or: colour by performance metric (green/red for returns)

**Key styling rules:**
- Labels inside rectangles (only if rectangle is large enough)
- Value and percentage on second line
- Thin white/BG border between rectangles
- No axes

#### Treemap Template

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import squarify  # pip install squarify

# --- Data ---
labels = ['BTC', 'ETH', 'USDT', 'BNB', 'SOL', 'XRP', 'USDC', 'ADA', 'AVAX', 'DOT', 'Other']
values = [850, 380, 120, 85, 72, 65, 45, 35, 28, 22, 98]
total = sum(values)
percentages = [v / total * 100 for v in values]

# Assign colours
colors = []
for i in range(len(labels)):
    colors.append(CHART_COLORS[i % len(CHART_COLORS)])

# --- Figure ---
fig, ax = plt.subplots(figsize=(12, 8), facecolor=BG)
ax.set_facecolor(BG)

# --- Treemap ---
normed = squarify.normalize_sizes(values, 12, 8)
rects = squarify.squarify(normed, 0, 0, 12, 8)

for i, (r, label, val, pct, color) in enumerate(zip(rects, labels, values, percentages, colors)):
    rect = plt.Rectangle((r['x'], r['y']), r['dx'], r['dy'],
                          facecolor=color, edgecolor=BG, linewidth=2, zorder=2)
    ax.add_patch(rect)

    # Only label if rectangle is large enough
    if r['dx'] > 1.2 and r['dy'] > 0.8:
        # Label
        ax.text(r['x'] + r['dx'] / 2, r['y'] + r['dy'] / 2 + 0.15,
                label, ha='center', va='center',
                fontsize=12, color='white', weight='bold', zorder=3)
        # Value
        ax.text(r['x'] + r['dx'] / 2, r['y'] + r['dy'] / 2 - 0.3,
                f'${val}B ({pct:.1f}%)', ha='center', va='center',
                fontsize=12, color='white', alpha=0.85, zorder=3)

ax.set_xlim(0, 12)
ax.set_ylim(0, 8)
ax.axis('off')

# --- Title ---
fig.suptitle('Crypto Market Cap Distribution', fontsize=22, weight='bold',
             color=TEXT_PRIMARY, y=0.97)
ax.set_title('Total Market Cap: $1.8T', fontsize=12, color=TEXT_PRIMARY, pad=10)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

plt.tight_layout(rect=[0, 0.05, 1, 0.93])
add_keyrock_logo(fig)
export_chart(fig, 'treemap')
```

**Variation notes:**
- Without squarify: manually compute rectangle positions for simple cases
- Nested treemap: group by category first, then sub-divide — use lighter shades for children
- Colour by metric: map a continuous metric (e.g., 7-day return) to a diverging colormap
- Interactivity note: for interactive treemaps, consider plotly instead

---

### 19. Sankey Diagram

**When to use:** Showing flow quantities between stages or categories. Capital flows, trade routing, user conversion funnels. Width of each flow is proportional to quantity.

**Recommended dimensions:**
- Standard: `figsize=(14, 8)`
- Complex: `figsize=(16, 10)`

**Colour assignment:**
- Flows: inherit colour from source node with `alpha=0.4`
- Nodes: cycle through `CHART_COLORS`
- Or: all flows in `PRIMARY_DEFAULT` with varying alpha

**Key styling rules:**
- Nodes as vertical bars on left and right (or multiple stages)
- Flows as curved bands between nodes
- Labels beside nodes with values
- Clean, uncluttered layout

> **Note:** Complex Sankey diagrams are better served by `plotly.graph_objects.Sankey`. The template below uses pure matplotlib with manual Bezier curves for simpler flows. For production use with many flows, consider plotly.

#### Sankey Diagram Template (matplotlib)

```python
# Assumes brand setup from brand-system.md
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.path import Path
import matplotlib.patches as patches_mod
import numpy as np

# --- Data ---
# Source nodes -> Destination nodes with flow values
sources = ['CEX Spot', 'CEX Deriv', 'DEX', 'OTC']
source_values = [45, 30, 15, 10]  # Billions

destinations = ['Market Making', 'Arb/HFT', 'Retail', 'Institutional']
# Flow matrix: source_values distributed to destinations
flows = [
    # MM,  Arb,  Retail, Inst
    [15,   12,   10,     8],    # CEX Spot
    [10,   15,   2,      3],    # CEX Deriv
    [5,    5,    4,      1],    # DEX
    [2,    0,    0,      8],    # OTC
]

# --- Layout ---
left_x = 2
right_x = 12
total_height = 16
node_gap = 0.5

# Calculate node positions
def calc_node_positions(values, x, total_h, gap):
    total_val = sum(values)
    usable_h = total_h - gap * (len(values) - 1)
    positions = []
    y = total_h
    for val in values:
        h = (val / total_val) * usable_h
        positions.append({'x': x, 'y_top': y, 'y_bot': y - h, 'h': h, 'val': val})
        y -= h + gap
    return positions

src_pos = calc_node_positions(source_values, left_x, total_height, node_gap)
dst_values = [sum(flows[i][j] for i in range(len(sources))) for j in range(len(destinations))]
dst_pos = calc_node_positions(dst_values, right_x, total_height, node_gap)

# --- Figure ---
fig, ax = plt.subplots(figsize=(14, 8), facecolor=BG)
ax.set_facecolor(BG)
ax.set_xlim(0, 14)
ax.set_ylim(-1, total_height + 1)
ax.axis('off')

# --- Draw flows (Bezier curves) ---
node_width = 0.3
src_cursors = [p['y_top'] for p in src_pos]
dst_cursors = [p['y_top'] for p in dst_pos]

for i in range(len(sources)):
    for j in range(len(destinations)):
        flow_val = flows[i][j]
        if flow_val == 0:
            continue

        # Calculate proportional heights
        src_total = source_values[i]
        dst_total = dst_values[j]
        src_h = (flow_val / src_total) * src_pos[i]['h']
        dst_h = (flow_val / dst_total) * dst_pos[j]['h']

        # Source coordinates
        sy_top = src_cursors[i]
        sy_bot = sy_top - src_h
        src_cursors[i] = sy_bot

        # Destination coordinates
        dy_top = dst_cursors[j]
        dy_bot = dy_top - dst_h
        dst_cursors[j] = dy_bot

        # Bezier path
        sx = left_x + node_width
        dx = right_x
        mid = (sx + dx) / 2

        verts = [
            (sx, sy_top), (mid, sy_top), (mid, dy_top), (dx, dy_top),
            (dx, dy_bot), (mid, dy_bot), (mid, sy_bot), (sx, sy_bot),
            (sx, sy_top),
        ]
        codes = [
            Path.MOVETO, Path.CURVE4, Path.CURVE4, Path.CURVE4,
            Path.LINETO, Path.CURVE4, Path.CURVE4, Path.CURVE4,
            Path.CLOSEPOLY,
        ]
        path = Path(verts, codes)
        patch = patches_mod.PathPatch(
            path, facecolor=CHART_COLORS[i], alpha=0.35,
            edgecolor='none', zorder=1)
        ax.add_patch(patch)

# --- Draw source nodes ---
for i, (pos, label, val) in enumerate(zip(src_pos, sources, source_values)):
    rect = plt.Rectangle((pos['x'], pos['y_bot']), node_width, pos['h'],
                          facecolor=CHART_COLORS[i], edgecolor='none', zorder=2)
    ax.add_patch(rect)
    ax.text(pos['x'] - 0.2, (pos['y_top'] + pos['y_bot']) / 2,
            f'{label}\n${val}B', ha='right', va='center',
            fontsize=12, color=TEXT_PRIMARY, weight='bold')

# --- Draw destination nodes ---
for j, (pos, label, val) in enumerate(zip(dst_pos, destinations, dst_values)):
    rect = plt.Rectangle((pos['x'], pos['y_bot']), node_width, pos['h'],
                          facecolor=CHART_COLORS[j], edgecolor='none', zorder=2)
    ax.add_patch(rect)
    ax.text(pos['x'] + node_width + 0.2, (pos['y_top'] + pos['y_bot']) / 2,
            f'{label}\n${val}B', ha='left', va='center',
            fontsize=12, color=TEXT_PRIMARY, weight='bold')

# --- Title ---
fig.suptitle('Trading Volume Flow: Source to Strategy', fontsize=22,
             weight='bold', color=TEXT_PRIMARY, y=0.97)

# --- Source ---
fig.text(0.01, 0.02, 'Source: Keyrock Research', fontsize=10, color=TEXT_MUTED)

add_keyrock_logo(fig)
export_chart(fig, 'sankey_diagram')
```

**Variation notes:**
- Plotly alternative: for complex multi-stage Sankeys, use `plotly.graph_objects.Sankey` with the same colour palette
- Multiple stages: add intermediate node columns — requires more careful cursor tracking
- Colour by destination: colour all flows going to the same destination with that destination's colour
- Highlight specific flow: set one flow to full opacity (`alpha=0.7`) and dim others (`alpha=0.15`)

---

## Quick Reference: Chart Type Selection

| Scenario | Recommended Chart |
|----------|------------------|
| Compare categories | Vertical Bar (#1) |
| Rank items | Horizontal Bar (#2) |
| Show composition | Stacked Bar (#3) |
| Trend over time | Line Chart (#4) |
| Cumulative composition over time | Area Chart (#5) |
| Two-variable relationship | Scatter Plot (#6) |
| Parts of a whole (2-5 items) | Donut (#7) |
| Matrix relationships | Heatmap (#8) |
| Sequential changes to total | Waterfall (#9) |
| Two metrics, different scales | Combo Chart (#10) |
| Project/regulation timeline | Timeline/Gantt (#11) |
| Process steps | Flowchart (#12) |
| Cyclical process | Flywheel (#13) |
| Multiple forces, one outcome | Convergence (#14) |
| Multi-criteria assessment | Scorecard (#15) |
| Headline metrics | KPI Cards (#16) |
| Feature comparison | Comparison Table (#17) |
| Hierarchical proportions | Treemap (#18) |
| Flow between stages | Sankey (#19) |

---

## Dependencies

Most templates use only `matplotlib` and `numpy` (standard). Special chart types require:

| Chart Type | Extra Package | Install |
|-----------|--------------|---------|
| Treemap (#18) | `squarify` | `pip install squarify` |
| Sankey (alt) | `plotly` | `pip install plotly` (optional, for complex Sankeys) |

---

## Checklist: Before Exporting Any Chart

1. Background colour set on both `fig` and `ax` (`facecolor=BG`)
2. Top, right, and left spines removed; bottom spine visible (2px, `X_AXIS_COLOR`)
3. Grid is subtle (`alpha=0.3`, `linewidth=0.5`)
4. Both X and Y axis tick/label colours use `TICK_COLOR` (`#9B9B9B`)
5. Title uses `TEXT_PRIMARY`, `weight='bold'`, `fontsize=22-20`
6. Source line present at bottom left
7. `add_keyrock_logo(fig)` called
8. `export_chart(fig, name)` called
9. `tight_layout` with rect to leave room for source line and logo
10. All colours come from the brand palette — no hardcoded colours outside the system
