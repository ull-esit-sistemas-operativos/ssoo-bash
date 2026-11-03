Cada ejercicio abre su *script* en el editor, con el *shebang* y un comentario que dice qué hace, y una terminal en su propio directorio, con los datos de la semana.

Los dos primeros ejercicios son lo esencial de la semana; los demás, práctica adicional.

Los procesos y las sesiones de tu equipo cambian a cada momento, así que los ejercicios trabajan con salidas guardadas, que dan siempre el mismo resultado:

- `ps.txt` es una salida de `ps -e -o pid,user,stat,comm`.
- `who.txt` es una salida de `who`.

Cuando el *script* funcione con ellas, pruébalo también con los datos reales: `ps -e -o pid,user,stat,comm > ahora.txt`.

«Límite de tiempo» es la excepción.
Lanza sus propios procesos, así que trabaja con procesos reales.

1. Escribe el *script* debajo del comentario.
2. Pruébalo en la terminal, por ejemplo `bash estados.sh ps.txt`, también con nombres con espacios y con los casos de error.
3. Pulsa **Comprobar ejercicio**, o ejecuta `check` en la terminal.

La comprobación tiene dos partes:

- ***shellcheck*.** Revisa el *script* en busca de errores frecuentes, como una variable sin comillas, y los que encuentra hacen fallar el ejercicio.
  Las sugerencias de estilo salen bajo «Avisos» y no lo hacen fallar, pero conviene seguirlas.
- **Pruebas.** Ejecutan tu *script* sobre una copia nueva de los datos y comprueban lo que muestra y su código de salida.
  El nombre de cada prueba dice qué se espera; si falla, debajo aparece lo que se esperaba y lo que se ha obtenido.
