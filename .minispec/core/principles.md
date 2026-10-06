# Engineering principles

Consult **before** writing code.

- Solve first, optimize later; readable code over clever code.
- One responsibility per class or component; composition over inheritance.
- Avoid premature abstractions; if a choice adds a lot of complexity, propose a simpler alternative first.
- Preserve existing behavior; don't refactor outside the task's scope.
- Document decisions, not implementation.
- Teuton runs the tests; the panel only orchestrates them. What belongs to Teuton (e.g. `teuton config`) is changed in Teuton.
- A new teacher must be able to use the panel without hand-editing YAML: a missing file is created with useful defaults.
- Every kind of remote student access can be enabled and disabled from the panel.
- Every student action works both from a browser and from `curl`.
