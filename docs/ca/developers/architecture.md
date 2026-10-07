---
title: Arquitectura
parent: Desenvolupadors
nav_order: 1
lang: ca
permalink: /developers/architecture/
---

# Arquitectura
{: .no_toc }

1. TOC
{:toc}

## Flux

```
bin/teuton-panel → CLI (Thor) → Teuton::Panel.up → comprovar teuton, Projects, Config, RunQueue, Scheduler → App (Sinatra/WEBrick)
App (àrea del professor | àrea d'alumnes) → RunQueue → Runner: subprocés teuton a la seva carpeta → informes JSON → ResultsStore → vistes
```

## Peces principals (`lib/teuton/panel/`)

| Fitxer | Paper |
| --- | --- |
| `cli.rb` | `up` i `version`; un subordre desconegut és una carpeta per a `up` |
| `panel.rb` | Façana: comprovar teuton, buscar tests, carregar la configuració, triar el test, muntar l'app, bàner |
| `config.rb` | `teuton-panel.yaml`: valors per defecte barrejats amb el fitxer, desat a cada canvi |
| `project.rb`, `teuton_config.rb` | Un test de Teuton; llegir `config.yaml` i afegir `tt_include` com a text |
| `params.rb`, `registration.rb` | Fitxer de camps de l'alta; construir i validar els valors d'un alumne |
| `students.rb` | Registre `config.d/<codi>.yaml`: codis, crear, actualitzar, desactivar, esborrar |
| `runner.rb`, `run_queue.rb` | Teuton com a subprocés; cua amb prioritat del professor i execucions d'alumnes en paral·lel |
| `results_store.rb`, `history.rb` | Últim resultat de cada alumne; resums d'execució |
| `scheduler.rb`, `sessions.rb`, `readme.rb` | Execucions del professor; sessions arxivades; enunciat sense contrasenyes |
| `lang.rb`, `network.rb` | Traduccions; utilitats d'IP |
| `app.rb`, `app/*.rb` | Nucli Sinatra, rutes del professor, rutes d'alumnes, helpers de vistes |
| `views/`, `views/txt/`, `public/` | Vistes HTML, vistes de text pla, CSS i fonts |

## Decisions clau

- **Àrea del professor a localhost, àrea d'alumnes a la xarxa** (ADR-001): les rutes del professor responen al loopback, a les IP de la mateixa màquina i a una llista de permeses.
- **Teuton com a subprocés** (ADR-002): l'API Ruby de Teuton guarda estat global i acaba el procés davant d'errors, així que cada execució és un `teuton run` a part a la seva pròpia carpeta. El panell mai no fa servir `tt_skip` ni `--case`, que fan fallar Teuton 3.0.0.
- **Sinatra senzill** (ADR-003): vistes ERB, CSS propi, fonts OFL servides en local, sense compilació de frontend, WEBrick per no necessitar compilador.
- **Codis personals** (ADR-004): els alumnes s'identifiquen per un codi a la URL, no per la seva IP.
- **Format per sufix** (ADR-005): `.txt` i `.json` a totes les rutes d'alumne; el professor tria quins formats reben.

## Execucions

Cada execució té una carpeta `.teuton-panel/tests/<test>/runs/<id>/` amb un `config.yaml` temporal que conté exactament els cases a executar, cadascun marcat amb `tt_panel_key` (el codi de l'alumne). En acabar, el panell llegeix `resume.json` i `case-NN.json` de Teuton, escriu un `summary.json` i actualitza el magatzem de resultats, que guarda l'últim resultat de cada alumne. Les carpetes d'execució són l'històric.

## Rutes

- Arrel: `/` envia les adreces del professor a `/teacher`, els navegadors a `/students` i respon a `curl` amb l'ajuda en text pla.
- Àrea d'alumnes: `/students`, `/students/register`, `/students/readme`, `/students/<codi>`, `/students/<codi>/run`, `/results`, `/history`, `/status`; totes amb `.txt` i `.json`. En un navegador, una execució segueix el patró Post/Redirect/Get: el POST la posa a la cua i redirigeix a `/students/<codi>/run?view=1`, que es recarrega sola fins que arriba el resultat. Una galeta `code` recorda el codi de l'alumne (`/students/forget` l'esborra).
- Àrea del professor: `/teacher`, `/teacher/tests`, `/teacher/registration`, `/teacher/students`, `/teacher/run` (el seu estat viu en un iframe, `/teacher/run/status`, així que el formulari mai no es recarrega), `/teacher/runs`, `/teacher/results`, `/teacher/moodle.csv`, `/teacher/readme`, `/teacher/settings`, `/teacher/sessions`.

El mapa complet de rutes és a `.minispec/core/architecture.md`.
