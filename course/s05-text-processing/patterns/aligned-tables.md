¿Cómo saco un resultado como una tabla, con cabecera y columnas que no se descuadran?
Cada columna tiene un ancho fijo, el texto se alinea a la izquierda y los números a la derecha, y la cabecera se imprime aparte de los datos.

## El problema

Queremos las notas de mayor a menor, con el alumno a la izquierda y la nota a la derecha, con dos decimales y bajo una cabecera.

## Soluciones

### printf de awk

La cabecera se imprime antes y por separado; los datos se ordenan y `awk` los formatea:

```console
$ printf '%-8s %5s\n' ALUMNO NOTA
ALUMNO    NOTA
$ tail -n +2 notas.csv | LC_ALL=C sort -t, -k3,3nr | gawk -F, '$3 != "" { printf "%-8s %5.2f\n", $1, $3 }'
marta     9.00
marta     8.50
ana       7.50
ana       6.00
luis      4.50
```

`%-8s` reserva ocho columnas y alinea a la izquierda; `%5.2f`, cinco columnas con dos decimales, alineado a la derecha.
`$3 != ""` deja fuera las notas vacías, que `printf` escribiría como `0.00`.
La cabecera usa los mismos anchos.

### printf de bash en un bucle

Cuando cada fila necesita algo que no está en los datos, como el resultado de otro comando, se recorre la entrada con `while read`, y se imprime con el `printf` de la *shell*:

```console
$ printf '%-15s %8s\n' IP PETICIONES
IP              PETICIONES
$ cut -d' ' -f1 acceso.log | sort | uniq -c | sort -rn | while read -r n ip; do printf '%-15s %8d\n' "$ip" "$n"; done
192.168.1.10           3
10.0.0.7               2
172.16.0.3             1
```

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `printf` de `awk` | Los datos ya están en un fichero o una tubería, o hay que calcular con decimales |
| `printf` de bash en un bucle | Cada fila combina datos de varios comandos |

## En otros contextos

```bash
# Log: peticiones y bytes por código de respuesta
printf '%-6s %10s %10s\n' ESTADO PETICIONES BYTES
gawk '{ n[$9]++; b[$9] += $10 } END { for (c in n) printf "%-6s %10d %10d\n", c, n[c], b[c] }' acceso.log | sort -k2,2nr

# Log: bytes servidos por IP
printf '%-15s %10s\n' IP BYTES
gawk '{ b[$1] += $10 } END { for (ip in b) printf "%-15s %10d\n", ip, b[ip] }' acceso.log | sort -k2,2nr
```

## Errores frecuentes

**La cabecera dentro del `sort`.**
Si la cabecera pasa por la misma tubería, se ordena con los datos:

```console
$ { printf '%-8s %5s\n' ALUMNO NOTA; tail -n +2 notas.csv | gawk -F, '$3 != "" { printf "%-8s %5.2f\n", $1, $3 }'; } | sort
ALUMNO    NOTA
ana       6.00
ana       7.50
luis      4.50
marta     8.50
marta     9.00
```

Aquí ha quedado arriba por casualidad, porque `ALUMNO` va antes que `ana` en orden alfabético; con un alumno llamado `abel`, la cabecera quedaría debajo de él.
La cabecera se imprime antes de la tubería, nunca dentro.

**Acentos y eñes.**
Los anchos de `printf` cuentan bytes, y cada tilde o ñ ocupa dos, así que esa fila queda un espacio más corta:

```console
$ printf '%-8s|\n' 'Begoña' 'Ana'
Begoña |
Ana     |
```

**Decimales con punto en el `printf` de bash.**
Con el *locale* en español, `printf '%.2f' 7.5` da error.
Con datos con punto, el formato decimal se hace en `gawk`, o se convierten antes los datos a coma con `tr`.

**El ancho no recorta.**
Si el texto es más largo que el ancho, `printf` lo imprime entero y la fila se descuadra.
Para recortar, `%.8s`.

## Ver también

[Ficha de `printf`](../cards/printf.md) · [ficha de `awk`](../cards/awk.md) · [ficha de `sort`](../../s03-pipes/cards/sort.md) · patrón «[Agregar por clave con awk](aggregate-with-awk.md)»
