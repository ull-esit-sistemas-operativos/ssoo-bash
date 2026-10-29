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
  Los números admiten decimales, que se leen y se escriben según la configuración regional.

Veamos varios programas sobre `notas_es.csv`, cada uno algo más completo que el anterior:

```bash
awk -F';' 'NR > 1 { print $1, $3 }' notas_es.csv
awk -F';' 'NR > 1 && $3 != "" && $3 >= 5 { print $1, $2 }' notas_es.csv
awk -F';' 'NR > 1 && $3 != "" { s += $3; n++ } END { printf "%.2f\n", s / n }' notas_es.csv
```

El primero imprime alumno y nota, saltando la cabecera.
El segundo, los aprobados.
El tercero suma las notas no vacías y, al final, imprime su media con dos decimales: 7,10.

## Agrupar por clave con *arrays*

¿Y la media de cada asignatura?
Necesitamos una suma y un contador por asignatura.
Los *arrays* de `awk` se indexan con cualquier texto, así que la asignatura —en la segunda columna— puede ser la clave:

```bash
awk -F';' 'NR > 1 && $3 != "" { suma[$2] += $3; n[$2]++ }
          END { for (a in suma) printf "%-10s %5.2f\n", a, suma[a] / n[a] }' notas_es.csv
```

El `for (a in suma)`, al terminar de procesar el fichero, recorre las claves en un orden que no fija `awk`, así que la salida de la orden anterior no está ordenada.
Si queremos un orden concreto, pasamos la salida de `awk` por `sort`.
Este patrón, acumular en un *array* por clave y recorrerlo en `END`, sirve para cualquier «total por»: peticiones por IP, memoria por usuario, notas por alumno, etc.
