Un problema frecuente es determinar qué elementos de una lista no están en otra.
Por ejemplo, qué matriculados no aparecen en el fichero de notas.

`comm` compara dos ficheros ordenados y escribe tres columnas: líneas solo del primero, solo del segundo y comunes.
Las opciones `-1`, `-2` y `-3` ocultan cada columna, así que `comm -23 a b` deja solo lo que está en `a` y no en `b`.
Si los ficheros no están ordenados, el resultado es incorrecto.

Si el contenido de `a` y `b` no está en ficheros, sino que es la salida de otros comandos, no hace falta crear ficheros intermedios.
Basta con la sustitución de procesos de la semana 4, `<(orden)`, que pone en lugar de la orden el nombre de un fichero del que se lee su salida.

```console
$ comm -23 <(sort alumnos.txt) <(tail -n +2 notas.csv | cut -d, -f1 | sort -u)
sara
```

Otra forma de obtener lo mismo es `grep -vxFf conocidos.txt todos.txt`, que da las líneas de `todos.txt` que no coinciden exactamente (`-x`) con ninguna de las de `conocidos.txt`, tratadas como texto fijo (`-F`).
No exige ordenar.
