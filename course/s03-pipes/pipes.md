Guardar la salida de un comando en un fichero temporal para que lo lea el siguiente funciona, pero es lento y deja basura.
¿Y si pudiéramos conectarlos directamente?

Una **tubería** conecta la salida estándar de un comando con la entrada estándar del siguiente.
Se escribe con `|`, y los dos comandos se ejecutan a la vez: el segundo procesa los datos según el primero los produce.
El error estándar no pasa por la tubería; sigue mostrándose en la pantalla.

La idea de fondo es usar muchos comandos pequeños, cada uno con una sola tarea, y combinarlos.
Veamos cómo se obtiene la lista de IP ordenadas por número de peticiones, añadiendo un eslabón cada vez:

1. **Extraer el campo.**
   `cut -d' ' -f1 acceso.log` corta cada línea por los espacios y se queda con el primer campo: una IP por línea, seis líneas.
2. **Agrupar las repetidas.**
   `uniq -c` cuenta las líneas iguales, pero solo si están seguidas.
   Por eso hay que ordenar primero:

   ```console
   $ cut -d' ' -f1 acceso.log | sort | uniq -c
         2 10.0.0.7
         1 172.16.0.3
         3 192.168.1.10
   ```
3. **Ordenar por la cuenta.**
   `sort -nr` ordena numéricamente (`-n`) y de mayor a menor (`-r`), usando el número del principio de cada línea:

   ```console
   $ cut -d' ' -f1 acceso.log | sort | uniq -c | sort -nr
         3 192.168.1.10
         2 10.0.0.7
         1 172.16.0.3
   ```
4. **Quedarse con las primeras.**
   Añadir `| head -n 10` limita el resultado a las 10 IP más frecuentes.
   Si hay menos, como en el *log* de ejemplo, que solo tiene 3 IP distintas, `head` las muestra todas.

La secuencia `sort | uniq -c | sort -nr` es uno de los patrones más útiles del curso.
Cuenta cuántas veces aparece cada valor y los ordena de más a menos frecuente, sea cual sea el dato.

El estado de salida de una tubería es el de su último comando.
Si `cut` falla porque el fichero no existe, pero `head` termina bien, la tubería entera devuelve 0.
Veremos cómo cambiar eso en la semana 6.

## De líneas a argumentos: `xargs`

Algunos comandos, como `rm`, `ls` o `wc` con nombres de fichero, no leen de la entrada estándar lo que tienen que tratar, sino de sus argumentos.
**`xargs`** hace de puente: lee palabras de la entrada estándar y ejecuta el comando que se le indica con ellas como argumentos.

```console
$ find proyecto -name '*.[ch]' | xargs wc -c
   0 proyecto/src/util.h
2048 proyecto/src/main.c
2048 total
```

`xargs` separa las palabras por los espacios y los saltos de línea, así que un nombre con espacios llega partido:

```console
$ find proyecto -name '*.txt' | xargs wc -c
wc: proyecto/docs/guía: No existe el fichero o el directorio
wc: de: No existe el fichero o el directorio
wc: uso.txt: No existe el fichero o el directorio
0 total
```

Con `find`, la solución es separar los nombres con un carácter nulo, que no puede aparecer en una ruta (con `-print0`) y usar `-0` en `xargs` para indicarle que los trate como separados por nulos: `find proyecto -name '*.txt' -print0 | xargs -0 wc -c`.
Si `find` no encuentra nada, `xargs` ejecuta el comando igualmente, sin argumentos; con `-r`, no lo ejecuta.
