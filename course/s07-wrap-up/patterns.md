Un patrón es una técnica que no depende de los datos.
Para cada uno, veremos dos ejemplos en contextos distintos.
Lo importante es aprender a reconocer el patrón, porque entonces el contexto da igual.

## Recorrer líneas con campos

`while` con `read` y un `IFS` adecuado reparte cada línea en variables, sea cual sea el separador.

```bash
# Usuarios con bash como shell, en /etc/passwd
while IFS=: read -r nombre _ _ _ _ home shell; do
    [[ $shell == */bash ]] && echo "$nombre ($home)"
done < /etc/passwd

# PID y comando de los procesos de un usuario
while read -r pid comando; do
    echo "$pid: $comando"
done < <(ps -u "$usuario" -o pid= -o comm=)
```

Cuidado con `set -e` en el primer bucle.
Si la última línea del fichero no cumple la condición, el `&&` deja un estado 1 y el bucle termina con ese estado.
Dentro de un *script* con `set -e`, es más seguro usar `if`.

## Agregar por clave: total, cuenta y máximo

Un *array* de `awk` indexado por la clave acumula lo que haga falta, y se muestra en `END`.

```bash
# Bytes servidos a cada IP, en el log
awk '{ bytes[$1] += $10 } END { for (ip in bytes) print ip, bytes[ip] }' acceso.log

# Nota máxima de cada asignatura, en el CSV
awk -F, 'NR > 1 && $3 != "" && (!($2 in max) || $3 > max[$2]) { max[$2] = $3 }
         END { for (a in max) print a, max[a] }' notas.csv
```

Para contar apariciones sin más, `sort | uniq -c` es más corto.
El *array* es necesario cuando hay que sumar, calcular medias o máximos, o agregar varias cosas a la vez.

## Tablas alineadas

La cabecera se imprime con `printf` fuera de la tubería, y los datos con el mismo formato después de ordenar.
Así `sort` nunca mezcla la cabecera con las filas.

```bash
printf '%-12s %8s\n' USUARIO PROCESOS
ps -e -o user= | sort | uniq -c | sort -k1,1nr -k2,2 |
    while read -r n usuario; do printf '%-12s %8s\n' "$usuario" "$n"; done

printf '%-10s %5s\n' ASIGNATURA MEDIA
awk -F, 'NR > 1 && $3 != "" { s[$2] += $3; n[$2]++ }
         END { for (a in s) printf "%-10s %5.2f\n", a, s[a] / n[a] }' notas.csv | sort
```

En el primero, `-k1,1nr -k2,2` desempata por nombre a igual número de procesos.
Si hay un criterio de desempate, hay que escribirlo siempre como segunda clave.

## Diferencia de conjuntos

Dos listas ordenadas y `comm -23` dan los elementos de la primera que no están en la segunda.

```bash
# Usuarios del sistema sin ningún proceso
comm -23 <(cut -d: -f1 /etc/passwd | sort) <(ps -e -o user= | sort -u)

# Matriculados sin ninguna nota
comm -23 <(sort alumnos.txt) <(tail -n +2 notas.csv | cut -d, -f1 | sort -u)
```

## Tiempos a segundos

Se separan las partes y se combinan con potencias de 60.
En `awk`, `split` divide un campo en un *array* con el separador que indiquemos.

```bash
# Hora de cada petición, en segundos desde medianoche
awk '{ split($4, t, ":"); print t[2] * 3600 + t[3] * 60 + t[4] }' acceso.log

# Duración mm:ss o hh:mm:ss, en segundos
echo "$duracion" | awk -F: '{ s = 0; for (i = 1; i <= NF; i++) s = s * 60 + $i; print s }'
```

En el *log*, el campo 4 es `[21/Oct/2026:10:15:32`, y `split` lo divide en `[21/Oct/2026`, `10`, `15` y `32`.

## Opciones con lista

Es el `case` con un `while` interior del esqueleto.
La única decisión es dónde termina la lista: en el siguiente argumento que empieza por guion, o en el primero que no tiene la forma de un elemento.
Los elementos se guardan en un *array* y se recorren con `for x in "${lista[@]}"`.
