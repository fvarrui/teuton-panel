---
title: Des d'un terminal
parent: Guia de l'alumne
nav_order: 4
lang: ca
permalink: /students/terminal/
---

# Fer servir el panell des d'un terminal
{: .no_toc }

Cas d'ús <span class="uc-id">S10</span>.
{: .fs-3 }

1. TOC
{:toc}

Sense navegador? Totes les pàgines d'alumne existeixen també en text pla: afegeix `.txt` a l'adreça. Comença per l'ajuda (`curl http://192.168.1.10:4567/` sense ruta també la mostra):

```bash
curl "http://192.168.1.10:4567/students.txt?lang=ca"
```

```
Teuton Panel - Test d'avui: linux-files-basics

Ordres (canvia CODE pel teu codi personal):
  Registrar-te:
    curl "http://192.168.1.10:4567/students/register.txt?tt_members=...&tt_moodle_id=...&home=..."
  La teva pàgina:
    curl http://192.168.1.10:4567/students/CODE.txt
  Executar el teu test:
    curl http://192.168.1.10:4567/students/CODE/run.txt
  Els teus resultats:
    curl http://192.168.1.10:4567/students/CODE/results.txt
  ...
```

## Registrar-se

Posa tots els camps a l'adreça, entre cometes pels `&`:

```bash
curl "http://192.168.1.10:4567/students/register.txt?tt_members=Ana%20Garcia&tt_moodle_id=ana@example.com&home=ana&lang=ca"
```

```
El teu codi personal és A2KP
Guarda aquest codi: el necessites per executar el test i veure els teus resultats.

La teva pàgina: http://192.168.1.10:4567/students/A2KP
Executar el teu test:
  curl http://192.168.1.10:4567/students/A2KP/run.txt
```

Escriu els espais com a `%20`. Si algun camp està malament, reps la llista d'errors.

## Execució, resultats, històric i estat

```bash
curl "http://192.168.1.10:4567/students/A2KP/run.txt?lang=ca"
```

```
La teva execució ha acabat. Aquests són els teus resultats:
Nota: 100/100
  [OK] Directory docs exists
  [OK] File docs/notes.txt exists
  ...
```

| Ordre | Què obtens |
| --- | --- |
| `curl .../students/CODE.txt` | El teu nom, codi, dades i última nota |
| `curl .../students/CODE/run.txt` | Executa el teu test i imprimeix la nota |
| `curl .../students/CODE/results.txt` | La teva última nota i, si està activat, cada objectiu |
| `curl .../students/CODE/history.txt` | La teva nota a cada execució |
| `curl .../students/CODE/status.txt` | Si el panell ha arribat a la teva màquina |
| `curl .../students/readme.md` | L'enunciat, en Markdown |

## JSON

Canvia `.txt` per `.json` per obtenir dades per a scripts:

```bash
curl http://192.168.1.10:4567/students/A2KP/results.json
```

```json
{
  "code": "A2KP",
  "result": {
    "grade": 100.0,
    "finished_at": "2026-10-07 09:40:00 +0100",
    "unique_fault": false,
    "connection": "ok"
  }
}
```

## Idioma

Les respostes en text fan servir l'idioma per defecte del panell. Afegeix `?lang=en`, `?lang=es` o `?lang=ca` per triar-lo:

```bash
curl "http://192.168.1.10:4567/students/A2KP/results.txt?lang=ca"
```

{: .note }
El teu professor pot desactivar alguns formats. Sense sufix sempre reps la pàgina web (HTML), que es llegeix malament en un terminal: recorda't del `.txt`.
