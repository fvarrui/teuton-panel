---
title: Camps de l'alta
parent: Guia del professor
nav_order: 3
lang: ca
permalink: /teacher/registration/
---

# Camps de l'alta

Cas d'ús <span class="uc-id">T3</span>.
{: .fs-3 }

**Camps de l'alta** decideix què omplen els alumnes en registrar-se. Cada fila és un valor del case de l'alumne a Teuton (les claus que el teu `start.rb` llegeix amb `get(...)` i la configuració de les màquines) i la manera d'obtenir-lo.

{% include screenshot.html file="teacher-registration" alt="Editor dels camps de l'alta" %}

| Mode | Què passa |
| --- | --- |
| **Preguntar com a nom** (`AS NAME`) | Es pregunta a l'alumne amb l'etiqueta "El teu nom". Fes-lo servir per a `tt_members`. |
| **Preguntar com a correu** (`AS EMAIL`) | Es pregunta i es comprova que sigui un correu. Fes-lo servir per a `tt_moodle_id` i tindràs `moodle.csv`. |
| **Preguntar** (`ASK`) | Es pregunta com a text lliure. |
| **Automàtic: IP de l'alumne** (`AUTO IP`) | No es pregunta: la IP de la màquina des de la qual es registra l'alumne. |
| **Valor fix** | No es pregunta: el mateix valor per a tothom (per exemple, un usuari comú o `localhost`). |

- **Valor fix** només es fa servir amb el mode *Valor fix*; per als altres modes, la columna apareix atenuada.
- **Etiqueta per als alumnes** i **Ajuda per als alumnes** substitueixen el nom del camp al formulari d'alta i a *Les meves dades* (per exemple, `home` → etiqueta *La teva carpeta personal*, ajuda *El nom de la teva carpeta a homes/*). Sense etiqueta, els camps de nom i de correu diuen *El teu nom* i *El teu correu*, i la resta mostren el nom del camp fet llegible. Els alumnes mai no veuen les claus en brut.
- Per afegir un camp, omple l'última fila buida i prem **Desa**.
- Per treure'n un, marca **Treu** i prem **Desa**.
- **Proposa des de teuton config** substitueix els camps per una proposta feta a partir del teu test: tots els valors que necessita, `tt_members` com a nom, `tt_moodle_id` com a correu i les IP de les màquines com a automàtiques.

Els camps es desen a `teuton-panel-params.yaml`, al costat del `config.yaml` del test, així que viatgen amb ell. Un camp amb etiqueta o ajuda s'escriu com a `home: {mode: "ASK", label: "La teva carpeta personal", help: "..."}`; la forma curta `home: "ASK"` continua funcionant.

Les etiquetes i les ajudes segueixen la mateixa regla de caràcters que els valors escrits (vegeu més avall); la pàgina t'indica quin camp has de corregir.

{: .warning }
`AUTO IP` només encerta si els alumnes es registren des de la màquina que s'avaluarà. Si es registren des d'un altre ordinador (per exemple, el navegador de l'amfitrió quan la màquina avaluada és una VM), fes que el camp sigui **Preguntar**, o corregeix la IP a [Alumnes]({{ site.baseurl }}/teacher/students/).

## Què poden escriure els alumnes

Per protegir les ordres que executa el teu test, els valors escrits només admeten lletres (amb accents), números, espais i `. _ - @ : /`, fins a 100 caràcters. Les contrasenyes només tenen el límit de longitud. Els camps de màquina mai accepten les adreces del mateix panell, així que un alumne no pot apuntar Teuton al teu ordinador.

{: .important }
Els valors escrits acaben dins de les ordres del teu test (`run "... #{get(:home)} ..."`). Si una màquina del teu test és `localhost`, aquestes ordres s'executen al **teu** ordinador: comprova els valors escrits a `start.rb` abans de fer-los servir, com fa l'exemple amb `home_dir`.
