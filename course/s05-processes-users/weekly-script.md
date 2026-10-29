`usuarios.sh` muestra una tabla con una fila por usuario: cuántos procesos tiene, qué porcentaje de memoria suman y si está conectado.
Lo construimos en cuatro pasos.

1. **Agrupar por usuario.**
   Es el patrón de la semana pasada, con `ps` como fuente.
   Ahora debemos recordar que `ps` escribe `%mem` siempre con punto, pero en un equipo en español `awk` leería `21.7` como 21, porque espera `,` como separador decimal.
   Esta vez cambiamos la configuración del comando `awk` con `LC_ALL=C`, que es lo más directo cuando los datos llegan por una tubería.
   También funcionaría adaptar los datos, como hicimos con `notas.csv`, añadiendo `tr . ,` entre `ps` y `awk`:

   ```bash
   ps -e -o user= -o %mem= |
       LC_ALL=C awk '{ n[$1]++; m[$1] += $2 } END { for (u in n) printf "%s %d %.1f\n", u, n[u], m[u] }'
   ```
2. **Saber quién está conectado.**
   Lo calculamos una vez, antes del bucle, en lugar de ejecutar `who` por cada usuario:

   ```bash
   conectados=$(who | cut -d' ' -f1 | sort -u)
   ```
3. **Imprimir la cabecera.**
   Fuera de la tubería, para que no se ordene con los datos:

   ```bash
   printf '%-12s %8s %6s %s\n' USUARIO PROCESOS %MEM CONECTADO
   ```
4. **Recorrer y presentar.**
   Ordenamos por número de procesos y completamos cada fila:

   ```bash
   ps -e -o user= -o %mem= |
       LC_ALL=C awk '{ n[$1]++; m[$1] += $2 } END { for (u in n) printf "%s %d %.1f\n", u, n[u], m[u] }' |
       sort -k2,2nr |
       while read -r usuario procesos mem; do
           if echo "$conectados" | grep -qx "$usuario"; then
               conectado=sí
           else
               conectado=no
           fi
           printf '%-12s %8s %6s %s\n' "$usuario" "$procesos" "$mem" "$conectado"
       done
   ```

**Resultado**, con valores que en tu máquina serán otros:

```console
$ ./usuarios.sh
USUARIO      PROCESOS   %MEM CONECTADO
root              142   12.3 no
alu                38   21.7 sí
daemon              1    0.1 no
```

La memoria se imprime con `%s` porque ya viene formateada por `awk`.
`%MEM` es un porcentaje de la memoria física.
La suma de todos los usuarios no tiene por qué dar 100, porque hay memoria compartida entre procesos que cuenta varias veces.

> [!NOTE] Nombres de usuario largos
> La columna `user` de `ps` tiene un ancho fijo, y si un nombre no cabe, `ps` puede mostrar el UID en su lugar.
> Se puede ensanchar la columna indicando el ancho tras dos puntos: `-o user:20=`.
> Compruébalo en tu máquina.
