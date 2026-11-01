`cuenta.sh` recibe un patrón y un fichero, y muestra cuántas líneas del fichero contienen el patrón.

## Qué tiene que hacer

- Con dos argumentos, el patrón y el fichero, muestra solo el número de líneas que lo contienen.
- El patrón puede tener espacios, como `"el perro"`, y el nombre del fichero también.
- El patrón puede empezar por guion, como `-v`: es un texto que buscar, no una opción.
- Si ninguna línea lo contiene, muestra `0` y termina con éxito.

```console
$ bash cuenta.sh gato texto.txt
2
$ bash cuenta.sh "el perro" texto.txt
1
$ bash cuenta.sh zzz texto.txt
0
$ echo $?
0
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe dos argumentos | `Uso: cuenta.sh <patrón> <fichero>` | 1 |
| No puede leer el fichero | `Error: no se puede leer FICHERO` | 2 |

::: details Pista

`grep -c` cuenta las líneas que encajan, pero termina con 1 cuando no encuentra ninguna.
Sin `exit`, el *script* devuelve el estado de su última orden.
Repasa en la ficha de `grep` qué pasa si el patrón empieza por guion.

:::
