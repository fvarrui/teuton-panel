---
title: Primers passos
nav_order: 2
lang: ca
permalink: /getting-started/
---

# Primers passos
{: .no_toc }

1. TOC
{:toc}

## Requisits

- Ruby 3.2.8 o posterior. A Windows n'hi ha prou amb [RubyInstaller](https://rubyinstaller.org/); no cal el kit MSYS2.
- La gemma `teuton` 3.x, que s'instal·la amb el panell.
- Un test de Teuton: una carpeta amb un `start.rb`. Crea'l amb `teuton new CARPETA` o fes servir l'exemple de més avall.
- Màquines d'alumnes accessibles des de l'ordinador del professor, tal com necessita Teuton (normalment per SSH).

## Instal·lació

```bash
gem install teuton-panel
```

També pots descarregar el fitxer `.gem` de la [pàgina de releases](https://github.com/fvarrui/teuton-panel/releases) i instal·lar-lo amb `gem install teuton-panel-<versió>.gem`.

{: .note }
Si després d'instal·lar no es troba l'ordre `teuton-panel`, la carpeta d'executables de les gemmes no és al teu `PATH`. Busca-la amb `gem env` ("EXECUTABLE DIRECTORY") i afegeix-la.

## Engegar el panell

```bash
teuton-panel up RUTA/ALS/TESTS
```

`RUTA/ALS/TESTS` és una carpeta amb un o més tests de Teuton (carpetes amb un `start.rb`); si no la indiques, es fa servir la carpeta actual. `teuton-panel RUTA/ALS/TESTS` fa el mateix.

El panell comprova que Teuton 3 està instal·lat, crea el seu fitxer de configuració (`teuton-panel.yaml`) i mostra on connectar-se:

```
------------------------------------------------------------
teuton-panel 0.2.0
Base dir    : /home/professor/tests
Active test : network-basics
Teacher     : http://localhost:4567/teacher
Students    : http://192.168.1.10:4567/students
  curl help : curl http://192.168.1.10:4567/students.txt
------------------------------------------------------------
```

Obre l'adreça **Teacher** al teu ordinador i dona l'adreça **Students** a la classe. Atura el panell amb `Ctrl+C`; també s'aturen els processos de Teuton en marxa.

## Prova-ho amb el repte d'exemple

El codi font inclou un repte a punt per provar, amb set alumnes inventats i un històric de classe inventat. S'executa a `localhost`, així que no calen màquines d'alumnes:

```bash
git clone https://github.com/fvarrui/teuton-panel
cd teuton-panel
ruby samples/linux-files-basics/reset.rb
teuton-panel up samples/linux-files-basics
```

Totes les captures d'aquesta guia s'han fet amb aquest exemple. Torna a executar `reset.rb` quan vulguis començar la demo des de zero.

## Una classe en cinc passos

1. Engega el panell i obre l'àrea del professor ([Engegar el panell]({{ site.baseurl }}/teacher/start/)).
2. Activa el test i revisa els camps de l'alta ([Tests]({{ site.baseurl }}/teacher/tests/), [Camps de l'alta]({{ site.baseurl }}/teacher/registration/)).
3. Mostra l'adreça d'alumnes; els alumnes es registren i obtenen el seu codi personal ([Registrar-se]({{ site.baseurl }}/students/register/)).
4. Engega una execució periòdica ([Executar el test]({{ site.baseurl }}/teacher/runs/)).
5. Segueix la classe al projector ([Resultats]({{ site.baseurl }}/teacher/results/)) i arxiva la sessió en acabar ([Sessions de classe]({{ site.baseurl }}/teacher/sessions/)).
