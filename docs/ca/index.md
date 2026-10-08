---
title: Inici
nav_order: 1
lang: ca
permalink: /
---

<img class="home-logo" src="{{ site.baseurl }}/assets/images/logo/teuton-panel.svg" alt="teuton-panel" width="180" height="180">

# Teuton Panel

Un panell web per a [Teuton](https://github.com/teuton-software/teuton) que el professor engega a la xarxa de l'aula. Els alumnes registren les seves màquines des del navegador o des d'un terminal, el panell executa Teuton per a tota la classe o per a un alumne, i tothom veu els resultats: el professor en un panell a punt per al projector i cada alumne a la seva pròpia pàgina.
{: .fs-5 .fw-300 }

[Primers passos]({{ site.baseurl }}/getting-started/){: .btn .btn-primary .mr-2 } [Guia del professor]({{ site.baseurl }}/teacher/){: .btn .mr-2 } [Guia de l'alumne]({{ site.baseurl }}/students/){: .btn }

{% include screenshot.html file="teacher-projector" alt="Mode projector amb la nota de cada alumne" caption="Mode projector: l'última nota de cada alumne, actualitzada cada 10 segons." %}

## Què fa

- **Per al professor** (només des del seu ordinador): triar el test, decidir què omplen els alumnes en registrar-se, gestionar alumnes, executar el test una vegada, diverses vegades o cada pocs segons, seguir la classe en directe, descarregar `moodle.csv` i arxivar cada sessió de classe.
- **Per als alumnes** (des de la xarxa de l'aula): registrar-se i obtenir un codi personal, executar el seu test quan estiguin a punt, i veure la seva nota, el seu històric, l'estat de la connexió i l'enunciat.
- **Navegador o terminal**: totes les pàgines d'alumne funcionen també amb `curl`, en text pla o JSON.
- **Anglès, castellà i català**, segons l'idioma del navegador.
- **Sense internet** i sense configurar res a mà: el panell crea els seus fitxers la primera vegada que s'engega.

Teuton fa les proves; el panell només el dirigeix. Qualsevol test de Teuton 3 funciona sense canvis.

## Com està organitzada aquesta guia

- [Primers passos]({{ site.baseurl }}/getting-started/): instal·lar el panell i provar el repte d'exemple.
- [Guia del professor]({{ site.baseurl }}/teacher/): cada tasca de l'àrea del professor, pas a pas.
- [Guia de l'alumne]({{ site.baseurl }}/students/): el que fan els alumnes, al navegador i en un terminal.
- [Casos d'ús]({{ site.baseurl }}/use-cases/): la llista completa de casos d'ús i on s'explica cadascun.
- [Preguntes freqüents]({{ site.baseurl }}/faq/): problemes habituals i com resoldre'ls.
- [Desenvolupadors]({{ site.baseurl }}/developers/): arquitectura, entorn de desenvolupament, proves i traduccions.
