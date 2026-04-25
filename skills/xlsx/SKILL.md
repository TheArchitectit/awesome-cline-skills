---
name: xlsx
description: Comprehensive spreadsheet creation, editing, and analysis with support for formulas, formatting, data analysis, and visualization. This skill should be used when Cline needs to work with spreadsheets (.xlsx, .xlsm, .csv, .tsv) for creating new spreadsheets with formulas and formatting, reading or analyzing data, modifying existing spreadsheets while preserving formulas, or performing data analysis and visualization in spreadsheets.
---

# XLSX Creation, Editing, and Analysis

## Overview

This skill enables Cline to create, edit, and analyze Excel spreadsheets using Python libraries. Different workflows are available depending on the task: **pandas** for data analysis and bulk operations, **openpyxl** for formulas, formatting, and Excel-specific features.

## When to Use This Skill

- Creating new spreadsheets with formulas, charts, and formatting
- Reading or analyzing data from existing Excel files
- Modifying spreadsheets while preserving formulas and formatting
- Building financial models with proper conventions
- Data transformation and visualization in spreadsheet format
- Converting data between formats (CSV, TSV → XLSX)

## Workflow Decision Tree

### Reading/Analyzing Data
Use **pandas** for quick data analysis or **openpyxl** with `data_only=True` for calculated values.

### Creating New Spreadsheet
Use **openpyxl** for formula and formatting support.

### Editing Existing Spreadsheet
Use **openpyxl** to load, modify, and save while preserving structure.

### Data Analysis & Visualization
Use **pandas** for analysis, then **openpyxl** for formatted output.

## Reading and Analyzing Data

### Quick Data Analysis with pandas

```python
import pandas as pd

df = pd.read_excel('file.xlsx')  # Default: first sheet
all_sheets = pd.read_excel('file.xlsx', sheet_name=None)  # All sheets

df.head()      # Preview data
df.info()      # Column info
df.describe()  # Statistics
```

### Reading with openpyxl

```python
from openpyxl import load_workbook

wb = load_workbook('file.xlsx', data_only=True)  # Read calculated values
wb = load_workbook('file.xlsx')  # Read formulas (default)

for sheet_name in wb.sheetnames:
    sheet = wb[sheet_name]
    for row in sheet.iter_rows(values_only=True):
        print(row)
```

## Creating New Spreadsheets

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

wb = Workbook()
sheet = wb.active
sheet.title = "Summary"

# Add headers
headers = ['Item', 'Q1', 'Q2', 'Q3', 'Q4', 'Total']
for col, header in enumerate(headers, 1):
    cell = sheet.cell(row=1, column=col, value=header)
    cell.font = Font(bold=True)

# Add data and formulas
data = [['Revenue', 100, 120, 130, 150], ['Expenses', 80, 85, 90, 95]]
for row_idx, row_data in enumerate(data, 2):
    for col_idx, value in enumerate(row_data, 1):
        sheet.cell(row=row_idx, column=col_idx, value=value)
    # Formula for total using SUM
    sheet.cell(row=row_idx, column=6, value=f'=SUM(B{row_idx}:E{row_idx})')

# Formatting
sheet.column_dimensions['A'].width = 20
for col in 'BCDEF':
    sheet.column_dimensions[col].width = 12

wb.save('report.xlsx')
```

## Editing Existing Spreadsheets

```python
from openpyxl import load_workbook

wb = load_workbook('existing.xlsx')
sheet = wb.active

# Modify cells
sheet['A1'] = 'Updated Header'

# Insert rows/columns
sheet.insert_rows(2)
sheet.delete_cols(3)

# Add new sheet
new_sheet = wb.create_sheet('Analysis')
new_sheet['A1'] = 'New Data'

