`ordenar.sh` recibe un directorio y mueve cada fichero que contiene a una subcarpeta según su extensión: `imagenes`, `documentos` u `otros`.
Lo construimos en cuatro pasos.

1. **Comprobar los argumentos.**
   Son los dos bloques `if` del apartado anterior, colocados al principio del *script*, con `dir=$1` entre ambos.
2. **Crear las carpetas.**
   Con `-p`, `mkdir` no falla si ya existen, así que el *script* se puede ejecutar varias veces:

   ```bash
   mkdir -p "$dir/imagenes" "$dir/documentos" "$dir/otros"
   ```
3. **Mover por extensión.**
   Un `find` por extensión, limitado al primer nivel:

   ```bash
   find "$dir" -maxdepth 1 -type f -iname '*.jpg' -exec mv {} "$dir/imagenes/" \;
   find "$dir" -maxdepth 1 -type f -iname '*.png' -exec mv {} "$dir/imagenes/" \;
   find "$dir" -maxdepth 1 -type f -iname '*.pdf' -exec mv {} "$dir/documentos/" \;
   find "$dir" -maxdepth 1 -type f -iname '*.txt' -exec mv {} "$dir/documentos/" \;
   ```
4. **Mover el resto.**
   Lo que siga en el primer nivel no tiene una extensión conocida:

   ```bash
   find "$dir" -maxdepth 1 -type f -exec mv {} "$dir/otros/" \;
   ```

**Resultado** sobre un directorio con `foto 1.JPG`, `apuntes.pdf` y `lista`:

```console
$ ./ordenar.sh descargas
$ ls -R descargas
descargas:
documentos  imagenes  otros

descargas/documentos:
apuntes.pdf

descargas/imagenes:
foto 1.JPG

descargas/otros:
lista
```

¿Por qué `find` y no `mv "$dir"/*.jpg "$dir/imagenes/"`, que parece más sencillo?
Por tres razones:

- **Sin coincidencias no hay error.**
  Si no hay ningún `.jpg`, el comodín quedaría sin expandir y `mv` fallaría intentando mover `*.jpg`; `find` simplemente no hace nada en ese caso.
- **Mayúsculas.**
  `-iname` encuentra también `foto 1.JPG`.
- **Espacios.**
  `{}` llega a `mv` como un solo argumento, aunque el nombre tenga espacios.

`-maxdepth 1` también es necesario: sin él, `find` entraría en las subcarpetas recién creadas y el paso 4 sacaría de ellas lo que ya habíamos clasificado.
Fíjate, además, en que `find` no ignora los ficheros ocultos como hace `*`: un `.borrador` acabaría en `otros`.

Las cuatro líneas del paso 3 se parecen demasiado.
En la semana 4 veremos cómo recorrer los ficheros con un bucle y decidir la carpeta a partir de la extensión de cada uno.
