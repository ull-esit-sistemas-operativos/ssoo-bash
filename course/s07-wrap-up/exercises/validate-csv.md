`validar.sh` recibe uno o varios ficheros CSV de notas y comprueba que tienen el formato de `notas.csv`.
Dice qué líneas fallan y por qué.

## Qué tiene que hacer

Comprueba en cada fichero:

- La primera línea es exactamente `alumno,asignatura,nota`.
- Cada línea de datos tiene tres campos separados por comas.
- El alumno y la asignatura no están vacíos.
- La nota está vacía o es un número de 0 a 10, con o sin decimales, como `7`, `9.25` o `10.0`.

Por cada línea que falla muestra `FICHERO: línea N: MOTIVO`, con el primer motivo que encuentre en este orden.
Al final muestra `Errores: N` y termina con código 3, o `Todo correcto` si no hay ninguno.

```console
$ bash validar.sh notas.csv
Todo correcto
$ cat mal.csv
alumno,asignatura,nota
luis,FP
marta,SSOO,11
,FP,5
$ bash validar.sh mal.csv
mal.csv: línea 2: no tiene tres campos
mal.csv: línea 3: nota no válida: 11
mal.csv: línea 4: falta el alumno o la asignatura
Errores: 3
```

Los nombres de los ficheros pueden tener espacios.

Los motivos son `la cabecera no es alumno,asignatura,nota`, `no tiene tres campos`, `falta el alumno o la asignatura` y `nota no válida: NOTA`.

## Errores

Los mensajes de error van al error estándar, precedidos de `validar.sh: `, y no se comprueba ningún fichero:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe ningún fichero | `uso: validar.sh FICHERO...` | 1 |
| No puede leer algún fichero | `no se puede leer FICHERO` | 2 |

::: details Pista

`IFS=, read -r alumno asignatura nota resto <<< "$linea"` separa los campos; si `resto` no queda vacío, sobran campos.
Una expresión regular con dos alternativas reconoce las notas: de 0 a 9 con decimales opcionales, o 10, con decimales opcionales que solo pueden ser ceros.

:::
