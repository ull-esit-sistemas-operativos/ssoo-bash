`lineas.sh` recibe dos ficheros y muestra cuántas líneas tiene cada uno y cuántas suman entre los dos.

## Qué tiene que hacer

- Muestra una línea por fichero con su número de líneas y su nombre, y una última con el total.
- Funciona con nombres que tienen espacios, como `mis notas.csv`.

```console
$ bash lineas.sh notas.csv proyecto/README.md
  8 notas.csv
  0 proyecto/README.md
  8 total
```

## Errores

Si uno de los ficheros no existe, el *script* muestra las líneas del otro y el error, y termina con un estado distinto de 0.

::: details Pista

`wc -l` acepta varios ficheros y, cuando recibe más de uno, añade el total.

:::
