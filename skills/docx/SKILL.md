---
name: docx
description: Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction. This skill should be used when Cline needs to work with professional documents (.docx files) for creating new documents, modifying or editing content, working with tracked changes, adding comments, or any other document tasks.
---

# DOCX Creation, Editing, and Analysis

## Overview

A user may ask Cline to create, edit, or analyze the contents of a .docx file. A .docx file is essentially a ZIP archive containing XML files and other resources that can be read or edited. Different tools and workflows are available for different tasks.

## Workflow Decision Tree

### Reading/Analyzing Content
Use "Text extraction" or "Raw XML access" sections below

### Creating New Document
Use "Creating a new Word document" workflow

### Editing Existing Document
- **Own document + simple changes** → Use "Basic OOXML editing" workflow
- **Someone else's document** → Use **"Redlining workflow"** (recommended default)
- **Legal, academic, business, or government docs** → Use **"Redlining workflow"** (required)

## Reading and Analyzing Content

### Text Extraction

If you just need to read the text contents of a document, convert the document to markdown using pandoc:

```bash
# Convert document to markdown with tracked changes
pandoc --track-changes=all path-to-file.docx -o output.md
# Options: --track-changes=accept/reject/all
```

### Raw XML Access

Raw XML access is needed for: comments, complex formatting, document structure, embedded media, and metadata. Unpack the document to read its raw XML contents.

#### Unpacking a File

```bash
# Unpack using Python zipfile
python3 -c "
import zipfile
with zipfile.ZipFile('document.docx') as z:
    z.extractall('unpacked/')
"
```

#### Key File Structures

* `word/document.xml` — Main document contents
* `word/comments.xml` — Comments referenced in document.xml
* `word/media/` — Embedded images and media files
* Tracked changes use `<w:ins>` (insertions) and `<w:del>` (deletions) tags

## Creating a New Word Document

When creating a new Word document from scratch, use **docx-js**, which allows you to create Word documents using JavaScript/TypeScript.

### Workflow

1. Create a JavaScript/TypeScript file using Document, Paragraph, TextRun components
2. Export as .docx using Packer.toBuffer()

### Example

```javascript
const { Document, Packer, Paragraph, TextRun, HeadingLevel } = require("docx");
const fs = require("fs");

const doc = new Document({
  sections: [{
    properties: {},
    children: [
      new Paragraph({
        text: "Report Title",
        heading: HeadingLevel.HEADING_1,
      }),
      new Paragraph({
        children: [
          new TextRun("This is the body text of the document."),
        ],
      }),
    ],
  }],
});

Packer.toBuffer(doc).then((buffer) => {
  fs.writeFileSync("output.docx", buffer);
});
```

### Dependencies

```bash
npm install docx
```

## Editing an Existing Word Document

When editing an existing Word document, work with the underlying XML directly.

### Workflow

1. Unpack the document using Python zipfile
2. Modify the XML in `word/document.xml`
3. Repack the document

### Unpack/Repack Pattern

```python
import zipfile
import os

# Unpack
with zipfile.ZipFile('document.docx') as z:
    z.extractall('unpacked/')

# ... Edit files in unpacked/ ...

# Repack
with zipfile.ZipFile('output.docx', 'w', zipfile.ZIP_DEFLATED) as zout:
    for root, dirs, files in os.walk('unpacked/'):
        for file in files:
            file_path = os.path.join(root, file)
            arcname = os.path.relpath(file_path, 'unpacked/')
            zout.write(file_path, arcname)
```

## Redlining Workflow for Document Review

This workflow creates comprehensive tracked changes using OOXML. **CRITICAL**: For complete tracked changes, implement ALL changes systematically.

**Batching Strategy**: Group related changes into batches of 3-10 changes. This makes debugging manageable while maintaining efficiency. Test each batch before moving to the next.

**Principle: Minimal, Precise Edits**
When implementing tracked changes, only mark text that actually changes. Break replacements into: [unchanged text] + [deletion] + [insertion] + [unchanged text].

Example — Changing "30 days" to "60 days":
```xml
<!-- BAD - Replaces entire sentence -->
<w:del><w:r><w:delText>The term is 30 days.</w:delText></w:r></w:del>
<w:ins><w:r><w:t>The term is 60 days.</w:t></w:r></w:ins>

<!-- GOOD - Only marks what changed -->
<w:r w:rsidR="00AB12CD"><w:t>The term is </w:t></w:r>
<w:del><w:r><w:delText>30</w:delText></w:r></w:del>
<w:ins><w:r><w:t>60</w:t></w:r></w:ins>
<w:r w:rsidR="00AB12CD"><w:t> days.</w:t></w:r>
```

### Tracked Changes Workflow

1. **Get markdown representation**:
   ```bash
   pandoc --track-changes=all path-to-file.docx -o current.md
   ```

2. **Identify and group changes**: Review the document and identify ALL changes needed, organizing them into logical batches

3. **Unpack and modify**:
   ```bash
   python3 -c "
   import zipfile
   with zipfile.ZipFile('document.docx') as z:
       z.extractall('unpacked/')
   "
   ```

4. **Implement changes in batches**: Group changes logically and implement them together in a single script per batch

5. **Repack the document**:
   ```bash
   python3 repack.py unpacked/ reviewed-document.docx
   ```

6. **Final verification**:
   ```bash
   pandoc --track-changes=all reviewed-document.docx -o verification.md
   ```

## Converting Documents to Images

To visually analyze Word documents, convert them to images:

1. **Convert DOCX to PDF**:
   ```bash
   soffice --headless --convert-to pdf document.docx
   ```

2. **Convert PDF pages to JPEG images**:
   ```bash
   pdftoppm -jpeg -r 150 document.pdf page
   ```

## Code Style Guidelines

**IMPORTANT**: When generating code for DOCX operations:
- Write concise code
- Avoid verbose variable names and redundant operations
- Avoid unnecessary print statements

## Dependencies

Required dependencies (install if not available):

- **pandoc**: `sudo apt-get install pandoc` (for text extraction)
- **docx**: `npm install docx` (for creating new documents)
- **LibreOffice**: `sudo apt-get install libreoffice` (for PDF conversion)
- **Poppler**: `sudo apt-get install poppler-utils` (for pdftoppm)
