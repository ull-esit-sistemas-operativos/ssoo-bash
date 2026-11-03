`estados.sh` recibe una salida guardada de `ps -e -o pid,user,stat,comm`, como `ps.txt`, y cuenta cuántos procesos hay en cada estado.

## Qué tiene que hacer

- El estado es la columna `STAT`, y lo decide su primera letra: `R` en ejecución, `S` o `D` durmiendo, `T` detenido y `Z` zombi.
  Las demás letras, como `I`, cuentan como otros.
- Las letras que siguen a la primera, como en `Ss` o `S+`, no cambian el estado.
- No cuenta la cabecera.
- Funciona con nombres que tienen espacios, como `ps de hoy.txt`.

```console
$ bash estados.sh ps.txt
En ejecución: 1
Durmiendo: 5
Detenidos: 1
Zombis: 1
Otros: 1
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: estados.sh <salida de ps>` | 1 |
| No puede leer el fichero | `Error: no se puede leer FICHERO` | 2 |

::: details Pista

Un `while read` que deja el estado en una variable, y un `case` con los patrones `R*`, `S*`… que suma a un contador distinto en cada rama.

:::
