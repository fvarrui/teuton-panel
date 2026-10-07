# Statement lists rendered as one paragraph

## Problem

- In the teacher and student statement pages, the targets of each group appear glued in one paragraph: "do the following: \* (x1.0) Directory docs exists. \* (x1.0) File ...".
- The "HOST1" link in each group points to `#required-hosts`, an anchor that does not exist on the page.

## Cause

- `teuton readme` writes a list right after a paragraph line, with no blank line in between. Kramdown needs the blank line, so the items stay inside the paragraph.
- Teuton links hosts to `#required-hosts`, but the heading is translated ("Required hosts", "Máquinas que se necesitan") and Kramdown builds the id from the translated text.

## Solution

- In `Readme.markdown`, after masking, insert a blank line before a list item (`* `) that follows a non-list, non-blank line. The `.md` route gets the fixed text too.
- Give the hosts heading the id Teuton links to (`{#required-hosts}`), or rewrite the link to the id Kramdown generates.
- Keep the cache key and masking as they are.
- What Teuton writes wrong is also reported to Teuton (principle: "what belongs to Teuton is changed in Teuton"); the panel workaround stays until a fixed Teuton is released.

## Verification

- Unit test on `Readme` with captured `teuton readme` output: the HTML has one `<ul>` with three `<li>` per group of the sample.
- The HOST1 link scrolls to the hosts table in `/teacher/readme` and `/students/readme`.
- `/students/readme.md` shows the blank lines.
