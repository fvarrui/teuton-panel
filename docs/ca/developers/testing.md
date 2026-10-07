---
title: Proves
parent: Desenvolupadors
nav_order: 3
lang: ca
permalink: /developers/testing/
---

# Proves
{: .no_toc }

1. TOC
{:toc}

## Tests unitaris i web

```bash
bundle exec rake test
bundle exec ruby -Itest -Ilib test/teuton/panel/app_test.rb -n "/register/"
```

Els tests fan servir test-unit i Rack::Test. `runner_test.rb` i `app_test.rb` executen l'ordre `teuton` real sobre el test sandbox, així que la bateria triga un o dos minuts. Rack::Test permet que un test simuli venir d'una altra IP (`"REMOTE_ADDR" => "192.168.1.50"`), i així es prova l'àrea exclusiva del professor.

## Bateria de casos d'ús

```bash
bundle exec rake usecases
```

`test/usecases/run.rb` copia el repte d'exemple, engega l'aplicació al mateix procés i recorre tots els casos d'ús de professor i alumne (T1–T12, S1–S10 i les situacions de [Casos d'ús]({{ site.baseurl }}/use-cases/)) a través de Rack, amb l'ordre `teuton` real: unes 90 comprovacions. Acaba amb codi 1 si en falla alguna, així que es pot fer servir en integració contínua.

## Captures

```bash
bundle exec rake docs:screenshots
```

`docs/_scripts/screenshots.rb` engega el panell real sobre una còpia de l'exemple, prepara cada estat (una execució periòdica, una alta amb errors, un alumne desactivat, una sessió arxivada…) i captura cada pàgina en anglès, castellà i català amb Chrome o Edge sense finestra (`CHROME=ruta` per triar-lo). Executa'l després de qualsevol canvi visual.

## Estil

El projecte segueix [Standard Ruby](https://github.com/standardrb/standard) (`bundle exec rake standard`).
