¿Solo quiero el nombre y la nota de cada línea del CSV?
`cut` se queda con los campos o los caracteres que se le piden de cada línea.

```text
cut -d DELIMITADOR -f CAMPOS [fichero...]
cut -c CARACTERES [fichero...]
```

Sin fichero, lee de la entrada estándar.
Sin `-d`, el delimitador es el tabulador.

## Ejemplo

```console
$ cat notas.csv
alumno,asignatura,nota
ana,SSOO,7.5
ana,FP,6
luis,SSOO,4.5
luis,FP,
marta,SSOO,9
marta,FP,8.5
pablo,SSOO,
$ cut -d, -f1,3 notas.csv
alumno,nota
ana,7.5
ana,6
luis,4.5
luis,
marta,9
marta,8.5
pablo,
$ cut -d: -f1,7 /etc/passwd | head -n 3
root:/bin/bash
daemon:/usr/sbin/nologin
bin:/usr/sbin/nologin
```

## Opciones útiles

Qué se extrae (las listas se escriben como indica la [tabla de referencia](#como-se-definen-los-campos-o-caracteres-a-extraer-con-f-c-o-b)):

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-f LISTA`, `--fields=LISTA` | Esos campos | `cut -d, -f1,3` |
| `-c LISTA`, `--characters=LISTA` | Esos caracteres. En GNU cuenta bytes, así que una tilde o una ñ ocupan dos (en UTF-8) y pueden quedar cortadas | `cut -c1-10` |
| `-b LISTA`, `--bytes=LISTA` | Esos bytes. En GNU hace lo mismo que `-c` | `cut -b1-10` |
| `--complement` | Todo menos lo indicado | `cut -d, --complement -f2` |

Delimitadores:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-d C`, `--delimiter=C` | Separador de campos: un solo carácter | `cut -d:` |
| `--output-delimiter=TEXTO` | Separador en la salida | `--output-delimiter=' '` |
| `-s`, `--only-delimited` | Descarta las líneas que no tienen el delimitador | `cut -s -d, -f1` |

## Tablas de referencia

Cómo se definen los campos o caracteres a extraer con `-f`, `-c` o `-b`:

| Lista | Significa |
| --- | --- |
| `3` | El campo 3 |
| `1,3` | Los campos 1 y 3 |
| `2-4` | Del 2 al 4 |
| `2-` | Del 2 al final |
| `-3` | Del 1 al 3 |

## Combinaciones habituales

```bash
# Usuario y shell de cada cuenta
cut -d: -f1,7 /etc/passwd
```

```bash
# IP distintas del log
cut -d' ' -f1 acceso.log | sort -u
```

::: details Paso a paso

1. `cut -d' ' -f1 acceso.log` deja la IP de cada petición, que es lo que hay antes del primer espacio:

   ```text
   192.168.1.10
   10.0.0.7
   192.168.1.10
   172.16.0.3
   10.0.0.7
   192.168.1.10
   ```

2. `sort -u` las ordena y quita las repetidas:

   ```text
   10.0.0.7
   172.16.0.3
   192.168.1.10
   ```

:::

```bash
# Peticiones por minuto: en "[21/Oct/2026:10:15:32" la hora y el minuto son los campos 2 y 3 separados por :
cut -d: -f2,3 acceso.log | sort | uniq -c
```

::: details Paso a paso

1. `cut -d: -f2,3 acceso.log` deja la hora y el minuto de cada petición, otra vez unidos por `:`:

   ```text
   10:15
   10:15
   10:16
   10:17
   10:17
   10:18
   ```

2. `sort` junta los minutos iguales. Aquí ya estaban juntos, porque el *log* va en orden, pero `uniq` solo cuenta las líneas seguidas.
3. `uniq -c` cuenta cuántas veces se repite cada minuto:

   ```text
         2 10:15
         1 10:16
         2 10:17
         1 10:18
   ```

:::

```bash
# Asignaturas distintas, sin la cabecera
tail -n +2 notas.csv | cut -d, -f2 | sort -u
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

2. `cut -d, -f2` deja la asignatura de cada línea:

   ```text
   SSOO
   FP
   SSOO
   FP
   SSOO
   FP
   SSOO
   ```

3. `sort -u` las ordena y quita las repetidas:

   ```text
   FP
   SSOO
   ```

:::

## Errores frecuentes

**Varios espacios seguidos.**
Cada espacio es un separador, así que dos espacios seguidos delimitan un campo vacío.
Ocurre con la salida de `ps`, `ls -l`, `who` o `uniq -c`, que alinean las columnas usando espacios.

```console
$ printf '  ana   12\n luis    3\n' | cut -d' ' -f2

luis
$ printf '  ana   12\n luis    3\n' | tr -s ' ' | cut -d' ' -f2
ana
luis
$ printf '  ana   12\n luis    3\n' | awk '{print $2}'
12
3
```

Una solución es usar `tr -s ' '`, que reduce los espacios a uno, pero si la línea empieza por espacio el primer campo sigue vacío.
`awk` separa por blancos y se salta los iniciales; por tanto, es la opción segura.

**`cut` no reordena.**
Los campos salen siempre en su orden original.

```bash
# ✗ Sale alumno,nota, no nota,alumno
cut -d, -f3,1 notas.csv

# ✓
awk -F, '{print $3 "," $1}' notas.csv
```

**El delimitador por defecto es el tabulador.**
Sin `-d`, una línea separada por espacios no tiene delimitador y `cut` la imprime entera.

## Ver también

`man cut` · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md) · [ficha de `tr`](tr.md) · [ficha de `sort`](sort.md)
