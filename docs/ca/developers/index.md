---
title: Desenvolupadors
nav_order: 7
has_children: true
lang: ca
permalink: /developers/
---

# Desenvolupadors

teuton-panel és una gemma de Ruby petita: un CLI amb Thor i una aplicació Sinatra servida per WEBrick, que dirigeix l'ordre `teuton` i llegeix els seus informes JSON. Tot és Ruby pur: sense base de dades, sense compilació de JavaScript i sense necessitat de compilador.

- [Arquitectura]({{ site.baseurl }}/developers/architecture/): com encaixen les peces.
- [Entorn de desenvolupament]({{ site.baseurl }}/developers/setup/): executar-lo des del codi font, l'exemple i aquesta documentació.
- [Proves]({{ site.baseurl }}/developers/testing/): tests unitaris i web, la bateria de casos d'ús i les captures.
- [Traduccions]({{ site.baseurl }}/developers/translations/): els idiomes de la interfície i de la documentació.
- [Contribuir]({{ site.baseurl }}/developers/contributing/): estil de codi, especificacions i pull requests.
- [Notes de disseny]({{ site.baseurl }}/developers/notes/): les notes originals que van donar origen al projecte (en anglès).

Les decisions de disseny i les especificacions són a la carpeta `.minispec/` del repositori (`core/` per al coneixement permanent, `decisions/` per als ADR).
