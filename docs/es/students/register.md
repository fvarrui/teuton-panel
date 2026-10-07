---
title: Registrarse
parent: Guía del alumno
nav_order: 1
lang: es
permalink: /students/register/
---

# Registrarse y obtener tu código personal
{: .no_toc }

Casos de uso <span class="uc-id">S1</span> registrarse, <span class="uc-id">S2</span> corregir tus datos, <span class="uc-id">S9</span> ver quién está registrado.
{: .fs-3 }

1. TOC
{:toc}

## Registrarse

Abre **Registrarme** (o `/students/register`) y rellena los campos que eligió tu profesor: normalmente tu nombre, tu correo y algún dato de tu máquina. Debajo de un campo puedes encontrar una breve ayuda escrita por tu profesor.

{% include screenshot.html file="students-register" alt="Formulario de alta" %}

{: .tip }
Si un campo se rellena solo con tu IP, regístrate **desde la máquina que se va a evaluar**. Si no, pide a tu profesor que lo corrija.

Si algo está mal, el formulario te dice qué campo corregir:

{% include screenshot.html file="students-register-errors" alt="Formulario de alta con errores" %}

- Los campos obligatorios no pueden quedar vacíos.
- El correo tiene que parecer un correo.
- Los valores escritos solo admiten letras, números, espacios y `. _ - @ : /` (salvo las contraseñas), hasta 100 caracteres.
- La dirección de una máquina no puede ser el propio ordenador del panel.

## Tu código personal

Al registrarte recibes un **código personal** y tu dirección personal:

{% include screenshot.html file="students-registered" alt="Alta completada: el código personal" %}

**Guarda el código**: lo necesitas para ejecutar tu test y ver tus resultados. Si lo pierdes, pídeselo a tu profesor, que ve todos los códigos. Tu página personal es `/students/<código>`; puedes guardarla en marcadores. El navegador también recuerda tu código: el menú muestra **Mi página** en lugar de **Registrarme**, y el inicio rellena tu código.

## Corregir tus datos

Si escribiste algo mal, abre tu página, cambia los valores en **Mis datos** y pulsa **Guardar mis datos**. Los valores anteriores se sustituyen. Deja vacío un campo de contraseña para mantener la actual.

## Quién está registrado

El inicio de alumnos lista los nombres de todos los registrados (sin códigos ni otros datos), para que compruebes que estás dentro. Tu profesor puede ocultar esta lista.
