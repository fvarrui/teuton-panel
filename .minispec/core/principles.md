# Engineering principles

Consult **before** writing code.

- Solve first, optimize later; readable code over clever code.
- One responsibility per class or component; composition over inheritance.
- Avoid premature abstractions; if a choice adds a lot of complexity, propose a simpler alternative first.
- Preserve existing behavior; don't refactor outside the task's scope.
- Document decisions, not implementation.
- Plain Sinatra, no Rails, no database, no frontend build; keep it simple (ADR-003). Pure Ruby everywhere, tooling and skills included.
- Write Ruby the way the Teuton maintainer does (`dvarrui-ruby-style` skill).
- Teuton runs the tests; the panel only orchestrates them (ADR-002). What belongs to Teuton is changed in Teuton.
- The teacher area answers only localhost and allowed teacher IPs; never expose a teacher action to the LAN (ADR-001).
- A new teacher must be able to use the panel without hand-editing YAML: a missing file is created with useful defaults.
- Every student-area feature can be enabled and disabled from the panel.
- Every student action works both from a browser and from `curl`.
- Students never see another student's data, codes or any password; nobody sees passwords on the projector.
