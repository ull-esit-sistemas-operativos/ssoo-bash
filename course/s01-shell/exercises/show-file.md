`ver.sh` recibe un fichero y muestra su ruta absoluta y, después, su contenido.

## Qué tiene que hacer

- Muestra `Ruta:`, en la línea siguiente la ruta absoluta del fichero, después `Contenido:` y el contenido.
- Funciona con nombres que tienen espacios, como `mis notas.csv`.
- Tiene permiso de ejecución, así que se puede ejecutar como `./ver.sh`.

```console
$ ./ver.sh notas.csv
Ruta:
/workspaces/ssoo-bash/exercises/s01/show-file/notas.csv
Contenido:
alumno,asignatura,nota
ana,SSOO,7.5
...
```

La ruta será la de tu directorio.

## Errores

Si el fichero no existe, `cat` muestra el error y el *script* termina con un estado distinto de 0.

::: details Pista

`realpath` da la ruta absoluta de un fichero.
Un *script* termina con el estado de su última orden, así que conviene que el `cat` sea la última.

:::
