¿Qué hay en este directorio y qué es cada cosa?
`ls` lista las entradas de un directorio y, con `-l`, los permisos, el propietario, el tamaño y la fecha de cada una.

```text
ls [opciones] [fichero o directorio...]
```

Sin argumentos, lista el directorio actual.

## Ejemplo

```console
$ ls
docs  README.md  src
$ ls -a
.  ..  docs  .oculto  README.md  src
$ ls -l
total 8
drwxr-xr-x 2 alu alu 4096 oct  1 10:00 docs
-rw-r--r-- 1 alu alu    0 oct  2 09:30 README.md
drwxr-xr-x 2 alu alu 4096 oct  1 10:00 src
```

Con el *locale* en español, el orden no distingue mayúsculas.
Es decir, `README.md` queda entre `docs` y `src`.
Con `LC_ALL=C` las mayúsculas van primero.

## Opciones útiles

Qué entradas se listan:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-a`, `--all` | Incluye las ocultas (las que empiezan por punto), `.` y `..` | `ls -a` |
| `-A`, `--almost-all` | Incluye las ocultas, pero no `.` ni `..` | `ls -A` |
| `-d`, `--directory` | Muestra el directorio en sí, no su contenido | `ls -ld src` |
| `-R`, `--recursive` | Lista también el contenido de los subdirectorios | `ls -R` |

Cómo se muestran:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-l` | Formato largo: tipo, permisos, enlaces, propietario, grupo, tamaño, fecha y nombre | `ls -l` |
| `-h`, `--human-readable` | Tamaños con K, M y G (con `-l`) | `ls -lh` |
| `-1` | Una entrada por línea | `ls -1` |
| `-F`, `--classify` | Añade `/` a los directorios, `*` a los ejecutables y `@` a los enlaces | `ls -F` |
| `-i`, `--inode` | Muestra el número de nodo-i | `ls -li` |
| `-n`, `--numeric-uid-gid` | Como `-l`, con UID y GID en vez de nombres | `ls -n` |
| `--time-style=long-iso` | Fechas como `2026-10-03 12:00`, fáciles de procesar en un *script* | `ls -l --time-style=long-iso` |
| `--full-time` | Fecha completa con segundos y zona horaria | `ls -l --full-time` |

En qué orden:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-t`, `--sort=time` | Por fecha de modificación, el más reciente primero | `ls -t` |
| `-S`, `--sort=size` | Por tamaño, el mayor primero | `ls -lS` |
| `-X`, `--sort=extension` | Por extensión | `ls -X` |
| `-v`, `--sort=version` | Orden natural de números: `f2` antes que `f10` | `ls -v` |
| `-r`, `--reverse` | Invierte el orden | `ls -ltr` |

Qué fecha se muestra (con `-l`) o se usa para ordenar (con `-t`):

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| (por defecto) | Última modificación del contenido | `ls -lt` |
| `-u` | Último acceso | `ls -lu` |
| `-c` | Último cambio de los atributos (permisos, propietario) | `ls -lc` |

## Tablas de referencia

Columnas de `ls -l`, con la línea `-rw-r--r-- 1 alu alu 2048 oct  3 12:00 main.c`:

| Columna | Ejemplo | Significado |
| --- | --- | --- |
| Tipo | `-` | Primer carácter: tipo de fichero (ver la [tabla siguiente](#significado-del-caracter-de-tipo-en-la-salida-de-ls-l)) |
| Permisos | `rw-r--r--` | Lectura, escritura y ejecución para propietario, grupo y otros |
| Enlaces | `1` | Número de enlaces duros |
| Propietario y grupo | `alu alu` | Usuario y grupo dueños del fichero |
| Tamaño | `2048` | En bytes, salvo con `-h` |
| Fecha | `oct  3 12:00` | Hora si es de los últimos seis meses; año si es más antigua |
| Nombre | `main.c` | Con `-> destino` si es un enlace simbólico |

Significado del carácter de tipo en la salida de `ls -l`:

| Carácter | Tipo |
| --- | --- |
| `-` | Fichero regular |
| `d` | Directorio |
| `l` | Enlace simbólico |
| `c` | Dispositivo de caracteres |
| `b` | Dispositivo de bloques |
| `p` | Tubería con nombre |
| `s` | *Socket* |

## Combinaciones habituales

```bash
# Las 5 entradas modificadas más recientemente
ls -t "$dir" | head -n 5
```

```bash
# Cuántas entradas tiene un directorio, ocultas incluidas
ls -A "$dir" | wc -l
```

::: details Paso a paso

1. Con `dir=proyecto`, `ls -A "$dir"` escribe las entradas, ocultas incluidas, pero sin `.` y `..`. A una tubería escribe una por línea:

   ```text
   docs
   .oculto
   README.md
   src
   ```

2. `wc -l` cuenta las líneas:

   ```text
   4
   ```

:::

```bash
# Los 5 ficheros más grandes, con tamaño legible
ls -lhS "$dir" | head -n 6
```

::: details Paso a paso

1. Con `dir=proyecto`, `ls -lhS "$dir"` escribe la lista larga, de mayor a menor tamaño, y empieza por la línea `total`:

   ```text
   total 8,0K
   drwxr-xr-x 2 alu alu 4,0K oct  1 10:00 docs
   drwxr-xr-x 2 alu alu 4,0K oct  1 10:00 src
   -rw-r--r-- 1 alu alu    0 oct  2 09:30 README.md
   ```

2. `head -n 6` deja las 6 primeras líneas: el `total` y las 5 entradas más grandes. Aquí solo hay tres, así que salen todas.

:::

## Errores frecuentes

**Recorrer la salida de `ls`.**
La sustitución de comandos parte los nombres por los espacios, así que un fichero con espacios se convierte en varios.

```console
$ for f in $(ls docs); do echo "[$f]"; done
[guía]
[de]
[uso.txt]
$ for f in docs/*; do echo "[$f]"; done
[docs/guía de uso.txt]
```

Para recorrer ficheros, mejor usar comodines (`for f in docs/*`) o `find` con `-print0`.
`ls` es para que los usuarios o para contar archivos, no para recorrerlos.

**`ls -l` de un directorio muestra su contenido.**
Para ver los permisos del propio directorio hace falta `-d` o `--directory` .

```bash
# ✗ Lista lo que hay dentro de src
ls -l src

# ✓ Muestra la informacion de src
ls -ld src
```

**Contar sin los archivos ocultos.**
`ls` no muestra las entradas que empiezan por punto, así que `ls | wc -l` las ignora.

```bash
# ✗ 3 en el ejemplo: falta .oculto
ls | wc -l

# ✓ 4
ls -A | wc -l
```

## Ver también

`man ls` · [ficha de `find`](../../s02-files/cards/find.md) · [ficha de `wc`](../../s03-pipes/cards/wc.md) · [ficha de `head` y `tail`](../../s03-pipes/cards/head-tail.md)
