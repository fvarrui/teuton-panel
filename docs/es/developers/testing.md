---
title: Pruebas
parent: Desarrolladores
nav_order: 3
lang: es
permalink: /developers/testing/
---

# Pruebas
{: .no_toc }

1. TOC
{:toc}

## Tests unitarios y web

```bash
bundle exec rake test
bundle exec ruby -Itest -Ilib test/teuton/panel/app_test.rb -n "/register/"
```

Los tests usan test-unit y Rack::Test. `runner_test.rb` y `app_test.rb` ejecutan el comando `teuton` real sobre el test sandbox, así que la batería tarda uno o dos minutos. Rack::Test permite que un test simule venir de otra IP (`"REMOTE_ADDR" => "192.168.1.50"`), y así se prueba el área exclusiva del profesor.

## Batería de casos de uso

```bash
bundle exec rake usecases
```

`test/usecases/run.rb` copia el reto de ejemplo, arranca la aplicación en el mismo proceso y recorre todos los casos de uso de profesor y alumno (T1–T12, S1–S10 y las situaciones de [Casos de uso]({{ site.baseurl }}/use-cases/)) a través de Rack, con el comando `teuton` real: unas 90 comprobaciones. Termina con código 1 si alguna falla, así que puede usarse en integración continua.

## Capturas

```bash
bundle exec rake docs:screenshots
```

`docs/_scripts/screenshots.rb` arranca el panel real sobre una copia del ejemplo, prepara cada estado (una ejecución periódica, un alta con errores, un alumno desactivado, una sesión archivada…) y captura cada página en inglés, español y catalán con Chrome o Edge sin ventana (`CHROME=ruta` para elegirlo). Ejecútalo tras cualquier cambio visual.

## Estilo

El proyecto sigue [Standard Ruby](https://github.com/standardrb/standard) (`bundle exec rake standard`).
