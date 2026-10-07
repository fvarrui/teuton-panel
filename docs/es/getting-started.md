---
title: Primeros pasos
nav_order: 2
lang: es
permalink: /getting-started/
---

# Primeros pasos
{: .no_toc }

1. TOC
{:toc}

## Requisitos

- Ruby 3.2.8 o posterior. En Windows basta con [RubyInstaller](https://rubyinstaller.org/); no hace falta el kit MSYS2.
- La gema `teuton` 3.x, que se instala con el panel.
- Un test de Teuton: una carpeta con un `start.rb`. Créalo con `teuton new CARPETA` o usa el ejemplo de más abajo.
- Máquinas de alumnos accesibles desde el ordenador del profesor, como necesita Teuton (normalmente por SSH).

## Instalación

```bash
gem install teuton-panel
```

También puedes descargar el fichero `.gem` desde la [página de releases](https://github.com/fvarrui/teuton-panel/releases) e instalarlo con `gem install teuton-panel-<versión>.gem`.

{: .note }
Si después de instalar no se encuentra el comando `teuton-panel`, la carpeta de ejecutables de las gemas no está en tu `PATH`. Búscala con `gem env` ("EXECUTABLE DIRECTORY") y añádela.

## Arrancar el panel

```bash
teuton-panel up RUTA/A/LOS/TESTS
```

`RUTA/A/LOS/TESTS` es una carpeta con uno o varios tests de Teuton (carpetas con un `start.rb`); si no la indicas, se usa la carpeta actual. `teuton-panel RUTA/A/LOS/TESTS` hace lo mismo.

El panel comprueba que Teuton 3 está instalado, crea su fichero de configuración (`teuton-panel.yaml`) y muestra dónde conectarse:

```
------------------------------------------------------------
teuton-panel 0.2.0
Base dir    : /home/profesor/tests
Active test : network-basics
Teacher     : http://localhost:4567/teacher
Students    : http://192.168.1.10:4567/students
  curl help : curl http://192.168.1.10:4567/students.txt
------------------------------------------------------------
```

Abre la dirección **Teacher** en tu ordenador y da la dirección **Students** a la clase. Para el panel con `Ctrl+C`; también se paran los procesos de Teuton en marcha.

## Pruébalo con el reto de ejemplo

El código fuente incluye un reto listo para probar, con siete alumnos inventados y un histórico de clase inventado. Se ejecuta en `localhost`, así que no hacen falta máquinas de alumnos:

```bash
git clone https://github.com/fvarrui/teuton-panel
cd teuton-panel
ruby samples/linux-files-basics/reset.rb
teuton-panel up samples/linux-files-basics
```

Todas las capturas de esta guía se han hecho con este ejemplo. Vuelve a ejecutar `reset.rb` cuando quieras empezar la demo desde cero.

## Una clase en cinco pasos

1. Arranca el panel y abre el área del profesor ([Arrancar el panel]({{ site.baseurl }}/teacher/start/)).
2. Activa el test y revisa los campos del alta ([Tests]({{ site.baseurl }}/teacher/tests/), [Campos del alta]({{ site.baseurl }}/teacher/registration/)).
3. Muestra la dirección de alumnos; los alumnos se registran y obtienen su código personal ([Registrarse]({{ site.baseurl }}/students/register/)).
4. Lanza una ejecución periódica ([Ejecutar el test]({{ site.baseurl }}/teacher/runs/)).
5. Sigue la clase en el proyector ([Resultados]({{ site.baseurl }}/teacher/results/)) y archiva la sesión al terminar ([Sesiones de clase]({{ site.baseurl }}/teacher/sessions/)).
