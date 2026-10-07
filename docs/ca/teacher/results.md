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

**Resultats** mostra l'últim resultat de cada alumne, de millor a pitjor nota, i s'actualitza cada 10 segons. A dalt, el **resum de la classe** dona la nota mitjana, quants han aprovat (50 o més), quants estan complets (100) i quants encara no s'han avaluat; els alumnes desactivats no hi compten.

{% include screenshot.html file="teacher-results" alt="Taula de resultats" %}

| Estat | Significat |
| --- | --- |
| **Complet** | Avaluat, nota 100 |
| **Aprovat** | Avaluat, nota de 50 a 99 |
| **Li falta feina** | Avaluat, nota per sota de 50 |
| **Problema de connexió** | El panell no ha pogut arribar a la màquina de l'alumne (apagada, IP equivocada, SSH rebutjat) |
| **Còpia detectada** | Nota 0 perquè la comprovació `unique` de Teuton ha trobat la mateixa resposta a la màquina d'un altre alumne |
| **Pendent** | Registrat però encara sense avaluar |
| **Desactivat** | Pausat pel professor; conserva la seva última nota |

La barra de la nota fa servir els mateixos colors que l'estat: verd per a *Complet*, verd blavós per a *Aprovat* i vermell per a *Li falta feina*.

## Detall d'un alumne

**Detall** mostra cada objectiu del test: si s'ha complert, el seu grup i el seu pes, el valor esperat i la sortida (passa per sobre d'un objectiu per veure'n l'ordre). Fes-lo servir per entendre per què un alumne està encallat. **Anterior** i **Següent** recorren els alumnes en l'ordre de la taula de resultats.

{% include screenshot.html file="teacher-result-detail" alt="Detall del resultat d'un alumne" %}

## Mode projector

**Mode projector** mostra targetes grans amb el nom, la nota i l'estat de cada alumne sobre fons fosc, juntament amb l'adreça d'alumnes i el resum de la classe, perquè tota la classe ho segueixi des del seu lloc. S'actualitza cada 10 segons i amaga ordres i sortides. **Surt del projector** torna a la taula.

{% include screenshot.html file="teacher-projector" alt="Mode projector" %}

## Exportar a Moodle

**Descarrega moodle.csv** dona un fitxer que pots importar al llibre de qualificacions de Moodle: `MoodleID, TeutonGrade, TeutonFeedback`, una línia per alumne amb `tt_moodle_id` (fes-lo un camp **Preguntar com a correu** a [Camps de l'alta]({{ site.baseurl }}/teacher/registration/)). Inclou els alumnes avaluats en qualsevol execució, no només a l'última completa.
