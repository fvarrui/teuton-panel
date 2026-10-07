---
title: La meva pàgina
parent: Guia de l'alumne
nav_order: 2
lang: ca
permalink: /students/my-page/
---

# La meva pàgina: execució, resultats, històric i connexió
{: .no_toc }

Casos d'ús <span class="uc-id">S3</span> obrir la teva pàgina, <span class="uc-id">S4</span> executar el teu test, <span class="uc-id">S5</span> veure els teus resultats, <span class="uc-id">S6</span> veure el teu històric, <span class="uc-id">S7</span> comprovar la teva connexió.
{: .fs-3 }

1. TOC
{:toc}

## Obrir la teva pàgina

A l'inici d'alumnes, escriu el teu codi a **Ja estàs registrat?** i prem **Obre la meva pàgina**, o ves a `/students/<codi>`. A partir d'aleshores, el navegador recorda el teu codi: fes servir **La meva pàgina** al menú per tornar-hi. En un ordinador compartit, prem **No ets tu?** al costat del teu codi perquè la persona següent no vegi la teva pàgina.

{% include screenshot.html file="students-personal" alt="Pàgina personal" %}

La teva pàgina mostra la teva última nota, enllaços al teu històric, a l'estat de la connexió i a l'enunciat, l'ordre `curl` de la teva pàgina i les teves dades de registre.

## Executar el teu test

Prem **Executa el meu test**. El panell avalua només la teva màquina; mentre treballa, la pàgina ho indica i s'actualitza sola fins que arriba el resultat (pot trigar uns segons). Tornar a carregar la pàgina mai no engega una altra execució.

{% include screenshot.html file="students-run" alt="Resultat de l'execució d'un alumne" %}

A vegades l'execució no comença, i la pàgina et diu per què:

| Missatge | Per què |
| --- | --- |
| *Espera N segons abans de tornar a executar* | Has executat fa un moment; el teu professor fixa l'interval mínim. |
| *El professor està avaluant tota la classe: se t'avaluarà a la propera passada a les HH:MM* | El teu professor està executant la classe periòdicament; no cal que executis tu. |
| *El teu test ja s'està executant* / *és a la cua* | La teva petició anterior encara no ha acabat; consulta els teus resultats d'aquí a un moment. |
| *El teu professor ha pausat la teva avaluació de moment* | El teu professor t'ha desactivat (per exemple, perquè vas faltar). |

{% include screenshot.html file="students-run-next-pass" alt="Petició d'execució durant l'execució periòdica del professor" %}

## Els teus resultats

**Els meus resultats** mostra la teva última nota i quan es va avaluar. Si el teu professor ho ha activat, veus també cada objectiu del test amb una marca, per saber què et falta. **Torna a executar** engega una execució nova des d'aquí (o et diu quants segons has d'esperar encara):

{% include screenshot.html file="students-results" alt="Resultats de l'alumne amb cada objectiu" %}

Si la teva nota és 0 perquè s'ha trobat la mateixa resposta a la màquina d'un altre alumne, la pàgina ho diu.

## El teu històric

**El meu històric de notes** llista la teva nota a cada execució de la sessió, de la més recent a la més antiga, incloses les que ha engegat el teu professor:

{% include screenshot.html file="students-history" alt="Històric de notes" %}

## La teva connexió

**Estat de la connexió** et diu si el panell va arribar a la teva màquina a l'última execució:

{% include screenshot.html file="students-status" alt="Estat de la connexió" %}

Si no hi va poder arribar, comprova que la màquina està engegada, que la seva IP és correcta i que SSH accepta el teu usuari i contrasenya, i torna a executar.

## Quan el teu professor et pausa

Si el teu professor et desactiva, la teva pàgina ho diu i desapareix **Executa el meu test**; pots continuar veient els teus resultats i el teu històric.

{% include screenshot.html file="students-disabled" alt="Pàgina personal d'un alumne desactivat" %}
