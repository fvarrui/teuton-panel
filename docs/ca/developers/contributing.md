---
title: Contribuir
parent: Desenvolupadors
nav_order: 5
lang: ca
permalink: /developers/contributing/
---

# Contribuir

- **Idioma**: el codi, els comentaris, els commits i les especificacions van en anglès; els textos per a l'usuari són als fitxers d'idioma (anglès, castellà i català).
- **Estil de codi**: Ruby escrit com l'escriu el mantenidor de Teuton (classes petites i procedimentals, `require_relative`, clàusules de guarda, `puts`/`warn` i `exit 1` per als errors del CLI), revisat amb Standard. Les regles són a `.claude/skills/dvarrui-ruby-style/`.
- **Especificacions**: el projecte fa servir MiniSpec. Llegeix primer `.minispec/README.md`; el coneixement permanent és a `.minispec/core/`, les decisions a `.minispec/decisions/` i la feina en curs a `.minispec/features/` (s'esborra en acabar).
- **Senzillesa**: Sinatra sense més, cap dependència nova sense motiu, res que necessiti compilador de C, eines en Ruby pur.
- **Seguretat**: els valors que escriuen els alumnes arriben a les ordres dels tests de Teuton; mantén estricte `Registration.value_error` i no mostris mai els informes en brut als alumnes.
- **Abans d'una pull request**: `bundle exec rake`, `bundle exec rake usecases` i, després de canvis visuals, `bundle exec rake docs:screenshots`.
- **Commits**: curts, en minúscules, amb prefix de tipus (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`).

Les pull requests són benvingudes a [dvarrui/teuton-panel](https://github.com/dvarrui/teuton-panel).
