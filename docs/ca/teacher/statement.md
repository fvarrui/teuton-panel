---
title: Enunciat
parent: Guia del professor
nav_order: 7
lang: ca
permalink: /teacher/statement/
---

# Veure l'enunciat

Cas d'ús <span class="uc-id">T9</span>.
{: .fs-3 }

**Enunciat** mostra l'enunciat que Teuton genera a partir del teu test (`teuton readme`), amb les màquines necessàries, els paràmetres i els objectius de cada grup. Té dues vistes:

- **Text complet**: tota la sortida de `teuton readme`.
- **Com el veuen els alumnes**: el que llegeixen els alumnes a `/students/readme`. Omet el bloc de la versió de Teuton de dalt de tot, només llista els paràmetres que els alumnes escriuen en registrar-se i treu la nota sobre SSH quan totes les màquines del test són `localhost`.

{% include screenshot.html file="teacher-readme" alt="Previsualització de l'enunciat" %}

- Les contrasenyes sempre s'amaguen (`******`), encara que les posis a `config.yaml`.
- Els alumnes només el veuen si **Llegir l'enunciat** està activat a [Configuració]({{ site.baseurl }}/teacher/settings/); la pàgina t'indica si està publicat.
- Es torna a generar quan canvien `start.rb` o `config.yaml`.
- Teuton escriu els enunciats en anglès i en castellà: qui fa servir el panell en català llegeix el castellà.
