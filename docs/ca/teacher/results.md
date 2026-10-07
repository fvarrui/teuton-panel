---
title: Resultats
parent: Guia del professor
nav_order: 6
lang: ca
permalink: /teacher/results/
---

# Seguir els resultats
{: .no_toc }

Casos d'ús <span class="uc-id">T7</span> seguir els resultats i fer servir el projector, <span class="uc-id">T8</span> exportar les notes a Moodle.
{: .fs-3 }

1. TOC
{:toc}

## La taula de resultats

**Resultats** mostra l'últim resultat de cada alumne, de millor a pitjor nota, i s'actualitza cada 10 segons.

{% include screenshot.html file="teacher-results" alt="Taula de resultats" %}

| Estat | Significat |
| --- | --- |
| **Fet** | Avaluat, nota de 50 o més |
| **Li falta feina** | Avaluat, nota per sota de 50 |
| **Problema de connexió** | El panell no ha pogut arribar a la màquina de l'alumne (apagada, IP equivocada, SSH rebutjat) |
| **Còpia detectada** | Nota 0 perquè la comprovació `unique` de Teuton ha trobat la mateixa resposta a la màquina d'un altre alumne |
| **Pendent** | Registrat però encara sense avaluar |
| **Desactivat** | Pausat pel professor; conserva la seva última nota |

## Detall d'un alumne

**Detall** mostra cada objectiu del test: si s'ha complert, el seu pes, l'ordre, el valor esperat i la sortida. Fes-lo servir per entendre per què un alumne està encallat.

{% include screenshot.html file="teacher-result-detail" alt="Detall del resultat d'un alumne" %}

## Mode projector

**Mode projector** mostra targetes grans amb el nom, la nota i l'estat de cada alumne sobre fons fosc, juntament amb l'adreça d'alumnes, perquè tota la classe ho segueixi des del seu lloc. S'actualitza cada 10 segons i amaga ordres i sortides. **Surt del projector** torna a la taula.

{% include screenshot.html file="teacher-projector" alt="Mode projector" %}

## Exportar a Moodle

**Descarrega moodle.csv** dona un fitxer que pots importar al llibre de qualificacions de Moodle: `MoodleID, TeutonGrade, TeutonFeedback`, una línia per alumne amb `tt_moodle_id` (fes-lo un camp **Preguntar com a correu** a [Alta]({{ site.baseurl }}/teacher/registration/)). Inclou els alumnes avaluats en qualsevol execució, no només a l'última completa.
