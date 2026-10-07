---
title: Desarrolladores
nav_order: 7
has_children: true
lang: es
permalink: /developers/
---

# Desarrolladores

teuton-panel es una gema de Ruby pequeña: un CLI con Thor y una aplicación Sinatra servida por WEBrick, que dirige el comando `teuton` y lee sus informes JSON. Todo es Ruby puro: sin base de datos, sin compilación de JavaScript y sin necesidad de compilador.

- [Arquitectura]({{ site.baseurl }}/developers/architecture/): cómo encajan las piezas.
- [Entorno de desarrollo]({{ site.baseurl }}/developers/setup/): ejecutarlo desde el código fuente, el ejemplo y esta documentación.
- [Pruebas]({{ site.baseurl }}/developers/testing/): tests unitarios y web, la batería de casos de uso y las capturas.
- [Traducciones]({{ site.baseurl }}/developers/translations/): los idiomas de la interfaz y de la documentación.
- [Contribuir]({{ site.baseurl }}/developers/contributing/): estilo de código, especificaciones y pull requests.
- [Notas de diseño]({{ site.baseurl }}/developers/notes/): las notas originales que dieron origen al proyecto (en inglés).

Las decisiones de diseño y las especificaciones están en la carpeta `.minispec/` del repositorio (`core/` para el conocimiento permanente, `decisions/` para los ADR).
