¿Cuál es la media de cada asignatura?
Cuando `cut` y `grep` se quedan cortos, `awk` es la mejor solución.
Lee cada línea, la parte en campos y ejecuta un pequeño programa sobre cada línea.
Así puede filtrar líneas por una condición sobre un campo, sumar, contar por clave o imprimir con formato.

```text
awk [-F SEPARADOR] [-v VAR=VALOR] 'PROGRAMA' [fichero...]
```

El programa es una lista de reglas `PATRÓN { ACCIÓN }`.
Para cada línea, ejecuta la acción de cada regla cuyo patrón se cumple.
Sin patrón, la acción se ejecuta en todas las líneas; sin acción, se imprime la línea.
Sin fichero, lee de la entrada estándar.

En Ubuntu, `awk` es `mawk`.
Todo lo de esta ficha es `awk` estándar y funciona igual en `mawk` y en `gawk`, salvo donde se indique lo contrario.

## Ejemplo

```console
$ awk -F, '{print $1, $3}' notas.csv
alumno nota
ana 7.5
ana 6
luis 4.5
luis 
marta 9
marta 8.5
pablo 
$ awk -F, 'NR > 1 && $3 >= 9' notas.csv
marta,SSOO,9
$ LC_ALL=C awk -F, 'NR > 1 && $3 != "" { s += $3; n++ } END { print s / n }' notas.csv
7.1
```

