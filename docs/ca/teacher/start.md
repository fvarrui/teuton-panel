---
title: Engegar el panell
parent: Guia del professor
nav_order: 1
lang: ca
permalink: /teacher/start/
---

# Engegar el panell
{: .no_toc }

Casos d'ús <span class="uc-id">T1</span> engegar el panell i veure on es connecten els alumnes, <span class="uc-id">T12</span> obrir l'àrea del professor des d'un altre ordinador.
{: .fs-3 }

1. TOC
{:toc}

## Engegar-lo

```bash
teuton-panel up RUTA/ALS/TESTS
```

La primera vegada, el panell:

- comprova que Teuton 3 està instal·lat (si no, et diu com instal·lar-lo i s'atura);
- busca tots els tests de Teuton de la carpeta (carpetes amb un `start.rb`) i s'atura si no n'hi ha cap;
- crea `teuton-panel.yaml` amb la configuració per defecte;
- activa el test automàticament quan només n'hi ha un: afegeix `tt_include: config.d` al seu `config.yaml` i proposa els camps de l'alta.

Si hi ha diversos tests, tria'n un a [Tests]({{ site.baseurl }}/teacher/tests/).

## La sala de control

Obre `http://localhost:4567/teacher` (o simplement `http://localhost:4567/`: al teu ordinador, l'adreça del panell et porta a l'àrea del professor). La pàgina d'inici mostra:

- el test actiu, amb botons per **Executar** i per obrir el **Mode projector**;
- el **resum de la classe**: nota mitjana, quants han aprovat (50 o més), quants estan complets (100) i quants encara no s'han avaluat; enllaça a Resultats;
- quants alumnes hi ha registrats i quants s'han avaluat;
- si hi ha una execució en marxa, l'última execució i la cua d'execucions d'alumnes;
- **on es connecten els alumnes**: una adreça per interfície de xarxa, amb l'ordre `curl` per als alumnes sense navegador, i un recordatori quan els alumnes poden veure qui està registrat.

{% include screenshot.html file="teacher-home" alt="Pàgina d'inici del professor" %}

{: .tip }
Si el teu ordinador té adaptadors de xarxa de més (VirtualBox, Docker…), els alumnes poden veure adreces que no els serveixen. Indica la bona a [Configuració]({{ site.baseurl }}/teacher/settings/) → **Adreces que es mostren als alumnes**.

Quan encara no hi ha test actiu, la pàgina d'inici et demana que en triïs un, i les pàgines que necessiten un test (Alumnes, Executa, Resultats…) mostren un enllaç a **Tests**.

## Idioma

El panell segueix l'idioma del teu navegador (anglès, castellà o català). Canvia'l amb els enllaços **EN · ES · CA** de la barra superior; l'elecció es recorda. L'idioma per defecte per als navegadors que en demanen un altre es fixa a Configuració.

## Obrir l'àrea del professor des d'un altre ordinador

L'àrea del professor només respon a l'ordinador on corre el panell (`localhost` o les seves pròpies adreces). Qualsevol altre rep *403 Aquesta zona només està disponible a l'ordinador del professor*. Si engegues el panell en un servidor i el gestiones des del teu portàtil:

- afegeix la IP del portàtil a [Configuració]({{ site.baseurl }}/teacher/settings/) → **Altres IP de professor**; o
- fes servir un túnel SSH: `ssh -L 4567:localhost:4567 servidor` i obre `http://localhost:4567/teacher` al portàtil.

## Aturar-lo

Prem `Ctrl+C` al terminal. S'aturen els processos de Teuton en marxa; els registres, els resultats i l'històric queden al disc per a la propera vegada. Una execució periòdica no es reprèn sola després de reiniciar: la pàgina Executa mostra els últims ajustos a punt per tornar a començar.
