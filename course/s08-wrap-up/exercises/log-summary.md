`resumen.sh` recibe uno o varios *logs* de acceso y muestra, de cada uno, cuántas peticiones tiene y cuántas han terminado en error.
Un *log* que no puede leer no lo detiene, sino que apunta el error en un registro y sigue con los demás.

## Qué tiene que hacer

- Muestra una línea `LOG: N peticiones, M con error` por *log*, en el orden en que se dan.
  Una petición termina en error si su código de estado, el campo 9, es 400 o mayor.
- Si no puede leer un *log*, añade el mensaje de error de `awk` al registro, `errores.log`, y sigue con el siguiente.
  Cada ejecución añade sus errores al final del registro, sin borrar los de antes.
- Si algún *log* ha fallado, al terminar lo dice por el error estándar y termina con código 2.
- `-e REGISTRO` elige otro registro.
  Las opciones van antes que los *logs*.
- Los nombres de los *logs* y del registro pueden tener espacios.

```console
$ bash resumen.sh acceso.log no_existe.log
acceso.log: 6 peticiones, 3 con error
resumen.sh: no se han podido leer 1 logs; mira errores.log
$ cat errores.log
gawk: fatal: no se puede abrir el fichero «no_existe.log» para lectura: No existe el fichero o el directorio
```

## Errores

Los mensajes de error van al error estándar, precedidos de `resumen.sh: `, y no se lee ningún *log*:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe ningún *log* | `uso: resumen.sh [-e REGISTRO] LOG...` | 1 |
| `-e` sin registro | `a -e le falta el registro` | 1 |
| Una opción que no existe | `opción desconocida: -OPCIÓN` | 1 |

::: details Pista

Como las opciones van delante, `getopts` basta para procesarlas (ver «Opciones con lista» en la semana 7).
`2>>` hace con el error estándar lo mismo que `>>` con la salida, y lo añade al final del fichero.
Con `|| fallos=$((fallos + 1))` detrás de `awk`, el *script* cuenta los *logs* que fallan sin que `set -e` lo detenga.

:::
