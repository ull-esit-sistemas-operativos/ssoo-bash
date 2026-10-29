`codigo.sh` recibe un *log* de acceso, como `acceso.log`, y muestra las peticiones con un código de estado, por defecto 404.
Dos opciones eligen el código y cuántas peticiones mostrar.

## Qué tiene que hacer

- `-c CÓDIGO` elige el código de estado, un número de tres cifras.
- `-n N` muestra como mucho las N primeras; sin `-n`, todas.
- `-h` muestra el uso por la salida estándar y termina con éxito.
- Las opciones y el *log* van en cualquier orden.
- El código de estado es el campo 9 de cada línea: un 404 en la ruta o en los bytes no cuenta.
- Funciona con nombres que tienen espacios, como `acceso de hoy.log`.

```console
$ bash codigo.sh acceso.log -n 2
10.0.0.7 - - [21/Oct/2026:10:15:40 +0200] "GET /logo.png HTTP/1.1" 404 512
10.0.0.7 - - [21/Oct/2026:10:17:16 +0200] "GET /favicon.ico HTTP/1.1" 404 512
$ bash codigo.sh -h
Uso: codigo.sh [-c CÓDIGO] [-n N] [-h] LOG
```

## Errores

Los mensajes de error van al error estándar, precedidos de `codigo.sh: `, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| Una opción que no existe | `opción desconocida: OPCIÓN` | 1 |
| `-c` o `-n` sin valor | `a -c le falta el código`, `a -n le falta el número` | 1 |
| Un código que no tiene tres cifras, o un N que no es positivo | `código no válido: VALOR`, `número no válido: VALOR` | 1 |
| Falta el *log* | `falta el log` | 1 |
| No puede leer el *log* | `no se puede leer LOG` | 2 |

::: details Pista

Es la parte de opciones de «El script completo», con dos opciones con valor.
`awk -v c="$codigo" '$9 == c'` deja las líneas cuyo campo 9 es el código.

:::
