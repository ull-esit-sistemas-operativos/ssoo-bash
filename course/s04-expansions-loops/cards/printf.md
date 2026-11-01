¿Cómo saco una tabla con las columnas alineadas y dos decimales?
`printf` imprime sus argumentos según un formato, que dice dónde va cada uno, con qué ancho y con cuántos decimales.

```text
printf FORMATO [argumento...]
```

Cada `%` del formato consume un argumento.
Si sobran argumentos, el formato se repite con los siguientes.
Es un comando interno de bash, pero `awk` tiene un `printf` con los mismos formatos.

## Ejemplo

```console
$ printf '%s tiene %d años\n' ana 20
ana tiene 20 años
$ printf '%-8s|%5s|\n' ana 7
ana     |    7|
$ printf '%03d\n' 7
007
$ printf '%s=%s\n' a 1 b 2
a=1
b=2
```

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-v VAR` | Guarda el resultado en la variable en vez de imprimirlo | `printf -v linea '%-5s' "$x"` |

El resto del comportamiento lo deciden los formatos.

## Tablas de referencia

Conversiones:

| Formato | Imprime el argumento como | Ejemplo y resultado |
| --- | --- | --- |
| `%s` | Texto | `printf '%s' hola` → `hola` |
| `%d` | Entero | `printf '%d' 42` → `42` |
| `%f` | Decimal (6 decimales por defecto) | `printf '%f' 2.5` → `2.500000` |
| `%e` | Notación científica | `printf '%e' 1234.5` → `1.234500e+03` |
| `%x`, `%X`, `%o` | Hexadecimal, en mayúsculas, octal | `printf '%x' 255` → `ff` |
| `%c` | Su primer carácter | `printf '%c' hola` → `h` |
| `%b` | Texto, interpretando escapes como `\t` | `printf '%b' 'a\tb'` → `a` y `b` separadas por un tabulador |
| `%q` | Texto entrecomillado para la *shell* (solo bash) | `printf '%q' "a b"` → `a\ b` |
| `%(FMT)T` | Fecha y hora con formato de `date`; `-1` es ahora (solo bash) | `printf '%(%Y-%m-%d)T' -1` → `2026-10-25` |
| `%%` | Un `%` literal | `printf '100%%'` → `100%` |

Modificadores, entre el `%` y la letra:

| Modificador | Qué hace | Ejemplo y resultado |
| --- | --- | --- |
| `N` | Ancho mínimo N, alineado a la derecha | `%5s` con `ana` → `   ana ` |
| `-N` | Ancho mínimo N, alineado a la izquierda | `%-5s` con `ana` → ` ana   ` |
| `0N` | Rellena con ceros a la izquierda | `%03d` con `7` → `007` |
| `.N` en `%f` | N decimales | `%.2f` con `3.14159` → `3.14` |
| `.N` en `%s` | Como mucho N caracteres | `%.3s` con `abcdef` → `abc` |
| `N.M` | Ancho N con M decimales | `%6.2f` con `9` → `   9.00 ` |
| `+` | Signo también en los positivos | `%+d` con `5` → `+5` |

Escapes en el formato: `\n` salto de línea, `\t` tabulador, `\\` barra invertida.

## Combinaciones habituales

```bash
# Una línea por argumento (o por elemento de un array)
printf '%s\n' "$@"
```

```bash
# Tabla alineada a partir de un CSV con punto decimal, pasado antes a coma
printf '%-8s %5s\n' ALUMNO NOTA
tail -n +2 notas.csv | grep -v ',$' | tr ',.' ';,' | while IFS=';' read -r alumno asig nota; do
    printf '%-8s %5.2f\n' "$alumno" "$nota"
done
```

::: details Paso a paso

1. `printf '%-8s %5s\n' ALUMNO NOTA` escribe la cabecera:

   ```text
   ALUMNO    NOTA
   ```

2. `tail -n +2 notas.csv` escribe el fichero desde la línea 2, sin la cabecera:

   ```text
   ana,SSOO,7.5
   ana,FP,6
   luis,SSOO,4.5
   luis,FP,
   marta,SSOO,9
   marta,FP,8.5
   pablo,SSOO,
   ```

3. `grep -v ',$'` quita las líneas que acaban en coma, las que no tienen nota. Si no, `printf` escribiría `0,00` sin avisar:

   ```text
   ana,SSOO,7.5
   ana,FP,6
   luis,SSOO,4.5
   marta,SSOO,9
   marta,FP,8.5
   ```

4. `tr ',.' ';,'` cambia las comas por `;` y los puntos por comas, porque con el *locale* en español `printf` espera la coma decimal:

   ```text
   ana;SSOO;7,5
   ana;FP;6
   luis;SSOO;4,5
   marta;SSOO;9
   marta;FP;8,5
   ```

5. El `while` lee cada línea separando por `;` (`while read` se explica en la semana 5), y `printf` escribe el alumno en 8 columnas y la nota en 5, con dos decimales. Con la cabecera queda:

   ```text
   ALUMNO    NOTA
   ana       7,50
   ana       6,00
   luis      4,50
   marta     9,00
   marta     8,50
   ```

:::

```bash
# Mensaje de error a la salida de error
printf 'Error: %s no existe\n' "$f" >&2
```

```bash
# Fecha de hoy en una variable, sin llamar a date
printf -v fecha '%(%Y-%m-%d)T' -1
```

La tabla alineada con cabecera es el patrón «[Tablas alineadas](../patterns/aligned-tables.md)».

## Errores frecuentes

**Decimales con punto y *locale* en español.**
Con `LANG=es_ES.UTF-8`, el `printf` de bash espera coma decimal: con un número con punto da error y escribe un valor truncado.

```console
$ printf '%.2f\n' 3.14159
bash: printf: 3.14159: invalid number
3,00
$ LC_ALL=C printf '%.2f\n' 3.14159
3.14
```

Hay dos formas de arreglarlo: pasar los datos a coma decimal con `tr`, como en la tabla de las combinaciones, o anteponer `LC_ALL=C` al `printf`.

**Sin salto de línea final.**
A diferencia de `echo`, `printf` no añade `\n` si no está en el formato.

**Datos en el formato.**
Un `%` dentro de la variable se interpreta como formato.

```console
$ v='50% de descuento'
$ printf "$v\n"
50 0e descuento
$ printf '%s\n' "$v"
50% de descuento
```

El formato va siempre entre comillas simples y los datos, como argumentos.

**`%d` con decimales.**
`printf '%d' 7.5` da error.
Para redondear, `%.0f`.

**Tildes y eñes descuadran las columnas.**
El ancho de `%-8s` cuenta bytes, y cada tilde o ñ ocupa dos en UTF-8, así que esa fila queda un espacio más corta.

```console
$ printf '%-8s|\n' 'Begoña' 'Ana'
Begoña |
Ana     |
```

## Ver también

`help printf` · `man 3 printf` (todos los formatos) · [ficha de `awk`](awk.md) · patrón «[Tablas alineadas](../patterns/aligned-tables.md)»
