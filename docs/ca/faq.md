---
title: Preguntes freqüents
nav_order: 6
lang: ca
permalink: /faq/
---

# Preguntes freqüents i problemes
{: .no_toc }

1. TOC
{:toc}

## Els alumnes no poden obrir l'adreça

- Comprova que el tallafoc de l'ordinador permet connexions entrants al port del panell (4567 per defecte).
- Assegura't que els alumnes fan servir una de les adreces de l'inici del professor. Si l'ordinador té diversos adaptadors de xarxa, indica la bona a Configuració → **Adreces que es mostren als alumnes**.
- Alumnes i professor han d'estar a la mateixa xarxa.

## "teuton 3.x is required"

El panell necessita la gemma `teuton` 3.x: `gem install teuton -v "~> 3.0"`.

## "No Teuton tests found"

La carpeta amb què has engegat el panell no té cap `start.rb`, ni en ella ni a les seves subcarpetes. Crea un test amb `teuton new CARPETA` o engega el panell des de la carpeta correcta.

## Un alumne sempre treu 0 amb un problema de connexió

Obre el seu estat de connexió (o el detall del resultat): la màquina pot estar apagada, la seva IP pot ser incorrecta (corregeix-la a Alumnes → Edita) o SSH pot rebutjar l'usuari o la contrasenya.

## Una execució no mostra informes

Obre-la a **Històric** per llegir la sortida de Teuton; s'hi veuen els errors de `start.rb` o `config.yaml`. **Tests → Executa teuton check** també ajuda.

## Puc fer servir `tt_skip` o `teuton run --case`?

No amb Teuton 3.0.0: tots dos fan fallar Teuton ([teuton#44](https://github.com/teuton-software/teuton/issues/44)). Fes servir **Desactiva** a Alumnes o marca només alguns alumnes a Executa; el panell construeix la seva pròpia configuració i no els fa servir mai. Evita també els valors que siguin taules (hash) a la secció `global:` de `config.yaml`.

## Poden els alumnes veure dades d'altres alumnes o contrasenyes?

No. Els alumnes només veuen noms a la llista de registrats, i només el seu propi codi, nota i dades (amb les contrasenyes amagades). Mai no se'ls mostren els informes de Teuton en brut.

## On es guarda tot?

- `teuton-panel.yaml`: configuració del panell (carpeta base).
- `config.d/`: un fitxer per alumne registrat (al costat del `config.yaml` del test).
- `teuton-panel-params.yaml`: camps de l'alta (al costat de `config.yaml`).
- `.teuton-panel/`: execucions, resultats i sessions arxivades (carpeta base).

## Què obre l'adreça del panell sense ruta?

Depèn de qui la demani. A l'ordinador del professor (o a una IP de professor permesa), `http://<panell>:4567/` obre l'àrea del professor. El navegador d'un alumne obre l'inici d'alumnes, i `curl` imprimeix l'ajuda en text pla, la mateixa que `/students.txt`.

## Com començo una classe nova?

**Sessions → Arxiva i comença una sessió nova**. No s'esborra res; les sessions anteriors es poden obrir més endavant.
