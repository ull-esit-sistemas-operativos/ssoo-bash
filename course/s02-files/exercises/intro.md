Cada ejercicio abre su *script* en el editor, con el *shebang* y un comentario que dice qué hace, y un terminal en su propio directorio, con los datos de la semana: `notas.csv` y el directorio `proyecto`.

1. Escribe el *script* debajo del comentario.
   Empieza por comprobar los argumentos, como en el apartado «Variables y argumentos».
2. Pruébalo en el terminal, por ejemplo `bash fuentes.sh proyecto`, también con nombres con espacios y con los casos de error.
   Si un ejercicio cambia o borra ficheros, pruébalo sobre una copia: `cp -r proyecto prueba`.
3. Pulsa **Comprobar ejercicio**, o ejecuta `check` en el terminal.

La comprobación tiene dos partes:

- ***shellcheck*.** Revisa el *script* en busca de errores frecuentes, como una variable sin comillas, y los que encuentra hacen fallar el ejercicio.
  Las sugerencias de estilo salen bajo «Avisos» y no lo hacen fallar.
- **Pruebas.** Ejecutan tu *script* sobre una copia nueva de los datos y comprueban lo que muestra, su código de salida y los ficheros que crea, cambia o borra.
  El nombre de cada prueba dice qué se espera; si falla, debajo aparece lo que se esperaba y lo que se ha obtenido.

Si borras por error un fichero de datos, bórralo del todo y vuelve a abrir el ejercicio: se recupera.
