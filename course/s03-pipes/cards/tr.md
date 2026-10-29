¿Y si los campos están separados por varios espacios, o el fichero viene de Windows?
`tr` cambia unos caracteres por otros, los borra o comprime las repeticiones, carácter a carácter.

```text
tr [opciones] CONJUNTO1 [CONJUNTO2]
```

Solo lee de la entrada estándar: no acepta nombres de fichero.
Cada carácter de `CONJUNTO1` se cambia por el que ocupa la misma posición en `CONJUNTO2`.

## Ejemplo

```console
$ echo "hola mundo" | tr a-z A-Z
HOLA MUNDO
$ echo "/usr/local/bin:/usr/bin:/bin" | tr : '\n'
/usr/local/bin
/usr/bin
/bin
$ echo "a   b    c" | tr -s ' '
a b c
$ echo "tel: 922-31-82-00" | tr -cd '0-9\n'
922318200
```

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| (ninguna) | Cambia cada carácter de `CONJUNTO1` por el correspondiente de `CONJUNTO2` | `tr , ';'` |
| `-d`, `--delete` | Borra los caracteres de `CONJUNTO1` | `tr -d '\r'` |
| `-s`, `--squeeze-repeats` | Reduce cada secuencia de un mismo carácter a uno solo | `tr -s ' '` |
| `-c`, `--complement` | Usa todos los caracteres que no están en `CONJUNTO1` | `tr -cd '0-9'` |
| `-t`, `--truncate-set1` | Recorta `CONJUNTO1` a la longitud de `CONJUNTO2` | `tr -t abc xy` |

Con `-s` y dos conjuntos, primero traduce y después comprime: `tr -s ' ' '\n'` pone una palabra por línea aunque haya varios espacios seguidos.
Si `CONJUNTO2` es más corto, GNU repite su último carácter: `echo abc | tr abc xy` da `xyy`, y con `-t` da `xyc`.

## Tablas de referencia

Expresiones para definir conjuntos:

| Conjunto | Significa |
| --- | --- |
| `abc` | Los caracteres a, b y c |
| `a-z` | Rango de la a a la z |
| `[:lower:]`, `[:upper:]` | Minúsculas, mayúsculas |
| `[:digit:]` | Dígitos |
| `[:alpha:]`, `[:alnum:]` | Letras; letras y dígitos |
| `[:space:]` | Espacio, tabulador y saltos de línea |
| `[:blank:]` | Espacio y tabulador |
| `[:punct:]` | Signos de puntuación |
| `\n`, `\t`, `\r` | Salto de línea, tabulador, retorno de carro |
| `\\` | Una barra invertida |

Las clases van sin corchetes exteriores (`'[:lower:]'`, no `'[[:lower:]]'` como en `grep`), y siempre entre comillas.

## Combinaciones habituales

```bash
# Un directorio del PATH por línea
echo "$PATH" | tr ':' '\n'
```

```bash
# Convertir un fichero de Windows (fin de línea \r\n) a Unix
tr -d '\r' < windows.txt > unix.txt
```

```bash
# Las 10 palabras más frecuentes de un texto
tr -s ' ' '\n' < texto.txt | sort | uniq -c | sort -rn | head
```

::: details Paso a paso

1. `tr -s ' ' '\n' < texto.txt` cambia cada espacio por un salto de línea, y `-s` junta los que quedan seguidos, así que sale una palabra por línea:

   ```text
   el
   gato
   y
   el
   perro
   y
   el
   gato
   ```

2. `sort` las ordena, y así quedan juntas las repetidas:

   ```text
   el
   el
   el
   gato
   gato
   perro
   y
   y
   ```

3. `uniq -c` deja una línea por palabra, con las veces que aparece:

   ```text
         3 el
         2 gato
         1 perro
         2 y
   ```

4. `sort -rn` ordena por ese número, de mayor a menor:

   ```text
         3 el
         2 y
         2 gato
         1 perro
   ```

5. `head` deja las 10 primeras. Aquí solo hay cuatro palabras, así que salen todas.

:::

```bash
# Usuario y PID de cada proceso, comprimiendo los espacios para cut
ps aux | tr -s ' ' | cut -d' ' -f1,2
```

## Errores frecuentes

**`tr` no lee ficheros.**
El nombre del fichero se toma como un conjunto de más.

```bash
# ✗ tr: extra operand ‘notas.csv’
tr a-z A-Z notas.csv

# ✓
tr a-z A-Z < notas.csv
```

**Traduce caracteres, no palabras.**
Cada letra se cambia por la de su posición, sin mirar el orden.

```console
$ echo hola | tr hola adios
adio
```

Para cambiar palabras, `sed 's/hola/adios/g'`.

**Tildes y eñes.**
GNU `tr` trabaja byte a byte, así que no convierte las letras con tilde ni la ñ, aunque el *locale* sea español.

```console
$ echo 'canción ñandú' | tr '[:lower:]' '[:upper:]'
CANCIóN ñANDú
```

Para textos con tildes se puede usar GNU `sed`: `sed 's/.*/\U&/'` devuelve `CANCIÓN ÑANDÚ`.
La función `toupper` de `mawk` tiene el mismo problema que `tr`.

## Ver también

`man tr` · [ficha de `cut`](cut.md) · [ficha de `sort`](sort.md) · [ficha de `uniq`](uniq.md)