wb.save('modified.xlsx')
```

### ⚠️ Warning: data_only=True
If you open a file with `data_only=True` and save it, **formulas are permanently replaced with their calculated values**. Only use `data_only=True` for reading.

## CRITICAL: Use Formulas, Not Hardcoded Values

Always use Excel formulas instead of calculating values in Python and hardcoding them.

### ❌ WRONG — Hardcoding
```python
total = df['Sales'].sum()
sheet['B10'] = total  # Hardcodes 5000
```

### ✅ CORRECT — Excel Formula
```python
sheet['B10'] = '=SUM(B2:B9)'  # Dynamic, recalculates
```

## Financial Model Standards

### Color Coding Conventions

| Color | RGB | Usage |
|-------|-----|-------|
| Blue text | (0,0,255) | Hardcoded inputs, assumptions |
| Black text | (0,0,0) | All formulas and calculations |
| Green text | (0,128,0) | Cross-sheet links within workbook |
| Red text | (255,0,0) | External links to other files |
| Yellow background | (255,255,0) | Key assumptions needing attention |

### Number Formatting

- **Years**: Format as text strings ("2024" not 2,024)
- **Currency**: `$#,##0` with units in headers ("Revenue ($mm)")
- **Zeros**: Display as "-" using number formatting
- **Percentages**: Default 0.0% format
- **Multiples**: 0.0x format (EV/EBITDA, P/E)
- **Negatives**: Parentheses (123) not minus -123

### Formula Construction

- Place ALL assumptions in separate cells (growth rates, margins, multiples)
- Use cell references, not hardcoded values: `=B5*(1+$B$6)` not `=B5*1.05`
- Document hardcoded values with comments: "Source: Company 10-K, FY2024, Page 45"

## Adding Charts

```python
from openpyxl.chart import BarChart, Reference

chart = BarChart()
chart.title = "Quarterly Revenue"
chart.type = "col"

data = Reference(sheet, min_col=2, min_row=1, max_col=5, max_row=3)
cats = Reference(sheet, min_col=1, min_row=2, max_row=3)
chart.add_data(data, titles_from_data=True)
chart.set_categories(cats)

sheet.add_chart(chart, "A8")
```

## Data Transforms with pandas

```python
import pandas as pd

# Pivot table
df = pd.read_excel('raw_data.xlsx')
pivot = df.pivot_table(values='Revenue', index='Region', columns='Quarter', aggfunc='sum')
pivot.to_excel('pivot_output.xlsx')

# Merge multiple sheets
sheets = pd.read_excel('multi.xlsx', sheet_name=None)
combined = pd.concat(sheets.values(), ignore_index=True)
combined.to_excel('combined.xlsx', index=False)

# Filter and export
filtered = df[df['Status'] == 'Active'][['Name', 'Email', 'Revenue']]
filtered.to_excel('active_clients.xlsx', index=False)
```

## Formula Verification Checklist

Before delivering any spreadsheet:

- [ ] Test 2-3 sample formula references for correct values
- [ ] Verify column mapping (column 64 = BL, not BK)
- [ ] Remember row offset: DataFrame row 5 = Excel row 6 (1-indexed)
- [ ] Check for NaN with `pd.notna()` before writing
- [ ] Prevent division by zero in formulas
- [ ] Verify all cell references point to intended cells
- [ ] Use `Sheet1!A1` format for cross-sheet references
- [ ] Test with edge cases (zero, negative, very large values)

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/xlsx/` (project-level) or `~/.cline/skills/xlsx/` (global)
2. **Library selection**: Default to **pandas** for data tasks, **openpyxl** for formatting/formulas
3. **Always use formulas**: Never hardcode calculated values — the spreadsheet must remain dynamic
4. **Verify before delivery**: Run formula checks and validate data types
5. **Preserve existing work**: When editing, study existing conventions before modifying
6. **Recalculate after changes**: If LibreOffice is available, use it to recalculate formula values after openpyxl edits
7. **Large files**: Use `read_only=True` for reading large files, `write_only=True` for creating them

## Code Style

- Write concise, minimal Python code
- Avoid verbose variable names and redundant operations
- Avoid unnecessary print statements
- Use context managers (`with` statements) for file operations

## Dependencies

```bash
pip install openpyxl pandas
# Optional for advanced features:
pip install xlsxwriter xlrd
```
