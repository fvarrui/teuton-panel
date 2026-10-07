---
title: Executar el test
parent: Guia del professor
nav_order: 5
lang: ca
permalink: /teacher/runs/
---

# Executar el test i consultar l'històric
{: .no_toc }

Casos d'ús <span class="uc-id">T5</span> executar el test, <span class="uc-id">T6</span> consultar l'històric d'execucions.
{: .fs-3 }

1. TOC
{:toc}

## Engegar una execució

A **Executa**, tria un mode, els alumnes que vols avaluar i prem **Comença**.

{% include screenshot.html file="teacher-run" alt="Pàgina Executa" %}

| Mode | Camps | Què passa |
| --- | --- | --- |
| **Una vegada** | — | Una passada pels alumnes triats. |
| **Diverses vegades** | Quantes vegades, segons entre execucions | N passades, una darrere l'altra. |
| **Cada pocs segons** | Cada (segons, mínim 10), fins a (opcional) | Una passada cada T segons fins que premis **Atura** o arribi l'hora de **Fins a**. |

- **Alumnes**: estan marcats tots els alumnes actius; desmarca'n alguns per avaluar només una selecció. Els desactivats no es poden marcar.
- Mai no comença una passada mentre l'anterior encara està en marxa.
- Els ajustos que facis servir es recorden per a la propera vegada.

## Seguir una execució

Mentre hi ha una execució activa, la pàgina s'actualitza cada 10 segons i mostra el mode, el número de passada, quan comença la següent i les execucions d'alumnes que esperen a la cua. **Atura** cancel·la la programació i atura el procés de Teuton en marxa.

{% include screenshot.html file="teacher-run-active" alt="Una execució periòdica en marxa" %}

Mentre executes la classe periòdicament, als alumnes que premen **Executa el meu test** se'ls diu quan els avaluarà la propera passada, en lloc d'engegar una execució pròpia.

El quadre **Última execució** mostra l'hora, el tipus, el codi de sortida de Teuton i la seva sortida quan n'hi ha; si Teuton no ha generat informes (per exemple, per un error a `start.rb`), ho indica.

## Com funcionen les execucions

- Cada execució (teva o d'un alumne) s'avalua a la seva pròpia carpeta, així que una execució parcial mai no trepitja la resta de la classe.
- El panell guarda **l'últim resultat de cada alumne**, sigui quina sigui l'execució que l'ha produït.
- Les teves execucions van primer i soles; les dels alumnes comparteixen un límit d'execucions en paral·lel (4 per defecte, vegeu Configuració).

## Històric d'execucions

**Històric** llista totes les execucions de la sessió actual: hora, tipus (tota la classe, selecció o petició d'alumne), nombre d'alumnes i nota mitjana.

{% include screenshot.html file="teacher-runs" alt="Històric d'execucions" %}

**Obre** mostra les notes d'una execució i la sortida de Teuton.

{% include screenshot.html file="teacher-run-detail" alt="Detall d'una execució" %}
