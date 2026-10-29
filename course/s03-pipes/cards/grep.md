¿Qué líneas del *log* contienen un error 404?
`grep` se queda con las líneas que encajan con un patrón —una expresión regular—, y descarta el resto.

```text
grep [opciones] PATRÓN [fichero...]
```

Sin fichero, lee de la entrada estándar.
Su estado de salida es 0 si encontró alguna línea, 1 si no encontró ninguna y 2 si hubo un error.
Así que sirve directamente como condición de un `if`.

## Ejemplo

```console
$ grep 404 acceso.log
10.0.0.7 - - [21/Oct/2026:10:15:40 +0200] "GET /logo.png HTTP/1.1" 404 512
10.0.0.7 - - [21/Oct/2026:10:17:16 +0200] "GET /favicon.ico HTTP/1.1" 404 512
192.168.1.10 - - [21/Oct/2026:10:18:44 +0200] "GET /tema2.html HTTP/1.1" 404 512
$ grep -c '" 404 ' acceso.log
3
$ grep -n tema acceso.log
3:192.168.1.10 - - [21/Oct/2026:10:16:02 +0200] "GET /tema1.html HTTP/1.1" 200 8340
6:192.168.1.10 - - [21/Oct/2026:10:18:44 +0200] "GET /tema2.html HTTP/1.1" 404 512
```

El segundo patrón incluye las comillas y los espacios para encontrar el código de estado y no un 404 que aparezca en la URL o en los bytes.

## Opciones útiles

Qué líneas encajan:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-v`, `--invert-match` | Las líneas que no encajan | `grep -v '^#'` |
| `-i`, `--ignore-case` | Sin distinguir mayúsculas | `grep -i error` |
| `-w`, `--word-regexp` | El patrón tiene que ser una palabra completa | `grep -w ana` |
| `-x`, `--line-regexp` | El patrón tiene que ocupar la línea entera | `grep -x ana` |
| `-e PATRÓN` | Otro patrón más. También sirve para proteger patrones que empiezan por `-` | `grep -e 404 -e 500` |
| `-f FICHERO` | Lee los patrones de un fichero, uno por línea | `grep -f ips.txt` |

Cómo se interpreta el patrón:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| (por defecto) | Expresión regular básica | `grep 'a.b'` |
| `-E`, `--extended-regexp` | Expresión regular extendida ([tabla de referencia](#expresiones-regulares-basicas-sin-opcion-y-extendidas-e)) | `grep -E '[0-9]{3}'` |
| `-F`, `--fixed-strings` | Texto literal, sin caracteres especiales | `grep -F 'a.b'` |

Qué se muestra:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-c`, `--count` | El número de líneas que encajan | `grep -c 404` |
| `-n`, `--line-number` | El número de cada línea delante | `grep -n TODO` |
| `-o`, `--only-matching` | Solo el trozo que encaja, uno por línea | `grep -o '[0-9.]*'` |
| `-q`, `--quiet` | Nada. Solo se puede mirar el estado de salida | `grep -q root` |
| `-m N`, `--max-count=N` | Para tras N líneas encontradas | `grep -m 1 error` |
| `-s`, `--no-messages` | Ignora los errores de ficheros que no existen | `grep -s x *.log` |

Con varios ficheros:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-l`, `--files-with-matches` | Solo los nombres de los ficheros con alguna línea | `grep -l 404 *.log` |
| `-L`, `--files-without-match` | Solo los nombres de los ficheros sin ninguna | `grep -L 404 *.log` |
| `-h`, `--no-filename` | Sin el nombre del fichero delante de cada línea | `grep -h 404 *.log` |
| `-H`, `--with-filename` | Con el nombre del fichero, aunque sea solo uno | `grep -H 404 a.log` |
| `-r`, `--recursive` | Busca en todos los ficheros de un directorio | `grep -r TODO src` |
| `--include=COMODÍN` | Con `-r`, solo los ficheros que encajan | `--include='*.sh'` |
| `--exclude=COMODÍN` | Con `-r`, salta los ficheros que encajan | `--exclude='*.bak'` |

Contexto:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-A N`, `--after-context=N` | Añade las N líneas siguientes | `grep -A 2 error` |
| `-B N`, `--before-context=N` | Añade las N líneas anteriores | `grep -B 2 error` |
| `-C N`, `--context=N` | Añade N líneas antes y después | `grep -C 1 error` |

## Tablas de referencia

Expresiones regulares básicas (sin opción) y extendidas (`-E`):

