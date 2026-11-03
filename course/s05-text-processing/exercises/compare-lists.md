`comparar.sh` recibe dos ficheros con un elemento por línea y muestra qué líneas están solo en el primero y cuáles solo en el segundo.

## Qué tiene que hacer

- Muestra `Solo en FICHERO1:` y las líneas que solo están en el primero, ordenadas.
- Después muestra `Solo en FICHERO2:` y las que solo están en el segundo.
- Los ficheros no tienen que estar ordenados, y una línea repetida sale una sola vez.
- Funciona con nombres que tienen espacios, como `presentes hoy.txt`.

```console
$ cat presentes.txt
pablo
ana
marta
luis
raúl
$ bash comparar.sh alumnos.txt presentes.txt
Solo en alumnos.txt:
sara
Solo en presentes.txt:
raúl
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe dos argumentos | `Uso: comparar.sh <fichero> <fichero>` | 1 |
| No puede leer alguno de los ficheros | `Error: no se puede leer FICHERO` | 2 |

::: details Pista

Es el patrón «Diferencia de conjuntos».
`comm` necesita las dos entradas ordenadas, y la sustitución de procesos, `<(sort -u fichero)`, se las da sin ficheros intermedios.

:::
