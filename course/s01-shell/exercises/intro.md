Cada ejercicio abre su *script* en el editor, con el *shebang* y un comentario que dice qué hace, y un terminal en su propio directorio, con los datos de la semana: `notas.csv` y el directorio `proyecto`.

1. Escribe el *script* debajo del comentario.
2. Pruébalo en el terminal, por ejemplo `bash ver.sh notas.csv`, también con un nombre con espacios y con un fichero que no existe.
   Si le das permiso de ejecución con `chmod +x ver.sh`, también puedes ejecutarlo como `./ver.sh notas.csv`.
3. Pulsa **Comprobar ejercicio**, o ejecuta `check` en el terminal.

La comprobación tiene dos partes:

- ***shellcheck*.** Revisa el *script* en busca de errores frecuentes, como una variable sin comillas, y los que encuentra hacen fallar el ejercicio.
  Las sugerencias de estilo salen bajo «Avisos» y no lo hacen fallar.
- **Pruebas.** Ejecutan tu *script* sobre una copia nueva de los datos y comprueban lo que muestra y su estado de salida.
  El nombre de cada prueba dice qué se espera; si falla, debajo aparece lo que se esperaba y lo que se ha obtenido.

Esta semana los *scripts* no comprueban sus argumentos: si algo falla, el error lo muestra el comando que falla, y el *script* termina con el estado de su última orden.
