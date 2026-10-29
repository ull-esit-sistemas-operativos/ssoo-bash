`fuentes.sh` recibe un directorio y lista los ficheros de código C que contiene, los `.c` y los `.h`, también los de sus subdirectorios.

## Qué tiene que hacer

- Muestra la ruta de cada fichero cuyo nombre acaba en `.c` o en `.h`, uno por línea.
- No muestra directorios, aunque su nombre acabe así, ni ficheros como `main.cpp`.
- Funciona con nombres que tienen espacios, como `mi proyecto/lista enlazada.c`.

```console
$ bash fuentes.sh proyecto
proyecto/src/main.c
proyecto/src/util.h
```

El orden puede ser otro.

## Errores

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: fuentes.sh <directorio>` | 1 |
| No es un directorio, o no existe | `Error: DIRECTORIO no es un directorio` | 2 |

::: details Pista

Basta un `find` con dos condiciones.
Un solo patrón puede encajar con las dos extensiones: `[ch]` es una `c` o una `h`.

:::
