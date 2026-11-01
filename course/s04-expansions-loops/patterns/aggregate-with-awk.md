¿Cuántos bytes ha servido cada IP, cuál es la media de cada asignatura, quién tiene la nota más alta?
Son la misma pregunta que en el patrón «[Agregar por clave](../../s03-pipes/patterns/aggregate-by-key.md)» de la semana 3: un cálculo para cada valor distinto de un campo (la clave).
Pero ahora el cálculo no es contar, sino sumar, hacer la media o buscar el máximo, y para eso `sort | uniq -c` no es suficiente.

## El problema

En `acceso.log`, la clave es la IP (campo 1).
Queremos una línea por IP con los bytes servidos (campo 10), de la que más tiene a la que menos.

## Soluciones

### *Arrays* de awk: contar, sumar, media, máximo

Un *array* de `awk` se indexa con cualquier texto, así que usamos la clave como índice.
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

`$2 in max` comprueba si la asignatura ya tiene un máximo guardado en el *array* `max`.
Con `!` delante, como en `!($2 in max)`, es lo contrario: todavía no lo tiene, porque se trata de la primera línea.
Así que la línea se guarda si es la primera de su asignatura o si su nota supera el máximo guardado.
Sin la primera condición, el máximo de cada asignatura empezaría en 0, como se ve en «Errores frecuentes».

### Un bucle por clave

Se recorren las claves distintas y, para cada una, se calcula con otro comando:

```bash
for ip in $(cut -d' ' -f1 acceso.log | sort -u); do
    echo "$ip $(grep -c "^$ip " acceso.log)"
done
```

Lee el fichero una vez por clave, así que es lento con muchas claves, y el `for` falla si la clave tiene espacios, porque divide la lista por espacios.
Solo compensa cuando lo que hay que hacer con cada clave no cabe en `awk`.

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `sort \| uniq -c` | Solo contar |
| Arrays de `awk` | Sumar, media, máximo, o varios cálculos a la vez |
| Bucle por clave | Pocas claves, sin espacios, y algo que no se puede hacer en `awk` |

## En otros contextos

```bash
# CSV: número de notas de cada alumno, sin contar las vacías
awk -F, 'NR > 1 && $3 != "" { n[$1]++ } END { for (a in n) print a, n[a] }' notas.csv | sort

# Log: peticiones por código de estado
awk '{ c[$9]++ } END { for (k in c) print k, c[k] }' acceso.log | sort

# Log: bytes servidos por cada código de estado
awk '{ b[$9] += $10 } END { for (k in b) print k, b[k] }' acceso.log | sort
```

## Errores frecuentes

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

[Ficha de `awk`](../cards/awk.md) · [ficha de `sort`](../../s03-pipes/cards/sort.md) · [ficha de `cut`](../../s03-pipes/cards/cut.md) · patrón «[Agregar por clave](../../s03-pipes/patterns/aggregate-by-key.md)» · patrón «[Tablas alineadas](aligned-tables.md)»
