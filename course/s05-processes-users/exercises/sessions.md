`sesiones.sh` recibe una salida guardada de `who`, como `who.txt`, y un usuario, y muestra las sesiones de ese usuario y cuántas son.

## Qué tiene que hacer

- Cada línea de la salida de `who` tiene el usuario, el terminal, la fecha, la hora y el origen.
- Por cada sesión del usuario muestra `TERMINAL desde las HORA ORIGEN`.
- Al final muestra `Sesiones de USUARIO: N`; un usuario sin sesiones tiene 0, y no es un error.
- El usuario tiene que coincidir entero: `alu` no es `alumno`.
- Funciona con nombres de fichero que tienen espacios, como `who de hoy.txt`.

```console
$ bash sesiones.sh who.txt alu
pts/0 desde las 09:12 (10.0.0.5)
pts/2 desde las 11:03 (10.0.0.5)
Sesiones de alu: 2
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe dos argumentos | `Uso: sesiones.sh <salida de who> <usuario>` | 1 |
| No puede leer el fichero | `Error: no se puede leer FICHERO` | 2 |

::: details Pista

`read` con varias variables reparte la línea en campos, y `_` recoge los que no interesan.
El contador tiene que sobrevivir al bucle: repasa «Variables que se pierden» en «Leer línea a línea».

:::
