`aprobados.sh` recibe un fichero CSV de notas, como `notas.csv`, y una nota mínima, y muestra las notas iguales o mayores que el mínimo.

## Qué tiene que hacer

- Cada línea del fichero es `alumno,asignatura,nota`, y la primera es la cabecera.
- Muestra `alumno asignatura nota`, separados por un espacio, de cada nota igual o mayor que el mínimo, de la más alta a la más baja; a igual nota, por orden alfabético.
- El mínimo puede tener decimales, como `7.5`, y las notas vacías no cuentan.
- Funciona con nombres que tienen espacios, como `notas de octubre.csv`.

```console
$ bash aprobados.sh notas.csv 7
marta SSOO 9
marta FP 8.5
ana SSOO 7.5
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe dos argumentos | `Uso: aprobados.sh <fichero CSV> <nota mínima>` | 1 |
| No puede leer el fichero | `Error: no se puede leer FICHERO` | 2 |
| El mínimo no es un número, como `7` o `7.5` | `Error: MÍNIMO no es una nota` | 3 |

::: details Pista

`awk -v min="$minima"` pasa el mínimo al programa de `awk`.
Las pruebas usan la configuración en español, como el contenedor del curso: repasa «Decimales y configuración regional».
Para comprobar el mínimo, `[[ $minima =~ ... ]]` con una expresión regular.

:::
