`cut` extrae campos, pero no puede comparar, sumar ni calcular medias.
Para eso necesitamos algo más parecido a un lenguaje de programación.

**awk** es un pequeño lenguaje que lee el texto línea a línea, divide cada línea en campos y ejecuta las acciones cuyo patrón se cumple.
Un programa de `awk` es una lista de pares `patrón { acción }`, y se escribe así:

```text
awk opciones... 'patrón { acción } patrón { acción }...' archivo
```

- **Patrones.**
  Una condición (`$3 >= 5`, `$2 == "SSOO"`, `NR > 1`) o una expresión regular entre barras (`/^ana,/`).
  Para las líneas que cumplen la condición o encajan con la expresión regular, se ejecuta la acción correspondiente.
  En patrones y acciones se pueden usar los campos de la línea y variables especiales como `NR`, que es el número de la línea actual.
  Sin patrón, la acción se aplica a todas las líneas.
- **`BEGIN` y `END`.**
  Patrones especiales para indicar acciones que se ejecutan antes de leer la primera línea y después de la última.
- **Campos.**
  `$1`, `$2`… son los campos de la línea actual, `$0` la línea completa y `NF` el número de campos.
  Si no se usa `-F`, el separador es cualquier secuencia de espacios, así que `awk` no tiene el problema de `cut` con los espacios repetidos.
- **Separador.**
  La opción `-F` indica el separador de campos: `-F,` divide por comas y `-F';'` por punto y coma.
- **Variables.**
  No se declaran, se pueden usar en acciones y patrones y empiezan valiendo 0 o la cadena vacía.
  Los números admiten decimales (ver «Decimales», más abajo).

> [!NOTE] Distintas versiones, distinto comportamiento
> `awk` tiene varias versiones, y en cada sistema el comando `awk` puede ser una u otra.
> En muchos es `mawk`, pero en otros sistemas es `gawk`, la versión del proyecto GNU.
> Se diferencian en detalles como los decimales o las tildes, así que en el curso escribimos siempre `gawk` en lugar de `awk`, para no depender de cuál sea el que está instalado en el sistema como versión por defecto.
> Para saber cuál es tu `awk`, `awk -W version` muestra `mawk` o `GNU Awk`.

Veamos varios programas sobre `notas.csv`, cada uno algo más completo que el anterior:

```bash
gawk -F, 'NR > 1 { print $1, $3 }' notas.csv
gawk -F, 'NR > 1 && $3 != "" && $3 >= 5 { print $1, $2 }' notas.csv
gawk -F, 'NR > 1 && $3 != "" { s += $3; n++ } END { printf "%.2f\n", s / n }' notas.csv
```

El primero imprime alumno y nota, saltando la cabecera.
El segundo, los aprobados.
El tercero suma las notas no vacías y, al final, imprime su media con dos decimales: 7.10.

## Decimales

`gawk` lee y escribe los números siempre con punto, sea cual sea la configuración regional, por eso la media de `notas.csv` sale bien aunque el equipo esté en español.
Cuando queremos que siga la configuración regional, para leer datos con coma o escribir los resultados con coma, se lo pedimos con `--use-lc-numeric`:

```console
$ gawk --use-lc-numeric -F';' 'NR > 1 && $3 != "" { s += $3; n++ } END { printf "%.2f\n", s / n }' notas_es.csv
7,10
$ gawk --use-lc-numeric -F, 'NR > 1 && $3 != "" { s += $3; n++ } END { printf "%.2f\n", s / n }' notas.csv
6,80
```

Con `notas.csv`, la opción hace que `gawk` lea `7.5` como 7 y `4.5` como 4, y la media sale mal.
En el programa, en cambio, los números van siempre con punto, porque son código y no datos: `$3 >= 7.5` compara con siete y medio aunque los datos usen coma.

## Agrupar por clave con *arrays*

¿Y la media de cada asignatura?
Necesitamos una suma y un contador por asignatura.
Los *arrays* de `awk` se indexan con cualquier texto, así que la asignatura —en la segunda columna— puede ser la clave:

```bash
gawk -F, 'NR > 1 && $3 != "" { suma[$2] += $3; n[$2]++ }
       END { for (a in suma) printf "%-10s %5.2f\n", a, suma[a] / n[a] }' notas.csv
```

El `for (a in suma)`, al terminar de procesar el fichero, recorre las claves en un orden que no fija `awk`, así que la salida de la orden anterior no está ordenada.
Si queremos un orden concreto, pasamos la salida de `awk` por `sort`.
Este patrón, acumular en un *array* por clave y recorrerlo en `END`, sirve para cualquier «total por»: peticiones por IP, memoria por usuario, notas por alumno, etc.
