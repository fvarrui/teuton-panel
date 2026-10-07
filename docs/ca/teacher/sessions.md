---
title: Sessions de classe
parent: Guia del professor
nav_order: 8
lang: ca
permalink: /teacher/sessions/
---

# Sessions de classe

Cas d'ús <span class="uc-id">T10</span>.
{: .fs-3 }

Els registres, els resultats i l'històric d'execucions es conserven entre engegades. Quan acaba una classe (un altre dia, un altre grup), comença una sessió nova perquè la classe següent comenci neta.

## Arxivar la sessió actual

A **Sessions**, escriu un nom opcional (per exemple, *ASIR 1 - Grup A*) i prem **Arxiva i comença una sessió nova**. Després de confirmar:

- els registres (fitxers de `config.d/`), els resultats i les execucions passen a una carpeta d'arxiu amb la data i l'hora;
- la llista d'alumnes i els resultats queden buits, i els codis personals antics deixen de funcionar;
- no s'esborra res.

No es pot arxivar mentre hi ha una execució activa: atura-la abans.

{% include screenshot.html file="teacher-sessions" alt="Sessions de classe" %}

## Consultar una sessió arxivada

**Obre** mostra els alumnes d'una sessió arxivada amb els seus codis i notes; el botó `moodle.csv` descarrega les notes d'aquella sessió.

{% include screenshot.html file="teacher-session" alt="Una sessió arxivada" %}

Les sessions arxivades es guarden a `.teuton-panel/archive/<test>/<data>/` dins de la carpeta base.
