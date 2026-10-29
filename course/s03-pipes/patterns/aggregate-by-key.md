¿Cuántas peticiones ha hecho cada IP, cuánta memoria usa cada usuario, cuál es la media de cada asignatura?
Son todas la misma pregunta: un cálculo (contar, sumar, media, máximo) para cada valor distinto de un campo (la clave).

## El problema

En `acceso.log`, la clave es la IP (campo 1).
Queremos una línea por IP con su número de peticiones y, después, con los bytes servidos (campo 10).

## Soluciones

### sort y uniq -c: contar

Si solo hay que contar, se saca la clave, se ordena para juntar las iguales y `uniq -c` cuenta cada grupo:

```console
$ cut -d' ' -f1 acceso.log | sort | uniq -c | sort -rn
      3 192.168.1.10
      2 10.0.0.7
      1 172.16.0.3
```

### Arrays de awk: contar, sumar, media, máximo

Un *array* de `awk` se indexa con cualquier texto, así que la clave es el índice.
Se acumula en cada línea y se recorre en `END`:

```console
$ awk '{ b[$1] += $10 } END { for (ip in b) print ip, b[ip] }' acceso.log | sort -k2,2nr
192.168.1.10 13972
172.16.0.3 5120
10.0.0.7 1024
```

Para la media hacen falta dos *arrays*, la suma y el contador.
`$3 != ""` salta las notas vacías, que si no contarían como 0 y bajarían la media:

```console
$ LC_ALL=C awk -F, 'NR > 1 && $3 != "" { s[$2] += $3; n[$2]++ } END { for (a in s) printf "%s %.2f\n", a, s[a] / n[a] }' notas.csv | sort
FP 7.25
SSOO 7.00
```

Para el máximo, se guarda el valor y quién lo tiene la primera vez que aparece la clave o cuando se supera:

```console
$ LC_ALL=C awk -F, 'NR > 1 && (!($2 in max) || $3 > max[$2]) { max[$2] = $3; quien[$2] = $1 } END { for (a in max) print a, quien[a], max[a] }' notas.csv | sort
FP marta 8.5
SSOO marta 9
```

### Un bucle por clave

Se recorren las claves distintas y, para cada una, se calcula con otro comando:

```bash
for ip in $(cut -d' ' -f1 acceso.log | sort -u); do
    echo "$ip $(grep -c "^$ip " acceso.log)"
done
```

Lee el fichero una vez por clave, así que es lento con muchas claves, y el `for` se rompe si la clave tiene espacios.
Solo compensa cuando lo que hay que hacer con cada clave no cabe en `awk`.

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `sort \| uniq -c` | Solo contar |
| Arrays de `awk` | Sumar, media, máximo, o varios cálculos a la vez |
| Bucle por clave | Pocas claves, sin espacios, y algo que no se puede hacer en `awk` |

## En otros contextos

```bash
# Procesos: memoria usada por cada usuario
ps -eo user=,%mem= | LC_ALL=C awk '{ m[$1] += $2 } END { for (u in m) printf "%s %.1f\n", u, m[u] }' | sort -k2,2nr

# CSV: número de notas de cada alumno
tail -n +2 notas.csv | cut -d, -f1 | sort | uniq -c

# Log: peticiones por código de estado
awk '{ c[$9]++ } END { for (k in c) print k, c[k] }' acceso.log | sort
```

## Errores frecuentes

**`uniq` sin `sort`.**
`uniq -c` solo junta líneas seguidas: sin ordenar antes, la misma clave sale en varios grupos.

**El orden de `for (k in a)`.**
No está definido y cambia entre versiones de `awk`.
Si importa, se ordena la salida con `sort`.

**El valor inicial del máximo.**
Las variables de `awk` empiezan valiendo 0 o vacío, así que `$3 > max` falla si todos los valores son negativos:

```console
$ printf 'a,-1\nb,-3\n' | awk -F, '$2 > max { max = $2; q = $1 } END { print "[" q "]", max }'
[] 
$ printf 'a,-1\nb,-3\n' | awk -F, 'NR == 1 || $2 > max { max = $2; q = $1 } END { print q, max }'
a -1
```

**Decimales con punto.**
Con el *locale* en español, `mawk` lee `7.5` como 7 y `sort -n` como 75.
Con datos con punto, `LC_ALL=C` en todos los comandos que los lean, o convertir antes los datos a coma con `tr`.

## Ver también

[Ficha de `sort`](../cards/sort.md) · [ficha de `uniq`](../cards/uniq.md) · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md) · [ficha de `cut`](../cards/cut.md) · patrón «[Tablas alineadas](../../s04-expansions-loops/patterns/aligned-tables.md)»
