¿Quién tiene la nota más alta?
`sort` ordena las líneas por la línea entera o por el campo que se le indique, como texto o como número.

```text
sort [opciones] [fichero...]
```

Sin fichero, lee de la entrada estándar.
Con varios, los ordena todos juntos.

## Ejemplo

```console
$ tail -n +2 notas.csv | LC_ALL=C sort -t, -k3,3nr
marta,SSOO,9
marta,FP,8.5
ana,SSOO,7.5
ana,FP,6
luis,SSOO,4.5
luis,FP,
pablo,SSOO,
$ tail -n +2 notas.csv | LC_ALL=C sort -t, -k2,2 -k3,3nr
marta,FP,8.5
ana,FP,6
luis,FP,
marta,SSOO,9
ana,SSOO,7.5
luis,SSOO,4.5
pablo,SSOO,
```

La primera ordena por nota de mayor a menor.
La segunda ordena por asignatura y, dentro de cada una, por nota.
El `LC_ALL=C` es por los decimales con punto (ver el apartado «[Errores frecuentes](#errores-frecuentes)»).

## Opciones útiles

Cómo se compara:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| (por defecto) | Como texto, según el *locale* | `sort` |
| `-n`, `--numeric-sort` | Como número | `sort -n` |
| `-h`, `--human-numeric-sort` | Como tamaño con unidades: `900`, `1,5K`, `2M`, `3G` | `du -sh * \| sort -h` |
| `-V`, `--version-sort` | Orden natural: `f2` antes que `f10` | `sort -V` |
| `-M`, `--month-sort` | Por mes abreviado, en el idioma del *locale* (`ene`, `feb`…) | `sort -M` |
| `-f`, `--ignore-case` | Sin distinguir mayúsculas | `sort -f` |
| `-b`, `--ignore-leading-blanks` | Ignora los blancos al principio | `sort -b` |

Qué parte de la línea se compara:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-t C`, `--field-separator=C` | Separador de campos (por defecto, usa el paso de blanco a no blanco) | `sort -t,` |
| `-k INI,FIN`, `--key=INI,FIN` | Compara del campo `INI` al campo `FIN` ([tabla de referencia](#claves-con-k-con-t-y-la-entrada-ana-ssoo-7-5)) | `sort -t, -k3,3n` |

Dirección y resultado:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-r`, `--reverse` | De mayor a menor | `sort -rn` |
| `-u`, `--unique` | Una sola línea de cada grupo de iguales | `sort -u` |
| `-s`, `--stable` | Las líneas con la misma clave conservan su orden original | `sort -s -k2,2` |
| `-o FICHERO`, `--output=FICHERO` | Escribe el resultado en un fichero, que puede ser el mismo que el de entrada | `sort -o f.txt f.txt` |
| `-c`, `--check` | Solo comprueba si ya está ordenada la entrada. Termina con estado 1 si no | `sort -c f.txt` |

## Tablas de referencia

Claves con `-k` (con `-t,` y la entrada `ana,SSOO,7.5`):

| Clave | Compara | Ejemplo |
| --- | --- | --- |
| `-k2` | Del campo 2 al final de la línea | `SSOO,7.5` |
| `-k2,2` | Solo el campo 2 | `SSOO` |
| `-k3,3n` | Solo el campo 3, como número | `7.5` |
| `-k3,3nr` | Solo el campo 3, como número y al revés | `7.5` |
| `-k2,2 -k3,3nr` | Por el campo 2; si empatan, por el 3 numérico al revés | Desempate |

Las letras de una clave (`n`, `r`, `h`, `V`, `f`…) solo afectan a esa clave.
Si dos líneas empatan en todas las claves, `sort` las desempata comparando la línea entera, salvo con `-s`.

## Combinaciones habituales

```bash
# Notas de mayor a menor, sin la cabecera
tail -n +2 notas.csv | LC_ALL=C sort -t, -k3,3nr
```

::: details Paso a paso

1. `tail -n +2 notas.csv` escribe el fichero desde la línea 2, sin la cabecera:

   ```text
   ana,SSOO,7.5
   ana,FP,6
   luis,SSOO,4.5
   luis,FP,
   marta,SSOO,9
   marta,FP,8.5
   pablo,SSOO,
   ```

2. `LC_ALL=C sort -t, -k3,3nr` ordena por el campo 3, la nota, como número y de mayor a menor:

   ```text
   marta,SSOO,9
   marta,FP,8.5
   ana,SSOO,7.5
   ana,FP,6
   luis,SSOO,4.5
   luis,FP,
   pablo,SSOO,
   ```

:::

```bash
# Lo mismo, conservando la cabecera arriba
{ head -n 1 notas.csv; tail -n +2 notas.csv | LC_ALL=C sort -t, -k3,3nr; }
```

::: details Paso a paso

1. `head -n 1 notas.csv` escribe la cabecera:

   ```text
   alumno,asignatura,nota
   ```

2. `tail -n +2 notas.csv` escribe el resto, que `sort` ordena por nota. Las notas vacías cuentan como 0 y quedan al final:

   ```text
   marta,SSOO,9
   marta,FP,8.5
   ana,SSOO,7.5
   ana,FP,6
   luis,SSOO,4.5
   luis,FP,
   pablo,SSOO,
   ```

3. Las llaves forman un grupo de órdenes, que junta las dos salidas en una, con la cabecera arriba (ver la lectura «[Redirecciones](../redirections.md)»):

   ```text
   alumno,asignatura,nota
   marta,SSOO,9
   marta,FP,8.5
   ana,SSOO,7.5
   ana,FP,6
   luis,SSOO,4.5
   luis,FP,
   pablo,SSOO,
   ```

:::

```bash
# Cuentas ordenadas por UID
sort -t: -k3,3n /etc/passwd
```

```bash
# Lo que más ocupa en el directorio actual
du -sh * | sort -h
```

Para contar por clave se usa `sort | uniq -c | sort -rn` (ver la [ficha de `uniq`](uniq.md)).

## Errores frecuentes

**Decimales con punto y *locale* en español.**
Con `LANG=es_ES.UTF-8`, `sort -n` toma la coma como separador decimal y el punto como separador de miles: `7.5` vale 75 y `6.25` vale 625.
Es decir, ordena mal y no avisa.

```console
$ printf '%s\n' 7.5 10 6.25 9 | sort -n
9
10
7.5
6.25
$ printf '%s\n' 7.5 10 6.25 9 | LC_ALL=C sort -n
6.25
7.5
9
10
```

Hay dos formas de arreglarlo.
Una es pasar los datos a coma decimal con `tr ',.' ';,'` antes de ordenar, y separar los campos con `-t';'`.
La otra es anteponer `LC_ALL=C` a `sort`, como en los ejemplos de esta ficha.

**`-k2` sin final.**
La clave va del campo 2 al final de la línea, así que los campos siguientes también cuentan.

```console
$ cat k.txt
ana 7 zeta
luis 7 casa
$ sort -k2 k.txt
luis 7 casa
ana 7 zeta
$ sort -k2,2 k.txt
ana 7 zeta
luis 7 casa
```

Con `-k2` gana `casa` frente a `zeta`; con `-k2,2` empatan y se desempata por la línea entera.

**Números ordenados como texto.**
Sin `-n`, `10` va antes que `9` porque `1` va antes que `9`.

**Redirigir al mismo fichero.**
La *shell* vacía el fichero antes de que `sort` lo lea.
Mejor usar `-o`:

```bash
# ✗ notas.csv queda vacío
sort notas.csv > notas.csv

# ✓
sort -o notas.csv notas.csv
```

## Ver también

`man sort` · [ficha de `uniq`](uniq.md) · [ficha de `head` y `tail`](head-tail.md) · [ficha de `cut`](cut.md) · patrón «[Agregar por clave](../patterns/aggregate-by-key.md)»
