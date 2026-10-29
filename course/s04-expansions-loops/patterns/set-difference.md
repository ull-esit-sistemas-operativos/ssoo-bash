¿Qué alumnos matriculados no aparecen en las notas?
¿Qué usuarios no tienen procesos?
Hay dos listas, y queremos los elementos de la primera que no están en la segunda (la diferencia) o los que están en las dos (la intersección).

## El problema

`alumnos.txt` tiene los matriculados: ana, luis, marta, pablo y sara.
`notas.csv` tiene líneas de ana, luis, marta y pablo; la de pablo, con la nota vacía.
Queremos los matriculados que no aparecen en `notas.csv`: sara.

## Soluciones

### comm con listas ordenadas

`comm` compara dos ficheros ordenados y saca tres columnas: lo que solo está en el primero, lo que solo está en el segundo y lo que está en los dos.
`-1`, `-2` y `-3` ocultan cada columna:

```console
$ comm -23 <(sort -u alumnos.txt) <(tail -n +2 notas.csv | cut -d, -f1 | sort -u)
sara
```

`<( )` pasa la salida de un comando como si fuera un fichero, así que no hacen falta ficheros intermedios.
Con `-12` sale la intersección: ana, luis, marta y pablo.
Para contar también a pablo como alumno sin nota, se quitan antes las líneas con la nota vacía, `tail -n +2 notas.csv | grep -v ',$' | cut -d, -f1`, y salen pablo y sara.

### grep -vxFf

`grep -f` toma los patrones de un fichero.
Las otras opciones los convierten en «las líneas que no son exactamente ninguna de estas»: `-v` invierte, `-x` exige la línea entera y `-F` trata los patrones como texto literal.
No necesita ordenar y conserva el orden de la primera lista:

```console
$ tail -n +2 notas.csv | cut -d, -f1 | sort -u > con_nota.txt
$ grep -vxFf con_nota.txt alumnos.txt
sara
```

### Un *array* de awk

`awk` lee los dos ficheros seguidos.
Mientras lee el primero (`NR == FNR`), guarda las claves en un *array*; con el segundo, imprime las líneas cuya clave no está en el *array*:

```console
$ awk -F, 'NR == FNR { if (FNR > 1) nota[$1]; next } !($1 in nota)' notas.csv alumnos.txt
sara
```

Es útil cuando la clave es un campo de un fichero con varias columnas, porque no hace falta extraerla antes.

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `comm` | Las dos listas se pueden ordenar, y hacen falta la diferencia, la intersección o ambas |
| `grep -vxFf` | Hay que conservar el orden de la primera lista |
| Array de `awk` | La clave es un campo de un fichero con varias columnas |

## En otros contextos

```bash
# Usuarios: cuentas personas (UID de 1000 a 65533) sin ningún proceso en marcha
comm -23 <(awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }' /etc/passwd | sort -u) <(ps -eo user= | sort -u)

# Log: IP que han hecho peticiones y no están en una lista de conocidas
cut -d' ' -f1 acceso.log | sort -u | grep -vxFf conocidas.txt
```

## Errores frecuentes

**`comm` con listas sin ordenar.**
`comm` da un resultado incorrecto y solo avisa por la salida de error:

```console
$ printf 'b\na\n' > x.txt; printf 'a\n' > y.txt
$ comm -23 x.txt y.txt
b
comm: file 1 is not in sorted order
a
```

Las dos listas tienen que estar ordenadas con el mismo *locale*.
Si una se ordena con `LC_ALL=C` y la otra no, `comm` también las da por desordenadas.

**`grep -f` sin `-x`.**
Sin `-x`, `ana` encaja con `mariana`, y `-v` quita las dos:

```console
$ printf 'ana\nmariana\n' > todos.txt; printf 'ana\n' > vistos.txt
$ grep -vf vistos.txt todos.txt
$ grep -vxFf vistos.txt todos.txt
mariana
```

**`grep -f` sin `-F`.**
Sin `-F`, los puntos de una IP son comodines: `10.0.0.7` encajaría con `10a0b0c7`.

**La cabecera.**
`notas.csv` tiene una línea de cabecera, y su primer campo, `alumno`, entraría en la lista si no se quita con `tail -n +2` o `FNR > 1`.

## Ver también

[Ficha de `sort`](../../s03-pipes/cards/sort.md) · [ficha de `grep`](../../s03-pipes/cards/grep.md) · [ficha de `awk`](../cards/awk.md)
