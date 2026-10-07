---
title: Tests
parent: Guia del professor
nav_order: 2
lang: ca
permalink: /teacher/tests/
---

# Triar i revisar el test

Cas d'ús <span class="uc-id">T2</span>.
{: .fs-3 }

**Tests** mostra tots els tests de Teuton trobats a la carpeta amb què has engegat el panell: nom, ruta, cases fixos de `config.yaml` i alumnes registrats.

{% include screenshot.html file="teacher-tests" alt="Pàgina de tests amb la sortida de teuton check" %}

## Activar un test

Prem **Activa** al costat d'un test. El panell demana confirmació, perquè canviar de test:

- atura qualsevol execució en marxa;
- fa que l'alta, les execucions i els resultats passin a referir-se al nou test.

En activar un test, el panell el prepara per a l'alta:

- afegeix `tt_include: config.d` a `config.yaml` com a text, conservant els teus comentaris (o crea `config.yaml` si no existeix);
- crea la carpeta `config.d/`, on cada alumne registrat té un fitxer;
- proposa els camps de l'alta a partir de `teuton config` si el test encara no té `teuton-panel-params.yaml`.

{: .note }
Els alumnes registrats en un test pertanyen a aquell test: en activar-ne un altre, els seus codis deixen de funcionar fins que hi tornis.

## Revisar un test

Prem **Executa teuton check** per veure l'informe del mateix Teuton sobre `start.rb` i `config.yaml`: grups, objectius, màquines i paràmetres. Fes-ho abans de la classe per detectar errors al test.
