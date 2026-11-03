Ocho *scripts* de repaso que reúnen lo de todo el curso, ordenados de menos a más difíciles.
Cada uno abre su *script* en el editor, con el *shebang* y un comentario que dice qué hace, y una terminal en su propio directorio, con `notas.csv`, `alumnos.txt`, `acceso.log` y el directorio `proyecto`.

Los dos primeros ejercicios son lo esencial de la semana; los demás, práctica adicional.

Trabaja como en el examen:

1. Lee el enunciado y relaciona cada requisito con una competencia y un patrón, como en «Cómo abordar un problema».
2. Empieza desde «El esqueleto» y escribe el *script* debajo del comentario.
3. Pruébalo en la terminal con los ejemplos, con nombres con espacios y con cada error de la tabla, y repasa «Antes de darlo por terminado».
4. Pulsa **Comprobar ejercicio**, o ejecuta `check` en la terminal.

La comprobación tiene dos partes:

- ***shellcheck*.** Revisa el *script* en busca de errores frecuentes, como una variable sin comillas, y los que encuentra hacen fallar el ejercicio.
  Las sugerencias de estilo salen bajo «Avisos» y no lo hacen fallar, pero conviene seguirlas.
- **Pruebas.** Ejecutan tu *script* sobre una copia nueva de los datos, con la configuración regional en español, y comprueban lo que muestra, su código de salida y los ficheros que crea.
  El nombre de cada prueba dice qué se espera; si falla, debajo aparece lo que se esperaba y lo que se ha obtenido.

Los mensajes de error empiezan por el nombre del *script*, como `boletin.sh: falta el fichero de notas`, y van al error estándar.
