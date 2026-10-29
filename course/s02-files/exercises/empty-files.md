`borrar_vacios.sh` recibe un directorio y borra los ficheros vacíos que contiene, también los de sus subdirectorios.
Antes de borrarlos, muestra cuáles son.

## Qué tiene que hacer

- Muestra `Ficheros vacíos borrados:` y la ruta de cada fichero vacío, uno por línea.
- Borra esos ficheros, también los que tienen espacios en el nombre.
- No borra ficheros con contenido, aunque estén ocultos, ni directorios, aunque se queden vacíos.

```console
$ cp -r proyecto prueba
$ bash borrar_vacios.sh prueba
Ficheros vacíos borrados:
prueba/README.md
prueba/docs/guía de uso.txt
prueba/src/util.h
$ ls prueba/src
main.c
```

El orden puede ser otro.

## Errores

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: borrar_vacios.sh <directorio>` | 1 |
| No es un directorio, o no existe | `Error: DIRECTORIO no es un directorio` | 2 |

::: details Pista

La condición `-empty` de `find` encaja con los ficheros y directorios vacíos.
Puedes usar dos `find` con las mismas condiciones: uno que solo muestra y otro con `-exec rm {} \;`.

:::
