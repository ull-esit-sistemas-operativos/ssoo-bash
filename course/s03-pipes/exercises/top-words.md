`top_palabras.sh` recibe un fichero de texto y un número N, y muestra las N palabras que más se repiten, con cuántas veces aparece cada una.

## Qué tiene que hacer

- Las palabras están separadas por un espacio.
- Cada línea de la salida tiene el formato de `uniq -c`: el número de veces y la palabra.
- Las ordena de más a menos veces y, a igual número de veces, por orden alfabético.
- Si hay menos de N palabras distintas, las muestra todas.

```console
$ bash top_palabras.sh texto.txt 3
      3 el
      2 gato
      2 y
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe dos argumentos | `Uso: top_palabras.sh <fichero> <N>` | 1 |
| No puede leer el fichero | `Error: no se puede leer FICHERO` | 2 |
| N no es un número entero de 1 o más | `Error: N tiene que ser un número de 1 o más` | 1 |

::: details Pista

Primero, una palabra por línea con `tr`; después, el patrón «Agregar por clave».
Para desempatar, `sort` admite varias claves con `-k` (ver la [ficha de `sort`](../cards/sort.md)).
`-lt` falla con un N como `2x`: comprueba antes con `=~` que N es un número (ver la [ficha de `[[ ]]`](../cards/test.md)).

:::
