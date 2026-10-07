---
title: Casos de uso
nav_order: 5
lang: es
permalink: /use-cases/
---

# Casos de uso
{: .no_toc }

Todos los casos de uso de teuton-panel y dónde se explica cada uno. Todos se comprueban automáticamente contra el reto de ejemplo con `rake usecases` (ver [Pruebas]({{ site.baseurl }}/developers/testing/)).

1. TOC
{:toc}

## Profesor

| Id | Caso de uso | Guía |
| --- | --- | --- |
| <span class="uc-id">T1</span> | Arrancar el panel y ver dónde se conectan los alumnos | [Arrancar el panel]({{ site.baseurl }}/teacher/start/) |
| <span class="uc-id">T2</span> | Elegir el test activo y revisarlo con `teuton check` | [Tests]({{ site.baseurl }}/teacher/tests/) |
| <span class="uc-id">T3</span> | Definir los campos del alta (preguntados, IP automática, valores fijos) | [Campos del alta]({{ site.baseurl }}/teacher/registration/) |
| <span class="uc-id">T4</span> | Gestionar alumnos: editar, desactivar, activar, borrar, dar un código | [Alumnos]({{ site.baseurl }}/teacher/students/) |
| <span class="uc-id">T5</span> | Ejecutar el test una vez, varias veces o cada T segundos, para todos o una selección, hasta una hora; pararlo | [Ejecutar el test]({{ site.baseurl }}/teacher/runs/) |
| <span class="uc-id">T6</span> | Consultar el histórico de ejecuciones y el detalle de cada una | [Ejecutar el test]({{ site.baseurl }}/teacher/runs/#histórico-de-ejecuciones) |
| <span class="uc-id">T7</span> | Seguir los resultados, ver el detalle de un alumno, usar el modo proyector | [Resultados]({{ site.baseurl }}/teacher/results/) |
| <span class="uc-id">T8</span> | Exportar las notas a Moodle (`moodle.csv`) | [Resultados]({{ site.baseurl }}/teacher/results/#exportar-a-moodle) |
| <span class="uc-id">T9</span> | Ver el enunciado que leen los alumnos | [Enunciado]({{ site.baseurl }}/teacher/statement/) |
| <span class="uc-id">T10</span> | Archivar una sesión de clase y consultar las archivadas | [Sesiones de clase]({{ site.baseurl }}/teacher/sessions/) |
| <span class="uc-id">T11</span> | Configurar el panel: funciones y formatos de alumnos, intervalo de ejecución, idioma, direcciones, IPs de profesor | [Ajustes]({{ site.baseurl }}/teacher/settings/) |
| <span class="uc-id">T12</span> | Abrir el área del profesor desde otro ordenador | [Arrancar el panel]({{ site.baseurl }}/teacher/start/#abrir-el-área-del-profesor-desde-otro-ordenador) |

## Alumno

| Id | Caso de uso | Guía |
| --- | --- | --- |
| <span class="uc-id">S1</span> | Registrarse (navegador o terminal) y obtener un código personal | [Registrarse]({{ site.baseurl }}/students/register/) |
| <span class="uc-id">S2</span> | Corregir mis datos de registro | [Registrarse]({{ site.baseurl }}/students/register/#corregir-tus-datos) |
| <span class="uc-id">S3</span> | Abrir mi página con mi código | [Mi página]({{ site.baseurl }}/students/my-page/) |
| <span class="uc-id">S4</span> | Ejecutar mi propio test | [Mi página]({{ site.baseurl }}/students/my-page/#ejecutar-tu-test) |
| <span class="uc-id">S5</span> | Ver mi última nota y, si está activado, cada objetivo | [Mi página]({{ site.baseurl }}/students/my-page/#tus-resultados) |
| <span class="uc-id">S6</span> | Ver mi histórico de notas | [Mi página]({{ site.baseurl }}/students/my-page/#tu-histórico) |
| <span class="uc-id">S7</span> | Comprobar si el panel llega a mi máquina | [Mi página]({{ site.baseurl }}/students/my-page/#tu-conexión) |
| <span class="uc-id">S8</span> | Leer el enunciado del test | [Enunciado]({{ site.baseurl }}/students/statement/) |
| <span class="uc-id">S9</span> | Ver quién está registrado | [Registrarse]({{ site.baseurl }}/students/register/#quién-está-registrado) |
| <span class="uc-id">S10</span> | Hacerlo todo desde un terminal, en texto o JSON | [Desde un terminal]({{ site.baseurl }}/students/terminal/) |

## Situaciones y qué hace el panel

| Situación | Qué pasa |
| --- | --- |
| Un alumno llega tarde | Se registra y entra en la siguiente ejecución, sin reiniciar nada. |
| Un alumno se registra desde la máquina equivocada (`AUTO IP`) | Se guarda una IP incorrecta; el profesor la corrige en Alumnos → Editar, o hace el campo "Preguntar". |
| Un alumno olvida su código | El profesor lo busca en Alumnos. |
| Un alumno se registra dos veces | Recibe dos códigos; el profesor borra el registro sobrante. |
| Un alumno falta a clase | El profesor lo desactiva: queda fuera de las ejecuciones y conserva su última nota. |
| Un alumno vuelve a ejecutar demasiado pronto | Se le dice cuántos segundos debe esperar. |
| El profesor ejecuta la clase periódicamente | A quien pulsa Ejecutar se le dice cuándo lo evaluará la próxima pasada. |
| La máquina de un alumno está apagada o SSH rechaza sus credenciales | El resultado muestra un problema de conexión; el alumno lo ve en Estado de la conexión. |
| Dos alumnos entregan la misma respuesta | La comprobación `unique` de Teuton pone un 0 y el panel explica por qué. |
| Un alumno escribe comillas o símbolos en un campo | Se rechaza el valor con una explicación; nada llega a Teuton. |
| Un alumno abre un código desconocido | Se le dice que el código es desconocido y se le envía al alta. |
| El profesor desactiva una función o un formato | Esa página responde "no activada" o indica los formatos disponibles. |
| El profesor cierra la zona de alumnos | Todas las páginas de alumno responden que la zona está cerrada. |
| Alguien abre el área del profesor desde otro ordenador | 403, salvo que su IP esté en la lista de profesores. |
| Hay varios tests y ninguno activo | El inicio del profesor pide elegir un test. |
| La carpeta del test activo se renombra o se mueve | El panel lo olvida al arrancar y elige el único test si solo hay uno. |
| El profesor cambia de test activo | Se paran las ejecuciones; los registros del test anterior se conservan para cuando vuelva a estar activo. |
| Empieza una clase nueva | El profesor archiva la sesión y empieza de cero. |
