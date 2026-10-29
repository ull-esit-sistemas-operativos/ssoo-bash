`informe.sh` recibe uno o varios *logs* de acceso y cuenta cuántas peticiones hay de cada código de estado, sumando las de todos.
Con `-o` guarda el informe en un fichero en lugar de mostrarlo.

## Qué tiene que hacer

- El código de estado es el campo 9 de cada línea.
- Muestra una línea `CÓDIGO: N` por código, ordenadas por código.
- `-o FICHERO` escribe el informe en `FICHERO`, sustituyendo lo que tuviera, y muestra `Informe guardado en FICHERO`.
- Las opciones y los *logs* van en cualquier orden, y sus nombres pueden tener espacios.

```console
$ bash informe.sh acceso.log
200: 3
404: 3
$ bash informe.sh -o informe.txt acceso.log
Informe guardado en informe.txt
```

## Errores

Los mensajes de error van al error estándar, precedidos de `informe.sh: `, y no se crea el informe:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe ningún *log* | `falta al menos un log` | 1 |
| `-o` sin fichero | `a -o le falta el fichero` | 1 |
| Una opción que no existe | `opción desconocida: OPCIÓN` | 1 |
| No puede leer algún *log* | `no se puede leer LOG` | 2 |

::: details Pista

Guarda los *logs* en un *array* mientras procesas las opciones, y comprueba que se pueden leer todos antes de escribir nada.
`awk` acepta varios ficheros y los lee seguidos.

:::
