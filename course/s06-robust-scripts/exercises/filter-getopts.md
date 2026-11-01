`filtro.sh` hace lo mismo que `codigo.sh`, pero procesa las opciones con `getopts`.
Así se ve qué gana y qué pierde un *script* con `getopts` frente al bucle con `case` y `shift`.

## Qué tiene que hacer

- `-c CÓDIGO` elige el código de estado, un número de tres cifras, y `-n N` muestra como mucho las N primeras peticiones, como en `codigo.sh`.
- `-h` muestra la ayuda por la salida estándar y termina con éxito.
- El valor puede ir separado de la opción o pegado a ella: `-c 200` y `-c200` valen igual.
- Las opciones van antes del *log*.
  Lo que venga detrás del *log* sobra, aunque empiece por guion.
- Funciona con nombres que tienen espacios, como `acceso de hoy.log`.

```console
$ bash filtro.sh -c200 -n2 acceso.log
192.168.1.10 - - [21/Oct/2026:10:15:32 +0200] "GET /index.html HTTP/1.1" 200 5120
192.168.1.10 - - [21/Oct/2026:10:16:02 +0200] "GET /tema1.html HTTP/1.1" 200 8340
$ bash filtro.sh acceso.log -n 2
filtro.sh: sobra el argumento: -n
```

La ayuda de `-h` es esta:

```console
$ bash filtro.sh -h
Uso: filtro.sh [-c CÓDIGO] [-n N] [-h] LOG

Muestra las peticiones del log con un código de estado.

Opciones:
  -c CÓDIGO  código de tres cifras (por defecto, 404)
  -n N       muestra como mucho las N primeras
  -h         muestra esta ayuda
```

## Errores

Los mensajes de error van al error estándar, precedidos de `filtro.sh: `, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| Una opción que no existe | `opción desconocida: OPCIÓN` | 1 |
| `-c` o `-n` sin valor | `a -c le falta el valor`, `a -n le falta el valor` | 1 |
| Un código que no tiene tres cifras, o un N que no es positivo | `código no válido: VALOR`, `número no válido: VALOR` | 1 |
| Falta el *log* | `falta el log` | 1 |
| Sobra un argumento detrás del *log* | `sobra el argumento: ARGUMENTO` | 1 |
| No puede leer el *log* | `no se puede leer LOG` | 2 |

::: details Pista

Es el `getopts` del patrón [Opciones con lista](../patterns/options-with-lists.md), con `':c:n:h'`.
Con el `:` del principio, `getopts` no escribe sus mensajes y deja la letra de la opción en `OPTARG`, así que con ella se escribe `a -$OPTARG le falta el valor`.
Después de `shift $((OPTIND - 1))`, el *log* es `$1` y no puede quedar nada más.
Escribe la ayuda en una función con `cat << EOF`, como en [Una ayuda con *here document*](../here-documents.md).

:::
