A veces no necesitamos todo el valor de una variable, sino una parte: la extensión de un fichero, su nombre sin extensión o el directorio de una ruta.
Otras veces queremos cambiarlo un poco o dar un valor por si está vacía. bash tiene expansiones para todo ello.
Las que quitan un trozo lo describen con un patrón de comodines, como los de los nombres de fichero:

| Expansión | Qué hace | Resultado con `f=informe.final.pdf` |
| --- | --- | --- |
| `${f#*.}` | Quita del principio el trozo más corto que encaja | `final.pdf` |
| `${f##*.}` | Quita del principio el trozo más largo | `pdf` |
| `${f%.*}` | Quita del final el trozo más corto | `informe.final` |
| `${f%%.*}` | Quita del final el trozo más largo | `informe` |
| `${f^^}` | Pasa el valor a mayúsculas | `INFORME.FINAL.PDF` |
| `${f,,}` | Pasa el valor a minúsculas | `informe.final.pdf` |
| `${g:-sin nombre}` | Vale lo que tenga `g` o, si está vacía o no existe, el texto indicado | `sin nombre`, si `g` no existe |

Con rutas funcionan igual: si `r=/home/alu/notas.csv`, `${r##*/}` deja `notas.csv` y `${r%/*}` deja `/home/alu`.

`${v:-defecto}` es especialmente útil con argumentos: `dir=${1:-.}` toma el primer argumento o, si no se pasó ninguno, el directorio actual.
La variable no cambia; en la semana 6 la usaremos para dar valores por defecto a las opciones de un *script*.
