---
title: Casos d'ús
nav_order: 5
lang: ca
permalink: /use-cases/
---

# Casos d'ús
{: .no_toc }

Tots els casos d'ús de teuton-panel i on s'explica cadascun. Tots es comproven automàticament contra el repte d'exemple amb `rake usecases` (vegeu [Proves]({{ site.baseurl }}/developers/testing/)).

1. TOC
{:toc}

## Professor

| Id | Cas d'ús | Guia |
| --- | --- | --- |
| <span class="uc-id">T1</span> | Engegar el panell i veure on es connecten els alumnes | [Engegar el panell]({{ site.baseurl }}/teacher/start/) |
| <span class="uc-id">T2</span> | Triar el test actiu i revisar-lo amb `teuton check` | [Tests]({{ site.baseurl }}/teacher/tests/) |
| <span class="uc-id">T3</span> | Definir els camps de l'alta (preguntats, IP automàtica, valors fixos) | [Camps de l'alta]({{ site.baseurl }}/teacher/registration/) |
| <span class="uc-id">T4</span> | Gestionar alumnes: editar, desactivar, activar, esborrar, donar un codi | [Alumnes]({{ site.baseurl }}/teacher/students/) |
| <span class="uc-id">T5</span> | Executar el test una vegada, diverses vegades o cada T segons, per a tothom o una selecció, fins a una hora; aturar-lo | [Executar el test]({{ site.baseurl }}/teacher/runs/) |
| <span class="uc-id">T6</span> | Consultar l'històric d'execucions i el detall de cadascuna | [Executar el test]({{ site.baseurl }}/teacher/runs/#històric-dexecucions) |
| <span class="uc-id">T7</span> | Seguir els resultats, veure el detall d'un alumne, fer servir el mode projector | [Resultats]({{ site.baseurl }}/teacher/results/) |
| <span class="uc-id">T8</span> | Exportar les notes a Moodle (`moodle.csv`) | [Resultats]({{ site.baseurl }}/teacher/results/#exportar-a-moodle) |
| <span class="uc-id">T9</span> | Veure l'enunciat que llegeixen els alumnes | [Enunciat]({{ site.baseurl }}/teacher/statement/) |
| <span class="uc-id">T10</span> | Arxivar una sessió de classe i consultar les arxivades | [Sessions de classe]({{ site.baseurl }}/teacher/sessions/) |
| <span class="uc-id">T11</span> | Configurar el panell: funcions i formats d'alumnes, interval d'execució, idioma, adreces, IP de professor | [Configuració]({{ site.baseurl }}/teacher/settings/) |
| <span class="uc-id">T12</span> | Obrir l'àrea del professor des d'un altre ordinador | [Engegar el panell]({{ site.baseurl }}/teacher/start/#obrir-làrea-del-professor-des-dun-altre-ordinador) |

## Alumne

| Id | Cas d'ús | Guia |
| --- | --- | --- |
| <span class="uc-id">S1</span> | Registrar-se (navegador o terminal) i obtenir un codi personal | [Registrar-se]({{ site.baseurl }}/students/register/) |
| <span class="uc-id">S2</span> | Corregir les meves dades de registre | [Registrar-se]({{ site.baseurl }}/students/register/#corregir-les-teves-dades) |
| <span class="uc-id">S3</span> | Obrir la meva pàgina amb el meu codi | [La meva pàgina]({{ site.baseurl }}/students/my-page/) |
| <span class="uc-id">S4</span> | Executar el meu propi test | [La meva pàgina]({{ site.baseurl }}/students/my-page/#executar-el-teu-test) |
| <span class="uc-id">S5</span> | Veure la meva última nota i, si està activat, cada objectiu | [La meva pàgina]({{ site.baseurl }}/students/my-page/#els-teus-resultats) |
| <span class="uc-id">S6</span> | Veure el meu històric de notes | [La meva pàgina]({{ site.baseurl }}/students/my-page/#el-teu-històric) |
| <span class="uc-id">S7</span> | Comprovar si el panell arriba a la meva màquina | [La meva pàgina]({{ site.baseurl }}/students/my-page/#la-teva-connexió) |
| <span class="uc-id">S8</span> | Llegir l'enunciat del test | [Enunciat]({{ site.baseurl }}/students/statement/) |
| <span class="uc-id">S9</span> | Veure qui està registrat | [Registrar-se]({{ site.baseurl }}/students/register/#qui-està-registrat) |
| <span class="uc-id">S10</span> | Fer-ho tot des d'un terminal, en text o JSON | [Des d'un terminal]({{ site.baseurl }}/students/terminal/) |

## Situacions i què fa el panell

| Situació | Què passa |
| --- | --- |
| Un alumne arriba tard | Es registra i entra a la propera execució, sense reiniciar res. |
| Un alumne es registra des de la màquina equivocada (`AUTO IP`) | Es guarda una IP incorrecta; el professor la corregeix a Alumnes → Edita, o fa el camp "Preguntar". |
| Un alumne oblida el seu codi | El professor el busca a Alumnes. |
| Un alumne es registra dues vegades | Rep dos codis; el professor esborra el registre sobrant. |
| Un alumne falta a classe | El professor el desactiva: queda fora de les execucions i conserva la seva última nota. |
| Un alumne torna a executar massa aviat | Se li diu quants segons ha d'esperar. |
| El professor executa la classe periòdicament | A qui prem Executa se li diu quan l'avaluarà la propera passada. |
| La màquina d'un alumne està apagada o SSH rebutja les seves credencials | El resultat mostra un problema de connexió; l'alumne ho veu a Estat de la connexió. |
| Dos alumnes lliuren la mateixa resposta | La comprovació `unique` de Teuton posa un 0 i el panell explica per què. |
| Un alumne escriu cometes o símbols en un camp | Es rebutja el valor amb una explicació; res no arriba a Teuton. |
| Un alumne obre un codi desconegut | Se li diu que el codi és desconegut i se l'envia a l'alta. |
| El professor desactiva una funció o un format | Aquella pàgina respon "no activada" o indica els formats disponibles. |
| El professor tanca la zona d'alumnes | Totes les pàgines d'alumne responen que la zona està tancada. |
| Algú obre l'àrea del professor des d'un altre ordinador | 403, tret que la seva IP sigui a la llista de professors. |
| Hi ha diversos tests i cap d'actiu | L'inici del professor demana triar un test. |
| La carpeta del test actiu es reanomena o es mou | El panell l'oblida en engegar-se i tria l'únic test si només n'hi ha un. |
| El professor canvia de test actiu | S'aturen les execucions; els registres del test anterior es conserven per quan torni a estar actiu. |
| Comença una classe nova | El professor arxiva la sessió i comença de zero. |
