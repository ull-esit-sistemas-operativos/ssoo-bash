`quien_usa.sh` recibe uno o varios ficheros y dice qué procesos los tienen abiertos.
Con `-k`, además, los para.

## Qué tiene que hacer

- Por cada proceso que tiene abierto un fichero muestra `FICHERO: PID COMANDO`, donde `COMANDO` es el nombre del proceso.
- Si nadie tiene abierto un fichero, muestra `FICHERO: nadie lo tiene abierto`.
- `-k` envía `SIGTERM` a esos procesos y muestra `FICHERO: parado PID COMANDO` en lugar de `FICHERO: PID COMANDO`.
- La opción va antes que los ficheros.
- No muestra los avisos de `lsof`.
- Los nombres de los ficheros pueden tener espacios.

Para probarlo, deja en segundo plano un proceso que tenga abierto `notas.csv`:

```console
$ sleep 300 < notas.csv &
[1] 2051
$ bash quien_usa.sh notas.csv alumnos.txt
notas.csv: 2051 sleep
alumnos.txt: nadie lo tiene abierto
$ bash quien_usa.sh -k notas.csv
notas.csv: parado 2051 sleep
```

## Errores

Los mensajes de error van al error estándar, precedidos de `quien_usa.sh: `, y no se para ningún proceso:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe ningún fichero | `uso: quien_usa.sh [-k] FICHERO...` | 1 |
| Una opción que no existe | `opción desconocida: -OPCIÓN` | 1 |
| No existe algún fichero | `no existe FICHERO` | 2 |

::: details Pista

`lsof -t FICHERO` escribe solo los PID, uno por línea, y `ps -o comm= -p PID` el nombre del proceso, sin cabecera.
Pero `lsof` termina con código 1 cuando nadie tiene abierto el fichero, y con `set -e` eso detiene el *script*.
Recorre sus PID con `while read -r pid; do …; done < <(lsof -t "$f" 2>/dev/null)`, que no se detiene, y cuenta cuántos hay.

:::