| Básica | Extendida | Significado |
| --- | --- | --- |
| `.` | `.` | Cualquier carácter |
| `*` | `*` | El elemento anterior, 0 o más veces |
| `\+` | `+` | 1 o más veces |
| `\?` | `?` | 0 o 1 vez |
| `\{N,M\}` | `{N,M}` | Entre N y M veces; `{N}` exactamente N, `{N,}` N o más |
| `\( \)` | `( )` | Agrupa |
| `^`, `$` | `^`, `$` | Principio y final de línea |
| `[abc]` | `[abc]` | Uno de esos caracteres; `[a-z]` un rango |
| `[^abc]` | `[^abc]` | Cualquier carácter menos esos |
| `\<`, `\>` | `\<`, `\>` | Principio y final de palabra |
| `\.` | `\.` | Un punto literal (igual con cualquier carácter especial) |

Para indicar patrones alternativos («este o aquel») se escribe con una barra vertical: en extendidas es `grep -E 'GET|POST'`; en expresiones básicas hay que escaparla con una barra invertida delante `\|`.
En básicas, `+`, `?`, `{` y los paréntesis sin barra invertida `\` para escapar son caracteres normales.

Clases con nombre, dentro de corchetes:

| Clase | Equivale a |
| --- | --- |
| `[[:digit:]]` | `[0-9]` |
| `[[:alpha:]]` | Letras, incluidas las acentuadas y la ñ |
| `[[:alnum:]]` | Letras y dígitos |
| `[[:upper:]]`, `[[:lower:]]` | Mayúsculas, minúsculas |
| `[[:space:]]` | Espacio, tabulador y saltos de línea |
| `[[:blank:]]` | Espacio y tabulador |
| `[[:punct:]]` | Signos de puntuación |

## Combinaciones habituales

```bash
# Cuántas peticiones dieron 404
grep -c '" 404 ' acceso.log
```

```bash
# Qué IP distintas provocaron un 404
grep '" 404 ' acceso.log | cut -d' ' -f1 | sort -u
```

::: details Paso a paso

1. `grep '" 404 ' acceso.log` deja las peticiones que dieron 404:

   ```text
   10.0.0.7 - - [21/Oct/2026:10:15:40 +0200] "GET /logo.png HTTP/1.1" 404 512
   10.0.0.7 - - [21/Oct/2026:10:17:16 +0200] "GET /favicon.ico HTTP/1.1" 404 512
   192.168.1.10 - - [21/Oct/2026:10:18:44 +0200] "GET /tema2.html HTTP/1.1" 404 512
   ```

2. `cut -d' ' -f1` deja la IP de cada una:

   ```text
   10.0.0.7
   10.0.0.7
   192.168.1.10
   ```

3. `sort -u` las ordena y quita las repetidas:

   ```text
   10.0.0.7
   192.168.1.10
   ```

:::

```bash
# Un fichero de configuración sin comentarios ni líneas vacías
grep -v '^#' config.txt | grep -v '^$'
```

```bash
# Qué scripts usan la palabra read
grep -rlw read --include='*.sh' .
```

```bash
# Como condición: ¿existe el usuario?
if grep -q "^$usuario:" /etc/passwd; then echo "existe"; fi
```

En la última, los dos puntos tras el nombre evitan que `alu` encaje con `alumno:`.

## Errores frecuentes

**`-c` cuenta líneas, no apariciones.**
Una línea con el patrón dos veces cuenta una sola vez.

```console
$ cat n.txt
ana ana
luis
$ grep -c ana n.txt
1
$ grep -o ana n.txt | wc -l
2
```

**`+` en una expresión básica.**
Sin `-E`, `+`, `?`, `{}`, los paréntesis y la barra vertical son caracteres literales, así que el patrón no encaja y `grep` no avisa.

```bash
# ✗ Busca el texto «10+» literal: 0 líneas
grep -c '10+' acceso.log

# ✓
grep -E -c '10+' acceso.log
```

**Un patrón que empieza por guion.**
Si la variable `$patron` vale, por ejemplo, `-v`, `grep` la toma por una opción y usa el fichero como patrón.
Como ya no le queda ningún fichero, se queda esperando a leer de la entrada estándar.

```bash
# ✗ Con patron='-v', se queda colgado
grep "$patron" fichero

# ✓
grep -e "$patron" fichero
```

**Patrón sin comillas.**
Los espacios lo parten en varios argumentos y la *shell* expande `*` y `?` como comodines.
El patrón va siempre entre comillas simples, o dobles si lleva una variable.

## Ver también

`man grep` · [ficha de `cut`](cut.md) · [ficha de `wc`](wc.md) · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md) (filtrar por campo)
