`notas.sh` recibe un fichero de notas y muestra la media de cada asignatura, el alumno con mejor media y las calificaciones que faltan.
Lo construimos en cuatro pasos.

1. **Comprobar el argumento y adaptar los datos.**
   Igual que en `resumen_log.sh`: debemos comprobar que hay un argumento y es un fichero legible, enviando los errores al error estándar.
   Después convertimos el fichero a la convención española, una sola vez, y guardamos el resultado en una variable que leerán los pasos siguientes:

   ```bash
   datos=$(tr ',.' ';,' < "$csv")
   ```
2. **Media por asignatura.**
   La cabecera de la tabla se imprime con `printf` fuera de la tubería, para que `sort` no la mezcle con los datos:

   ```bash
   printf '%-10s %5s\n' ASIGNATURA MEDIA
   echo "$datos" | awk -F';' 'NR > 1 && $3 != "" { suma[$2] += $3; n[$2]++ }
            END { for (a in suma) printf "%-10s %5.2f\n", a, suma[a] / n[a] }' | sort
   ```
3. **Mejor alumno.**
   El mismo patrón, agrupando por alumno, y después nos quedamos con la media más alta:

   ```bash
   mejor=$(echo "$datos" | awk -F';' 'NR > 1 && $3 != "" { suma[$1] += $3; n[$1]++ }
                    END { for (a in suma) printf "%s %.2f\n", a, suma[a] / n[a] }' |
           sort -k2,2nr | head -n 1)
   echo "Mejor media: $mejor"
   ```
4. **Notas que faltan.**
   Las líneas cuyo tercer campo está vacío:

   ```bash
   echo "Sin nota:"
   echo "$datos" | awk -F';' 'NR > 1 && $3 == "" { print $1, "(" $2 ")" }'
   ```

**Resultado** con `notas.csv`:

```console
$ ./notas.sh notas.csv
ASIGNATURA MEDIA
FP          7,25
SSOO        7,00
Mejor media: marta 8,75
Sin nota:
luis (FP)
pablo (SSOO)
```

Fíjate en que sara no aparece en «Sin nota»: no tiene ninguna línea en el fichero.
Detectarla exige comparar con `alumnos.txt`, como hicimos con `comm`.
