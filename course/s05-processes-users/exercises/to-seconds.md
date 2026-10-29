`segundos.sh` recibe un fichero con un tiempo por línea, escrito como lo hace la columna `etime` de `ps`, y muestra cada tiempo con su equivalente en segundos.

## Qué tiene que hacer

- Acepta los tres formatos de `etime`: `mm:ss`, `hh:mm:ss` y `dd-hh:mm:ss`.
- Muestra en cada línea el tiempo, un espacio y los segundos.
- Acepta ceros a la izquierda, como `08:09`.
- Si una línea no es un tiempo, lo dice por el error estándar, indicando el número de línea, y sigue con las demás.
- Funciona con nombres que tienen espacios, como `tiempos de hoy.txt`.

```console
$ cat tiempos.txt
59:59
1:05:10
2-03:00:00
$ bash segundos.sh tiempos.txt
59:59 3599
1:05:10 3910
2-03:00:00 183600
```

## Errores

Los mensajes de error van al error estándar:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: segundos.sh <fichero>` | 1 |
| No puede leer el fichero | `Error: no se puede leer FICHERO` | 2 |
| Alguna línea no es un tiempo | `Error: línea N: «LÍNEA» no es un tiempo` | 3, al terminar |

::: details Pista

Es el patrón «Tiempos a segundos», con un `while read` que recorre el fichero.
Los días van antes del guion: `${t%%-*}` los separa del resto, y `[[ $t == *-* ]]` dice si los hay.
Para reconocer un tiempo, `=~` con una expresión regular, como en la semana 4.

:::
