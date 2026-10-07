---
title: Contribuir
parent: Desarrolladores
nav_order: 5
lang: es
permalink: /developers/contributing/
---

# Contribuir

- **Idioma**: el código, los comentarios, los commits y las especificaciones van en inglés; los textos para el usuario están en los ficheros de idioma (inglés, español y catalán).
- **Estilo de código**: Ruby escrito como lo escribe el mantenedor de Teuton (clases pequeñas y procedimentales, `require_relative`, cláusulas de guarda, `puts`/`warn` y `exit 1` para los errores del CLI), revisado con Standard. Las reglas están en `.claude/skills/dvarrui-ruby-style/`.
- **Especificaciones**: el proyecto usa MiniSpec. Lee primero `.minispec/README.md`; el conocimiento permanente está en `.minispec/core/`, las decisiones en `.minispec/decisions/` y el trabajo en curso en `.minispec/features/` (se borra al terminar).
- **Sencillez**: Sinatra sin más, ninguna dependencia nueva sin motivo, nada que necesite compilador de C, herramientas en Ruby puro.
- **Seguridad**: los valores que escriben los alumnos llegan a los comandos de los tests de Teuton; mantén estricto `Registration.value_error` y no muestres nunca los informes en bruto a los alumnos.
- **Antes de una pull request**: `bundle exec rake`, `bundle exec rake usecases` y, tras cambios visuales, `bundle exec rake docs:screenshots`.
- **Commits**: cortos, en minúsculas, con prefijo de tipo (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`).

Las pull requests son bienvenidas en [dvarrui/teuton-panel](https://github.com/dvarrui/teuton-panel).
