Cada ejercicio abre su *script* en el editor, con el *shebang* y un comentario que dice qué hace, y un terminal en su propio directorio, con `acceso.log`.

Empieza cada *script* por la estructura de «El script completo»: `set -eu`, la configuración, las funciones, las opciones, las comprobaciones y el trabajo.
Los mensajes de error empiezan por el nombre del *script*, como `codigo.sh: falta el log`, y van al error estándar.

1. Escribe el *script* debajo del comentario.
2. Pruébalo en el terminal, por ejemplo `bash codigo.sh -c 200 acceso.log`, también con las opciones en otro orden, con nombres con espacios y con los casos de error.
   Si algo no hace lo que esperas, ejecútalo con `bash -x`.
3. Pulsa **Comprobar ejercicio**, o ejecuta `check` en el terminal.

La comprobación tiene dos partes:

- ***shellcheck*.** Los errores, las advertencias y los avisos, como una variable sin comillas, hacen fallar el ejercicio.
  Las sugerencias de estilo salen bajo «Avisos» y no lo hacen fallar, pero conviene seguirlas.
- **Pruebas.** Ejecutan tu *script* sobre una copia nueva de los datos y comprueban lo que muestra, su código de salida y los ficheros que cambia o deja.
  El nombre de cada prueba dice qué se espera; si falla, debajo aparece lo que se esperaba y lo que se ha obtenido.
