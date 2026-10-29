`sin_nota.sh` recibe un fichero CSV de notas, como `notas.csv`, y muestra quién tiene alguna nota vacía.

## Qué tiene que hacer

- Cada línea del fichero es `alumno,asignatura,nota`, y la primera es la cabecera.
  Una nota vacía es una línea que termina en coma, como `luis,FP,`.
- Muestra el nombre de cada alumno con alguna nota vacía, una vez aunque le falten varias, en orden alfabético.
- Si no falta ninguna nota, no muestra nada y termina con éxito.

```console
$ bash sin_nota.sh notas.csv
luis
pablo
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: sin_nota.sh <fichero CSV>` | 1 |
| No puede leer el fichero | `Error: no se puede leer FICHERO` | 2 |

::: details Pista

Es una tubería de tres etapas: elegir las líneas, quedarse con el primer campo y ordenar sin repetir.
En una expresión regular, `$` es el final de la línea.

:::
