`extremos.sh` recibe un fichero y muestra su primera y su última línea.

## Qué tiene que hacer

- Muestra `Primera línea:` y la primera línea del fichero.
- Después muestra `Última línea:` y la última.
- Funciona con nombres que tienen espacios, como `mis notas.csv`.

```console
$ bash extremos.sh notas.csv
Primera línea:
alumno,asignatura,nota
Última línea:
pablo,SSOO,
```

## Errores

Si el fichero no existe, el *script* muestra el error de los comandos y termina con un estado distinto de 0.

::: details Pista

`head` muestra el principio de un fichero y `tail`, el final.
Los dos aceptan `-n` con el número de líneas.

:::
