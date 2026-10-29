`entradas.sh` recibe un directorio y muestra cuántas entradas tiene, contando las ocultas, y cuáles son.

## Qué tiene que hacer

- Muestra `Número de entradas:` y en la línea siguiente el número.
- Después muestra `Entradas:` y las entradas, una por línea.
- Incluye las entradas ocultas, como `.oculto`, pero no `.` ni `..`.
- Funciona con nombres que tienen espacios, como `mis datos`.

```console
$ bash entradas.sh proyecto
Número de entradas:
4
Entradas:
docs
.oculto
README.md
src
```

El orden de la lista puede cambiar según la configuración del equipo.

## Errores

Si el directorio no existe, `ls` muestra el error y el *script* termina con un estado distinto de 0.

::: details Pista

Es la segunda parte de `info.sh`.
Cuando la salida de `ls` va a una tubería o a un fichero, escribe una entrada por línea.

:::
