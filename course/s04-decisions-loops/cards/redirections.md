¿A dónde va lo que escribe un comando y de dónde lee lo que procesa?
Lo deciden las redirecciones, que la *shell* prepara antes de ejecutar la orden y aplica de izquierda a derecha.
Esta ficha las reúne todas, también algunas que veremos más adelante; la columna «Semana» de las tablas dice en qué semana se explica cada una.

## Ejemplo

```console
$ ls proyecto /noexiste > salida.txt 2> errores.txt
$ cat salida.txt
proyecto:
docs
README.md
src
$ cat errores.txt
ls: no se puede acceder a '/noexiste': No existe el fichero o el directorio
```

## Tablas de referencia

El número delante de `>` o `<` es el descriptor que se redirige.
Si no se escribe, `>` es `1>` (la salida estándar) y `<` es `0<` (la entrada estándar).

Salida y error:

| Redirección | Efecto | Semana |
| --- | --- | --- |
| `> f` | Salida estándar a `f`, que se vacía antes si ya existía | 3 |
| `>> f` | Salida estándar al final de `f`, sin borrar lo que había | 3 |
| `2> f` | Error estándar a `f` | 3 |
| `2>> f` | Error estándar al final de `f` | 3 |
| `2>&1` | Error estándar al mismo sitio al que apunte la salida en ese momento | 3 |
| `>&2` | Salida estándar al mismo sitio que el error | 3 |
| `> /dev/null`, `2> /dev/null` | Descarta la salida o el error | 3 |

Entrada:

| Redirección | La entrada estándar viene de | Semana |
| --- | --- | --- |
| `< f` | El fichero `f` | 3 |
| `< <(orden)` | La salida de una orden, con la sustitución de procesos | 4 |
| `<<< "$v"` | El contenido de una cadena o una variable | 6 |
| `<< EOF` … `EOF` | Las líneas que siguen, hasta la línea `EOF` (*here document*) | 7 |
| `<<- EOF` … `EOF` | Igual, quitando los tabuladores del principio de cada línea | 7 |

Tuberías y grupos:

| Forma | Efecto | Semana |
| --- | --- | --- |
| `a \| b` | Salida estándar de `a` a la entrada estándar de `b`; el error sigue en la pantalla | 3 |
| `{ a; b; } > f` | Una redirección para todas las órdenes del grupo | 3 |
| `( a; b ) > f` | Igual, pero el grupo se ejecuta en una *subshell* | 3 |
| `while …; done < f` | Una redirección para todo el bucle | 4 |

Descriptores de la propia *shell*:

| Orden | Efecto | Semana |
| --- | --- | --- |
| `exec 3< f` | La *shell* abre `f` para lectura como descriptor 3 y lo deja abierto | 6 |
| `exec 3<&-` | Cierra el descriptor 3 | 6 |

## Combinaciones habituales

```bash
# Guardar la salida y los errores en el mismo fichero
ls proyecto /noexiste > registro.txt 2>&1
```

```bash
# Verlos en la pantalla y guardarlos a la vez
ls proyecto /noexiste 2>&1 | tee registro.txt
```

```bash
# Ejecutar sin ver los errores
ls proyecto /noexiste 2> /dev/null
```

```bash
# Mensaje de error de un script
echo "Error: no se puede leer $log" >&2
```

```bash
# Guardar el número de líneas, sin el nombre del fichero
n=$(wc -l < notas.csv)
```

```bash
# Un título y un resultado en el mismo fichero
{ echo "Notas de SSOO:"; grep SSOO notas.csv; } > ssoo.txt
```

```bash
# Recorrer la salida de una orden sin perder las variables del bucle
n=0
while IFS=, read -r _ _ nota; do
    [[ -z $nota ]] && n=$((n + 1))
done < <(tail -n +2 notas.csv)
echo "$n sin nota"    # 2 sin nota
```

```bash
# Repartir una cadena en variables (semana 6)
IFS=: read -r h m s <<< "08:09:10"
```

## Errores frecuentes

**`2>&1` antes de `>`.**
`2>&1` hace que el error estándar apunte a donde apunta la salida estándar en ese momento, que aún es la pantalla.
Después, la salida estándar se redirige al fichero, pero el error estándar no ve este cambio:

```console
$ ls proyecto /noexiste 2>&1 > salida.txt
ls: no se puede acceder a '/noexiste': No existe el fichero o el directorio
```

Para tener los dos en el mismo fichero, `2>&1` va al final: `> salida.txt 2>&1`.

**Redirigir al mismo fichero que se lee.**
`sort notas.csv > notas.csv` deja `notas.csv` vacío, porque la *shell* lo vacía al preparar la redirección, antes de que `sort` empiece a leer.
Escribe en otro fichero y renómbralo después, o usa la opción del comando que indica el fichero de salida, como `sort -o`.

```bash
# ✗ notas.csv queda vacío
sort notas.csv > notas.csv

# ✓
sort notas.csv > notas.tmp && mv notas.tmp notas.csv
```

**La tubería solo lleva la salida.**
El error de `ls` no llega a `wc`, que cuenta 0 líneas:

```console
$ ls /noexiste | wc -l
ls: no se puede acceder a '/noexiste': No existe el fichero o el directorio
0
```

Con `ls /noexiste 2>&1 | wc -l`, el error también pasa por la tubería y `wc` cuenta 1.

**Un `while` al final de una tubería.**
El bucle se ejecuta en un proceso aparte, y lo que cambie en sus variables se pierde al terminar.
Con `tail -n +2 notas.csv | while …`, el contador del último ejemplo de «Combinaciones habituales» valdría 0 al salir.
Para conservarlo, mejor usar `done < <(orden)`.

**`>2` en lugar de `>&2`.**
Sin `&`, `2` es el nombre de un fichero:

```console
$ echo "Error" >2
$ cat 2
Error
```

**Las llaves sin espacio o sin `;`.**
`{echo hola; }` es un error de sintaxis, porque bash lee `{echo` como una sola palabra.
Con `{ echo hola }`, bash toma `}` como un argumento más de `echo` y sigue esperando la llave de cierre.

## Ver también

`man bash` («REDIRECTION») · lectura «[Redirecciones](../../s03-pipes/redirections.md)» · lectura «[Tuberías](../../s03-pipes/pipes.md)» · lectura «[Leer línea a línea](../reading-lines.md)» · patrón «[Recorrer líneas](../patterns/loop-over-lines.md)» · [ficha de `lsof`](../../s06-processes-users/cards/lsof.md) (`exec 3<`) · lectura «[Una ayuda con here document](../../s07-robust-scripts/here-documents.md)»
