---
title: Alumnes
parent: Guia del professor
nav_order: 4
lang: ca
permalink: /teacher/students/
---

# Gestionar alumnes

Cas d'ús <span class="uc-id">T4</span>.
{: .fs-3 }

**Alumnes** llista tots els registrats al test actiu i s'actualitza cada 15 segons: nom, codi personal, IP des de la qual es va registrar, hora, última nota i estat.

{% include screenshot.html file="teacher-students" alt="Pàgina d'alumnes" %}

Els codis personals només es mostren aquí. Si un alumne oblida el seu codi, busca'l i digues-l'hi.

## Editar un alumne

**Edita** obre tots els valors del case de l'alumne. Desa per corregir una IP equivocada, una errada al nom o qualsevol altre valor; la propera execució fa servir els valors nous.

{% include screenshot.html file="teacher-student-edit" alt="Editar un alumne" %}

Als valors que canvies s'hi apliquen les mateixes regles que a l'alta (lletres, números, espais i `. _ - @ : /`), i els camps de màquina que escriuen els alumnes no poden apuntar a l'ordinador del panell. Els valors que deixes com estaven sempre s'accepten.

## Desactivar o activar

**Desactiva** pausa un alumne (per exemple, perquè avui no ha vingut):

- queda fora de totes les execucions, teves o seves;
- conserva la seva última nota, que apareix com a *Desactivat*;
- pot continuar obrint la seva pàgina i els seus resultats, però no se li ofereix **Executa el meu test**.

**Activa** el torna a la classe.

## Esborrar

**Esborra** elimina el registre (el fitxer de l'alumne a `config.d/`). El seu codi deixa de funcionar; es pot tornar a registrar.

## Cases sense codi

També hi apareixen els cases escrits a mà:

- **A `config.yaml` (`cases:`)**: s'avaluen amb la classe, però els alumnes no els poden fer servir des de la seva àrea.
- **Fitxers de `config.d/` sense codi**: **Dona un codi** els converteix en registres normals, perquè l'alumne pugui fer servir la seva pàgina personal.
