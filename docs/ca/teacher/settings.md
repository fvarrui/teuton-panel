---
title: Configuració
parent: Guia del professor
nav_order: 9
lang: ca
permalink: /teacher/settings/
---

# Configuració
{: .no_toc }

Cas d'ús <span class="uc-id">T11</span>.
{: .fs-3 }

1. TOC
{:toc}

**Configuració** canvia el comportament del panell; cada canvi es desa al moment a `teuton-panel.yaml`.

{% include screenshot.html file="teacher-settings" alt="Pàgina de configuració" %}

## Què poden fer els alumnes

| Opció | Quan està activada |
| --- | --- |
| Registrar-se | Els alumnes poden registrar-se i actualitzar les seves dades |
| Veure qui està registrat | L'inici d'alumnes llista els registrats (només noms) |
| Executar el seu test | Els alumnes poden executar el seu propi case |
| Veure la seva nota | Els alumnes veuen la seva última nota |
| Veure el resultat de cada objectiu | Els alumnes veuen també quins objectius han complert (sense ordres ni sortides) |
| Veure el seu històric de notes | Els alumnes veuen la seva nota a cada execució de la sessió |
| Veure l'estat de la seva connexió | Els alumnes veuen si el panell ha arribat a la seva màquina |
| Llegir l'enunciat | Els alumnes poden llegir l'enunciat del test |

Una opció desactivada respon *El teu professor no ha activat aquesta opció* i desapareix dels menús de l'alumne.

## Formats que reben els alumnes

Tria qualsevol combinació de **Pàgines web**, **Text pla** (`.txt`, per a `curl`) i **JSON** (`.json`). Una petició en un format desactivat rep un missatge breu amb els formats disponibles. **Sense cap format** marcat, la zona d'alumnes queda tancada. La teva àrea no se'n veu afectada.

## Altres opcions

- **Segons entre execucions del mateix alumne**: quant espera un alumne abans de tornar a executar (30 per defecte; 0 per no limitar).
- **Idioma per defecte**: es fa servir quan el navegador demana un idioma que el panell no té.
- **Execucions d'alumnes alhora**: quantes execucions d'alumnes poden anar en paral·lel (s'aplica en reiniciar el panell).
- **Adreces que es mostren als alumnes**: deixa-ho buit per mostrar totes les detectades, o escriu la bona quan l'ordinador té adaptadors de més.
- **Altres IP de professor**: ordinadors que poden obrir l'àrea del professor a més d'aquest, separats per comes.

## El fitxer de configuració

La configuració és a `teuton-panel.yaml`, a la carpeta amb què has engegat el panell. També el pots editar a mà amb el panell aturat:

```yaml
:server:
  :bind: 0.0.0.0
  :port: 4567
  :addresses: []           # adreces que es mostren als alumnes (buit = detectades)
:language: es
:teacher:
  :allow: []               # altres IP de professor
:test: linux-files-basics  # test actiu
:run:
  :every: 60
  :times: 1
  :delay: 3
:runs:
  :max_parallel: 4
:student:
  :register: true
  :list: true
  :run: true
  :results: true
  :feedback: false
  :history: true
  :status: true
  :readme: true
  :formats: [html, txt, json]
  :run_interval: 30
:datadir: ".teuton-panel"
```
