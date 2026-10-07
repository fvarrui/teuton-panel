---
title: Guia del professor
nav_order: 3
has_children: true
lang: ca
permalink: /teacher/
---

# Guia del professor

L'àrea del professor és a `http://localhost:4567/teacher` i només respon al teu propi ordinador (a [Engegar el panell]({{ site.baseurl }}/teacher/start/) s'explica com obrir-la des d'un altre). El seu menú segueix una classe: **Inici**, després **Preparar** (Tests, Camps de l'alta, Enunciat), **Classe** (Alumnes, Executa, Resultats, Històric) i, finalment, Sessions i Configuració. Si obres l'adreça del panell sense ruta (`http://localhost:4567/`) al teu ordinador, també arribes aquí.

{% include screenshot.html file="teacher-home" alt="Inici del professor: alumnes, execucions i adreces d'alumnes" caption="La sala de control: el resum de la classe, quants alumnes hi ha, si hi ha una execució en marxa i on es connecten els alumnes." %}

| Pàgina | Què hi fas | Casos d'ús |
| --- | --- | --- |
| [Inici]({{ site.baseurl }}/teacher/start/) | Veure l'estat de la classe i les adreces d'alumnes | <span class="uc-id">T1</span> <span class="uc-id">T12</span> |
| [Tests]({{ site.baseurl }}/teacher/tests/) | Triar el test actiu i revisar-lo | <span class="uc-id">T2</span> |
| [Camps de l'alta]({{ site.baseurl }}/teacher/registration/) | Decidir què omplen els alumnes, amb les teves pròpies etiquetes i ajudes | <span class="uc-id">T3</span> |
| [Alumnes]({{ site.baseurl }}/teacher/students/) | Corregir, pausar o esborrar registres | <span class="uc-id">T4</span> |
| [Executa]({{ site.baseurl }}/teacher/runs/) i Històric | Avaluar la classe una vegada, diverses vegades o periòdicament | <span class="uc-id">T5</span> <span class="uc-id">T6</span> |
| [Resultats]({{ site.baseurl }}/teacher/results/) | Seguir la classe, fer servir el projector, exportar a Moodle | <span class="uc-id">T7</span> <span class="uc-id">T8</span> |
| [Enunciat]({{ site.baseurl }}/teacher/statement/) | Veure el que llegeixen els alumnes | <span class="uc-id">T9</span> |
| [Sessions]({{ site.baseurl }}/teacher/sessions/) | Arxivar una classe i començar la següent neta | <span class="uc-id">T10</span> |
| [Configuració]({{ site.baseurl }}/teacher/settings/) | Triar què poden fer els alumnes i altres opcions | <span class="uc-id">T11</span> |

## Una classe típica

1. Abans de la classe, engega el panell, activa el test i executa **teuton check** per detectar errors.
2. Projecta l'adreça d'alumnes; els alumnes es registren mentre expliques el repte.
3. Engega una execució periòdica (per exemple, cada 60 segons) i obre el mode projector.
4. Passeja per l'aula: el projector et diu qui necessita ajuda, i els alumnes poden executar el seu test quan vulguin.
5. En acabar, descarrega `moodle.csv` i arxiva la sessió.
