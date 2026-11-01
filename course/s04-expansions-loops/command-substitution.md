La semana pasada guardamos el número de líneas de un fichero en una variable.
Veamos ahora el mecanismo con calma.

La **sustitución de comandos** `$(orden)` ejecuta la orden y se sustituye por lo que esta escribe en la salida estándar, sin los saltos de línea finales:

```bash
hoy=$(date +%F)
lineas=$(wc -l < notas.csv)
echo "El $hoy, notas.csv tiene $lineas líneas"
```

Como cualquier otra expansión, sin comillas su resultado se parte en palabras.
Por eso, al usarla como argumento, la escribimos entre comillas dobles: `echo "$(date)"`.
A veces, la partición es justo lo que se busca, porque convierte las líneas de una salida en argumentos del comando.
`wc -c $(find proyecto -name '*.[ch]')` hace lo mismo que `find proyecto -name '*.[ch]' | xargs wc -c`, de [Tuberías](../s03-pipes/pipes.md), y tiene el mismo problema: un nombre con espacios llega partido en argumentos diferentes.

La sustitución de comandos se puede anidar sin problemas, por ejemplo: `$(basename "$(pwd)")`.
`basename` deja el último componente de una ruta (`basename /home/alu/ssoo` escribe `ssoo`), y `dirname`, lo que va antes (`/home/alu`).

En *scripts* antiguos verás la forma `` `orden` `` de la sustitución de comandos, con acentos graves, que hace lo mismo pero no se anida bien.
