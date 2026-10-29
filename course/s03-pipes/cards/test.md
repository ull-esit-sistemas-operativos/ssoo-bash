¿Existe el fichero, es un número, me han pasado un argumento?
`[[ ]]` comprueba una condición y termina con estado 0 si es verdadera y 1 si es falsa, que es lo que miran `if`, `while`, `&&` y `||`.

## Forma

```text
[[ EXPRESIÓN ]]      # bash
test EXPRESIÓN       # POSIX
[ EXPRESIÓN ]        # POSIX, igual que test
```

Los espacios junto a los corchetes son obligatorios: pues `[[` es una palabra.
En los *scripts* del curso se usa `[[ ]]` pero podemos encontrarnos `test` y `[ ]` en *scripts* antiguos y en los que tienen que funcionar en `sh`.

## Ejemplo

```console
$ [[ -f notas.csv ]]; echo $?
0
$ [[ -d notas.csv ]]; echo $?
1
$ n=10; [[ $n -gt 9 ]] && echo mayor
mayor
```

## Operadores

Cadenas:

| Operador | Verdadero si | Ejemplo |
| --- | --- | --- |
| `-z CAD` | La cadena está vacía | `[[ -z $1 ]]` |
| `-n CAD` | La cadena no está vacía | `[[ -n $nombre ]]` |
| `A == B`, `A = B` | Son iguales; en `[[ ]]`, `B` sin comillas puede usar comodines | `[[ $f == *.txt ]]` |
| `A != B` | Son distintas | `[[ $opt != -h ]]` |
| `A < B`, `A > B` | `A` va antes o después en orden alfabético | `[[ $a < $b ]]` |
| `A =~ REGEX` | `A` encaja con la expresión regular extendida (solo `[[ ]]`) | `[[ $n =~ ^[0-9]+$ ]]` |

Números enteros:

| Operador | Verdadero si | Ejemplo |
| --- | --- | --- |
| `-eq`, `-ne` | Igual, distinto | `[[ $# -eq 2 ]]` |
| `-lt`, `-le` | Menor, menor o igual | `[[ $n -lt 10 ]]` |
| `-gt`, `-ge` | Mayor, mayor o igual | `[[ $edad -ge 18 ]]` |

Existencia y tipo de fichero:

| Operador | Verdadero si | Ejemplo |
| --- | --- | --- |
| `-e F` | Existe (de cualquier tipo) | `[[ -e $f ]]` |
| `-f F` | Existe y es un fichero regular | `[[ -f $f ]]` |
| `-d F` | Existe y es un directorio | `[[ -d $dir ]]` |
| `-L F`, `-h F` | Es un enlace simbólico (aunque esté roto) | `[[ -L $f ]]` |
| `-p F` | Es una tubería con nombre | `[[ -p $f ]]` |
| `-S F` | Es un *socket* | `[[ -S $f ]]` |
| `-b F`, `-c F` | Es un dispositivo de bloques o de caracteres | `[[ -b /dev/sda ]]` |

Permisos y propiedad, para el usuario que ejecuta el *script*:

| Operador | Verdadero si | Ejemplo |
| --- | --- | --- |
| `-r F` | Existe y se puede leer | `[[ -r $f ]]` |
| `-w F` | Existe y se puede escribir | `[[ -w $f ]]` |
| `-x F` | Existe y se puede ejecutar (o entrar, si es directorio) | `[[ -x $f ]]` |
| `-O F` | Existe y su propietario es el usuario actual | `[[ -O $f ]]` |
| `-G F` | Existe y su grupo es el grupo del usuario actual | `[[ -G $f ]]` |
| `-u F`, `-g F` | Tiene el bit *setuid* o *setgid* | `[[ -u /usr/bin/passwd ]]` |
| `-k F` | Tiene el bit *sticky* | `[[ -k /tmp ]]` |

Tamaño y fechas:

| Operador | Verdadero si | Ejemplo |
| --- | --- | --- |
| `-s F` | Existe y no está vacío | `[[ -s $log ]]` |
| `A -nt B` | `A` es más reciente que `B` (o `B` no existe) | `[[ $src -nt $bin ]]` |
| `A -ot B` | `A` es más antiguo que `B` | `[[ $a -ot $b ]]` |
| `A -ef B` | Son el mismo fichero (mismo nodo-i) | `[[ $a -ef $b ]]` |

