A veces no necesitamos todo el valor de una variable, sino una parte: la extensión de un fichero, su nombre sin extensión o el directorio de una ruta.
Otras veces queremos cambiarlo un poco o dar un valor por defecto si está vacía.
bash tiene expansiones para todo ello.

## Quitar y cambiar con patrones

Las expansiones que quitan o cambian una parte la describen con un patrón de comodines, como los de los nombres de fichero:

| Expansión | Qué hace | Resultado con `f=informe.final.pdf` |
| --- | --- | --- |
| `${f#*.}` | Quita del principio el trozo más corto que encaja | `final.pdf` |
| `${f##*.}` | Quita del principio el trozo más largo | `pdf` |
| `${f%.*}` | Quita del final el trozo más corto | `informe.final` |
| `${f%%.*}` | Quita del final el trozo más largo | `informe` |
| `${f/./_}` | Cambia el primer trozo que encaja por `_` | `informe_final.pdf` |
| `${f//./_}` | Cambia todos los trozos que encajan por `_` | `informe_final_pdf` |
| `${f//.}` | Borra todos los trozos que encajan | `informefinalpdf` |
| `${f^^}` | Pasa el valor a mayúsculas | `INFORME.FINAL.PDF` |
| `${f,,}` | Pasa el valor a minúsculas | `informe.final.pdf` |

Con rutas funcionan igual: si `r=/home/alu/notas.csv`, `${r##*/}` deja `notas.csv` y `${r%/*}` deja `/home/alu`.
Y una forma habitual de usar `//` es quitar los espacios de un nombre de fichero:

```console
$ n="guía de uso.txt"
$ echo "${n// /_}"
guía_de_uso.txt
```

## Longitud y posiciones

Otras expansiones cuentan los caracteres del valor o sacan una porción del mismo por su posición, contando desde 0:

| Expansión | Qué hace | Resultado con `d=2026-10-31` |
| --- | --- | --- |
| `${#d}` | Número de caracteres | `10` |
| `${d:5:2}` | 2 caracteres a partir de la posición 5 | `10` |
| `${d:5}` | Desde la posición 5 hasta el final | `10-31` |
| `${d: -2}` | Los 2 últimos caracteres | `31` |

El espacio de `${d: -2}` es necesario: sin él, bash lee `:-` y la toma por un valor por defecto, así que `${d:-2}` vale `2026-10-31`.

## Valores por defecto y obligatorios

`${v:-defecto}` vale lo que tenga `v` o, si está vacía o no existe, el texto indicado.
Es especialmente útil con argumentos: `dir=${1:-.}` toma el primer argumento o, si no se pasó ninguno, el directorio actual.
La variable no cambia; en la semana 6 la usaremos para dar valores por defecto a las opciones de un *script*.

`${v:?mensaje}` hace lo contrario: si la variable está vacía o no existe, bash escribe el mensaje en el error estándar y, en un *script*, lo termina con el código de salida 1.
Si `copia.sh` empieza con `origen=${1:?falta el fichero de origen}` y lo ejecutamos sin argumentos, sale esto:

```console
$ ./copia.sh
./copia.sh: línea 2: 1: falta el fichero de origen
$ echo $?
1
```

Es una forma rápida de exigir un argumento, pero no elegimos el formato del mensaje, que lleva delante el nombre del *script*, la línea y la variable.
Para mensajes más claros, como el de uso, seguimos comprobando `$#` con un `if`.
