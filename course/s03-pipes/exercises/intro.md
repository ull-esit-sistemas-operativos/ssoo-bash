Cada ejercicio abre su *script* en el editor, con el *shebang* y un comentario que dice qué hace, y un terminal en su propio directorio, con los datos de la semana.

1. Escribe el *script* debajo del comentario.
2. Pruébalo en el terminal, por ejemplo `bash cuenta.sh gato texto.txt`, también con nombres con espacios y con los casos de error.
3. Pulsa **Comprobar ejercicio**, o ejecuta `check` en el terminal.

La comprobación tiene dos partes:

- ***shellcheck*.** Los errores, las advertencias y los avisos, como una variable sin comillas, hacen fallar el ejercicio.
  Las sugerencias de estilo salen bajo «Avisos» y no lo hacen fallar, pero conviene seguirlas, como usar `$(...)` en lugar de comillas invertidas.
- **Pruebas.** Ejecutan tu *script* sobre una copia nueva de los datos y comprueban lo que muestra, su código de salida y los ficheros que crea.
  El nombre de cada prueba dice qué se espera; si falla, debajo aparece lo que se esperaba y lo que se ha obtenido.