El tercero calcula la media, sin contar las notas vacías, que valdrían 0.
El `LC_ALL=C` hace falta por los decimales con punto (ver el apartado «[Errores frecuentes](#errores-frecuentes)»).

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-F SEP` | Separador de campos: un carácter o una expresión regular. Por defecto, uno o más blancos, ignorando los del principio | `awk -F,` |
| `-v VAR=VALOR` | Define una variable antes de empezar. Así se pasan valores de la *shell* | `awk -v u="$USER"` |
| `-f FICHERO` | Lee el programa de un fichero | `awk -f informe.awk` |

## Tablas de referencia

Variables internas:

| Variable | Contiene |
| --- | --- |
| `$0` | La línea entera |
| `$1`, `$2`… | Los campos; `$NF` es el último y `$(NF-1)` el penúltimo |
| `NF` | Número de campos de la línea |
| `NR` | Número de línea, contando todas las de todos los ficheros |
| `FNR` | Número de línea dentro del fichero actual |
| `FILENAME` | Nombre del fichero actual |
| `FS`, `OFS` | Separador de campos de entrada y de salida (por defecto, un espacio) |
| `RS`, `ORS` | Separador de registros de entrada y de salida (por defecto, el salto de línea) |

Patrones:

| Patrón | Se cumple en | Ejemplo |
| --- | --- | --- |
| `/REGEX/` | Las líneas que encajan | `/404/` |
| `EXPR` | Las líneas en que la expresión es verdadera | `$3 >= 5` |
| `$N ~ /REGEX/` | Las líneas cuyo campo N encaja | `$7 ~ /bash$/` |
| `$N !~ /REGEX/` | Las líneas cuyo campo N no encaja | `$1 !~ /^#/` |
| `P1 && P2`, `P1 \|\| P2`, `!P` | Combinaciones | `NR > 1 && $2 == "SSOO"` |
| `BEGIN` | Una vez, antes de leer nada | `BEGIN { FS = "," }` |
| `END` | Una vez, después de la última línea | `END { print n }` |
| `P1, P2` | Desde la línea que cumple `P1` hasta la que cumple `P2` | `NR == 2, NR == 4` |

Operadores:

| Operador | Qué hace |
| --- | --- |
| `+ - * / % ^` | Aritmética, con decimales; `%` es el resto y `^` la potencia |
| `+= -= *= /= ++ --` | Asignación con operación e incremento |
| `== != < <= > >=` | Comparación: numérica si los dos lados son números, de texto si no |
| (espacio) | Concatena: `$1 "-" $2` |
| `~`, `!~` | Encaja o no con una expresión regular |
| `&& \|\| !` | Y, o, no |
| `CLAVE in ARRAY` | Verdadero si la clave existe en el *array* |
| `COND ? A : B` | `A` si la condición es verdadera, `B` si no |

Control y *arrays*:

| Instrucción | Qué hace |
| --- | --- |
| `if (COND) { … } else { … }` | Condicional |
| `for (i = 1; i <= NF; i++) { … }` | Bucle con contador (aquí, sobre los campos) |
| `for (k in a) { … }` | Recorre las claves de un *array*, en un orden no definido |
| `while (COND) { … }` | Bucle mientras se cumpla |
| `a[k] += $3`, `a[k]++` | Arrays asociativos. La clave puede ser cualquier texto y no hace falta declararlos |
| `delete a[k]` | Borra una clave |
| `next` | Pasa a la línea siguiente sin ejecutar las reglas que quedan |
| `exit [N]` | Termina (ejecutando `END`) con estado N |

Funciones:

| Función | Devuelve | Ejemplo y resultado |
| --- | --- | --- |
| `print A, B` | Imprime separando con `OFS` y termina con `ORS` | `print $1, $3` |
| `printf FMT, A, B` | Imprime con formato, como el `printf` de la *shell* | `printf "%-6s %5.2f\n", $1, $3` |
| `length(S)` | Longitud de `S` (sin argumento, de `$0`) | `length("hola")` → 4 |
| `substr(S, I, N)` | N caracteres de `S` desde la posición I (empieza en 1) | `substr("mundo", 2, 3)` → `und` |
| `index(S, T)` | Posición de `T` en `S`, o 0 | `index("hola mundo", "mun")` → 6 |
| `split(S, A, SEP)` | Parte `S` en el *array* `A` y devuelve cuántos trozos | `split("a:b:c", p, ":")` → 3, `p[2]` = `b` |
| `sub(RE, T)` | Cambia la primera aparición en `$0` | `sub(/a/, "b")`: `aaa` → `baa` |
| `gsub(RE, T)` | Cambia todas las apariciones en `$0` | `gsub(/a/, "b")`: `aaa` → `bbb` |
| `toupper(S)`, `tolower(S)` | `S` en mayúsculas o minúsculas; `mawk` no cambia las letras con tilde | `toupper("mundo")` → `MUNDO` |
| `sprintf(FMT, …)` | Como `printf`, pero devuelve el texto | `x = sprintf("%.1f", 2/3)` |
| `int(N)` | Parte entera | `int(7.9)` → 7 |

`sub` y `gsub` aceptan un tercer argumento con el campo o la variable donde hacer el cambio: `gsub(/-/, "", $2)`.

## Combinaciones habituales

```bash
# Media por asignatura
LC_ALL=C awk -F, 'NR > 1 { suma[$2] += $3; n[$2]++ } END { for (a in suma) printf "%s %.2f\n", a, suma[a] / n[a] }' notas.csv
```

```bash
# Mejor nota y de quién es
LC_ALL=C awk -F, 'NR > 1 && (max == "" || $3 > max) { max = $3; quien = $1 } END { print quien, max }' notas.csv
```

```bash
# Bytes servidos a cada IP (el campo 10), de más a menos
awk '{ bytes[$1] += $10 } END { for (ip in bytes) print bytes[ip], ip }' acceso.log | sort -rn
```

::: details Paso a paso

1. `awk` suma el campo 10 de cada línea en `bytes`, con la IP como clave, y al final escribe cada total. `for (ip in bytes)` recorre el *array* en un orden cualquiera:

   ```text
   1024 10.0.0.7
   5120 172.16.0.3
   13972 192.168.1.10
   ```

2. `sort -rn` los ordena por el total, de mayor a menor:

   ```text
   13972 192.168.1.10
   5120 172.16.0.3
   1024 10.0.0.7
   ```

:::

```bash
# Usuarios cuya shell es bash
awk -F: '$7 ~ /bash$/ { print $1 }' /etc/passwd
```

```bash
# Procesos que usan más del 5 % de la memoria
ps -eo user=,pid=,pmem=,comm= | LC_ALL=C awk '$3 > 5'
```

```bash
# Quitar líneas repetidas sin ordenar, conservando la primera
awk '!visto[$0]++' fichero
```

```console
$ LC_ALL=C awk -F, 'NR > 1 && $3 != "" { suma[$2] += $3; n[$2]++ } END { for (a in suma) printf "%s %.2f\n", a, suma[a] / n[a] }' notas.csv
FP 7.25
SSOO 7.00
```

Sumar y contar por clave con un *array* es el patrón «[Agregar por clave](../../s03-pipes/patterns/aggregate-by-key.md)».

## Errores frecuentes

**Decimales con punto y *locale* en español (`mawk`).**
Con `LANG=es_ES.UTF-8`, `mawk` lee los números con coma decimal: `7.5` vale 7 y `8.5` vale 8.
Las sumas, medias y comparaciones salen mal sin ningún aviso, y al imprimir usa coma.

```console
$ awk -F, 'NR > 1 && $3 != "" { s += $3; n++ } END { print s / n }' notas.csv
6,8
$ LC_ALL=C awk -F, 'NR > 1 && $3 != "" { s += $3; n++ } END { print s / n }' notas.csv
7.1
```

La salida de `ps` también usa punto, así que pasa lo mismo con `%mem` y `%cpu`.
Hay dos formas de arreglarlo.
Una es adaptar los datos con `tr ',.' ';,'`, que deja el CSV separado por punto y coma y con coma decimal.
La otra es anteponer `LC_ALL=C` a todos los comandos de la tubería que lean o escriban decimales, como en los ejemplos de esta ficha.
`gawk` usa siempre el punto, sea cual sea la configuración de localización, así que con él no hay problema con los datos originales, pero sí con los convertidos a coma.

**Comillas y variables de la *shell*.**
El programa va entre comillas simples para que la *shell* no toque campos como `$1`.
Para usar una variable de la *shell* dentro, se pasa con `-v`.

```bash
# ✗ Con comillas dobles, la shell cambia $1 por su primer argumento
awk -F, "{print $1}" notas.csv

# ✗ Funciona, pero se rompe si la variable lleva comillas o barras
awk -F, "\$1 == \"$u\"" notas.csv

# ✓
awk -F, -v u="$u" '$1 == u' notas.csv
```

**`print $1 $2` concatena.**
Sin coma entre los campos, salen pegados.

```console
$ awk -F, 'NR == 2 { print $1 $2; print $1, $2 }' notas.csv
anaSSOO
ana SSOO
```

**El orden de `for (k in a)`.**
No está definido y cambia entre `mawk` y `gawk`.
Si importa, se ordena la salida de `awk` después con `sort`.

**Cambiar `OFS` no cambia `$0`.**
`print` sin argumentos imprime la línea tal como se leyó.
Para que se reconstruya con el nuevo separador hay que modificar algún campo, aunque sea con `$1 = $1`.

```console
$ awk -F, -v OFS=';' 'NR == 2 { print; $1 = $1; print }' notas.csv
ana,SSOO,7.5
ana;SSOO;7.5
```

## Ver también

`man awk` · [ficha de `printf`](printf.md) (formatos) · [ficha de `cut`](../../s03-pipes/cards/cut.md) · [ficha de `sort`](../../s03-pipes/cards/sort.md) · patrón «[Agregar por clave](../../s03-pipes/patterns/aggregate-by-key.md)»