Variables y lógica:

| Operador | Verdadero si | Ejemplo |
| --- | --- | --- |
| `-v NOMBRE` | La variable está definida, aunque esté vacía | `[[ -v TMPDIR ]]` |
| `! EXPR` | `EXPR` es falsa | `[[ ! -d $dir ]]` |
| `A && B` | Las dos (en `[ ]`: `-a`, o dos `[ ]` con `&&`) | `[[ -f $f && -r $f ]]` |
| `A \|\| B` | Alguna (en `[ ]`: `-o`) | `[[ $op == -h \|\| $op == --help ]]` |
| `( EXPR )` | Agrupa (en `[ ]`: `\( \)`) | `[[ ( -f $a \|\| -f $b ) && -d $d ]]` |

Tras un `=~` con éxito, `${BASH_REMATCH[0]}` guarda lo que encajó y `${BASH_REMATCH[1]}`, `${BASH_REMATCH[2]}`…, lo que encajó con cada grupo entre paréntesis.

## Tablas de referencia

Diferencias entre `[[ ]]` y `[ ]` o `test`:

|  | `[[ ]]` | `[ ]` y `test` |
| --- | --- | --- |
| Variables sin comillas | Seguro: no se parten ni se expanden comodines | Hay que entrecomillar siempre |
| «y», «o» | `&&`, `\|\|` | `-a`, `-o`, o varios `[ ]` |
| `<` y `>` | Comparan cadenas | Hay que escaparlos (`\<`), si no son redirecciones |
| Comodines con `==` | Sí | No |
| `=~` | Sí | No |
| Funciona en `sh` | No | Sí |

## Combinaciones habituales

```bash
# Comprobar el número de argumentos
[[ $# -eq 1 ]] || { echo "uso: $0 directorio" >&2; exit 1; }

# Comprobar que el argumento es un directorio
if [[ ! -d $1 ]]; then
    echo "$1 no es un directorio" >&2
    exit 1
fi

# Comprobar que es un número entero positivo
re='^[0-9]+$'
[[ $n =~ $re ]] || { echo "no es un número: $n" >&2; exit 1; }

# Ficheros ejecutables del directorio actual
for f in *; do [[ -f $f && -x $f ]] && echo "$f"; done
```

Guardar la expresión regular en una variable evita problemas con las comillas y los caracteres especiales.

## Errores frecuentes

**Faltan espacios.**
Sin espacio, `[[10` es una palabra y bash busca un comando con ese nombre.

```console
$ [[$n -gt 9]]
bash: [[10: command not found
```

**`<` compara texto, no números.**
`10` va antes que `9` alfabéticamente.

```bash
# ✗ Verdadero: «10» < «9» como texto
[[ 10 < 9 ]]

# ✓ Falso
[[ 10 -lt 9 ]]
```

**Variable vacía sin comillas en `[ ]`.**
La variable desaparece y a `[` le falta un operando.

```console
$ v=""; [ $v = x ]
bash: [: =: unary operator expected
$ [ "$v" = x ]; echo $?
1
```

En `[[ ]]` no pasa, pero entrecomillar siempre no hace daño.

**La expresión regular entre comillas.**
En `[[ ]]`, lo que va entre comillas tras `=~` se compara como texto literal.

```bash
# ✗ Busca el texto literal ^[0-9]+$
[[ 42 =~ "^[0-9]+$" ]]

# ✓
re='^[0-9]+$'; [[ 42 =~ $re ]]
```

**`-eq` con algo que no es un número.**
En `[[ ]]`, los operandos de `-eq` se evalúan como aritmética: `abc` se toma como una variable (vacía, 0) y `010` como octal (8).
Comprueba antes usando `=~` que el valor es un número.

```bash
n=abc
# ✗ Dice «es cero»: abc se toma como una variable vacía (0)
[[ $n -eq 0 ]] && echo "es cero"

# ✓ Primero, que solo tenga dígitos; luego, en base 10 (010 vale 10, no 8)
if [[ $n =~ ^[0-9]+$ ]] && [[ $((10#$n)) -eq 0 ]]; then
  echo "es cero"
else
  echo "no es un número o no es cero"
fi
```

## Ver también

`help test` · `help [[` · `man bash` («CONDITIONAL EXPRESSIONS») · [ficha de `find`](../../s02-files/cards/find.md) (pruebas parecidas)
