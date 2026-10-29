`boletin.sh` recibe un fichero CSV de notas, como `notas.csv`, y muestra una tabla con cuántas notas tiene cada alumno y su media.
Con `-a` muestra solo los alumnos que se den.

## Qué tiene que hacer

- Muestra una cabecera, `ALUMNO NOTAS MEDIA`, y una fila por alumno.
- Sin `-a`, una fila por cada alumno del CSV, en orden alfabético.
- `-a ALUMNO...` elige los alumnos, en el orden en que se dan; la lista termina en el primer argumento que no es solo letras.
- Las notas vacías no cuentan; un alumno sin notas tiene 0 y `-` como media.
- La media lleva dos decimales con punto.
- Las columnas miden 10, 5 y 6 caracteres: el nombre a la izquierda y los números a la derecha, separados por un espacio.
- El fichero puede ir antes o después de `-a`, y su nombre puede tener espacios.

```console
$ bash boletin.sh notas.csv
ALUMNO     NOTAS  MEDIA
ana            2   6.75
luis           1   4.50
marta          2   8.75
pablo          0      -
$ bash boletin.sh -a sara ana notas.csv
ALUMNO     NOTAS  MEDIA
sara           0      -
ana            2   6.75
```

## Errores

Los mensajes de error van al error estándar, precedidos de `boletin.sh: `, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| `-a` sin alumnos | `a -a le falta al menos un alumno` | 1 |
| Una opción que no existe | `opción desconocida: OPCIÓN` | 1 |
| Falta el fichero | `falta el fichero de notas` | 1 |
| No puede leer el fichero | `no se puede leer FICHERO` | 2 |

::: details Pista

Son tres patrones: «Opciones con lista», «Agregar por clave» y «Tablas alineadas».
Una función que reciba el fichero y un alumno y escriba su fila evita repetir el `awk`.
Recuerda la configuración regional al leer decimales.

:::
