En `ordenar.sh` repetimos casi la misma línea para cada extensión.
¿No podríamos escribir la acción una sola vez y aplicarla a cada fichero?

El bucle **`for`** ejecuta un bloque una vez por cada palabra de una lista, asignando cada palabra a una variable:

```bash
for asig in SSOO FP; do
    echo "Procesando $asig"
done
```

La lista puede venir de cualquier expansión:

- **Ficheros.**
  `for f in datos/*.csv` recorre las rutas que encajan.
  Cada ruta es una palabra, aunque tenga espacios, siempre que dentro del bucle usemos `"$f"` para que bash nunca parta la ruta.
  Si un patrón no encaja con ningún fichero, el bucle se ejecuta una vez con el patrón literal.
  Por eso conviene comprobar en el cuerpo del `for` que la ruta en `$f` existe.
- **Rangos.**
  `for i in {1..5}` o, si los límites están en variables, la forma aritmética `for (( i = 1; i <= n; i++ ))`.
- **Argumentos.**
  `for f in "$@"` recorre los argumentos del *script*.
  Con las comillas en `"$@"`, cada argumento es una palabra aunque tenga espacios, así que `./copiar.sh a.txt "mis notas.txt"` da dos vueltas al bucle con `a.txt` y `mis notas.txt`, no tres.
  Es una forma sencilla de procesar una lista de ficheros que nos pasan en la línea de comandos.
- **Salida de un comando.**
  `for asig in $(tail -n +2 notas.csv | cut -d, -f2 | sort -u)` funciona porque los nombres en `notas.csv` no tienen espacios —recuerda que `for` recorre palabras—.
  Para leer líneas completas de forma segura usaremos `while read` la semana que viene.

Como en otros lenguajes, `continue` salta a la siguiente vuelta y `break` rompe el bucle.

## Volviendo a ordenar.sh

Con un bucle y las expansiones para recortar y transformar variables, el *script* `ordenar.sh` de la semana pasada puede decidir la carpeta a partir de la extensión de cada fichero.
`${f##*.}` deja la extensión y `${ext,,}` la pasa a minúsculas, para que `foto.JPG` y `foto.jpg` se muevan al mismo sitio.

```bash
for f in "$dir"/*; do
    [[ -f $f ]] || continue
    ext=${f##*.}
    ext=${ext,,}
    if [[ $ext == jpg || $ext == png ]]; then
        mv "$f" "$dir/imagenes/"
    elif [[ $ext == pdf || $ext == txt ]]; then
        mv "$f" "$dir/documentos/"
    else
        mv "$f" "$dir/otros/"
    fi
done
```

Un fichero sin punto en el nombre es un caso extremo: `${f##*.}` no encuentra nada que quitar y devuelve la ruta entera.
Esa ruta no coincide con ninguna extensión y acaba en `otros`, que es justo lo que queríamos.
