`notas.sh` recibe un fichero de notas y muestra la media de cada asignatura, el alumno con mejor media y las calificaciones que faltan.
Lo construimos en cuatro pasos.

1. **Comprobar el argumento.**
   Igual que en `resumen_log.sh`, debemos comprobar que hay un argumento y es un fichero legible, enviando los errores al error estándar.
   Los datos no hay que adaptarlos, porque `gawk` lee los decimales con punto.
2. **Media por asignatura.**
   La cabecera de la tabla se imprime con `printf` fuera de la tubería, para que `sort` no la mezcle con los datos:

   ```bash
   printf '%-10s %5s\n' ASIGNATURA MEDIA
   gawk -F, 'NR > 1 && $3 != "" { suma[$2] += $3; n[$2]++ }
          END { for (a in suma) printf "%-10s %5.2f\n", a, suma[a] / n[a] }' "$csv" | sort
   ```
3. **Mejor alumno.**
   El mismo patrón, agrupando por alumno, y después nos quedamos con la media más alta.
   Las medias salen con punto, así que `sort` las tiene que leer con `LC_ALL=C`:

   ```bash
   mejor=$(gawk -F, 'NR > 1 && $3 != "" { suma[$1] += $3; n[$1]++ }
                  END { for (a in suma) printf "%s %.2f\n", a, suma[a] / n[a] }' "$csv" |
           LC_ALL=C sort -k2,2nr | head -n 1)
   echo "Mejor media: $mejor"
   ```
4. **Notas que faltan.**
   Las líneas cuyo tercer campo está vacío:

   ```bash
   echo "Sin nota:"
   gawk -F, 'NR > 1 && $3 == "" { print $1, "(" $2 ")" }' "$csv"
   ```

**Resultado** con `notas.csv`:

```console
$ ./notas.sh notas.csv
ASIGNATURA MEDIA
FP          7.25
SSOO        7.00
Mejor media: marta 8.75
Sin nota:
luis (FP)
pablo (SSOO)
```

Fíjate en que sara no aparece en «Sin nota», porque no tiene ninguna línea en el fichero.
Detectarla exige comparar con `alumnos.txt`, como hicimos con `comm`.
