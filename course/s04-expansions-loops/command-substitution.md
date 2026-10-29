La semana pasada guardamos el número de líneas de un fichero en una variable.
Veamos ahora el mecanismo con calma.

La **sustitución de comandos** `$(comando)` ejecuta el comando y se sustituye por lo que este escribe en la salida estándar, sin los saltos de línea finales:

```bash
hoy=$(date +%F)
lineas=$(wc -l < notas.csv)
echo "El $hoy, notas.csv tiene $lineas líneas"
```

Como cualquier otra expansión, sin comillas su resultado se parte en palabras.
Por eso, al usarla como argumento, la escribimos entre comillas dobles: `echo "$(date)"`.
Se puede anidar sin problemas: `$(basename "$(pwd)")`.
En *scripts* antiguos verás la forma `` `comando` `` con acentos graves, que hace lo mismo pero no se anida bien.
