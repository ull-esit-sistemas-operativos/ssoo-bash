¿Dónde están todos los `.log` de más de 1 MB, o los temporales de hace una semana?
`find` recorre un árbol de directorios, se queda con las entradas que cumplen todas las pruebas y hace algo con cada una.

```text
find [ruta...] [pruebas] [acción]
```

Sin ruta, busca desde el directorio actual.
Sin acción, imprime la ruta de cada entrada (`-print`).
Si se indican varias pruebas, se combinan con «y».

## Ejemplo

```console
$ find proyecto
proyecto
proyecto/src
proyecto/src/util.h
proyecto/src/main.c
proyecto/.oculto
proyecto/README.md
proyecto/docs
proyecto/docs/guía de uso.txt
$ find proyecto -type f -name '*.c'
proyecto/src/main.c
$ find proyecto -type d
proyecto
proyecto/src
proyecto/docs
```

`find` no ordena, sino que muestra las entradas en el orden en que las devuelve el sistema de ficheros.
Si el orden importa, añade `| sort` para ordenar la salida.

## Opciones útiles

Por nombre y ruta:

| Prueba | Qué hace | Ejemplo |
| --- | --- | --- |
| `-name PATRÓN` | El nombre (sin directorio) encaja con el comodín | `-name '*.log'` |
| `-iname PATRÓN` | Igual, sin distinguir mayúsculas | `-iname '*.jpg'` |
| `-path PATRÓN` | La ruta completa encaja con el comodín | `-path '*/src/*'` |

Por tipo:

| Prueba | Qué hace | Ejemplo |
| --- | --- | --- |
| `-type f` | Fichero regular | `-type f` |
| `-type d` | Directorio | `-type d` |
| `-type l` | Enlace simbólico | `-type l` |
| `-type p`, `s`, `b`, `c` | Tubería con nombre, *socket*, dispositivo de bloques o de caracteres | `-type p` |
| `-empty` | Fichero o directorio vacío | `-type f -empty` |

Por tamaño y fecha (los números se leen como indica la [tabla de referencia](#los-numeros-de-size-mtime-mmin-y-similares)):

| Prueba | Qué hace | Ejemplo |
| --- | --- | --- |
| `-size N` | Tamaño en bloques de la unidad: `c` bytes, `k` KiB, `M` MiB, `G` GiB | `-size +1M` |
| `-mtime N` | Días desde la última modificación del contenido | `-mtime +7` |
| `-mmin N` | Minutos desde la última modificación | `-mmin -30` |
| `-atime N`, `-amin N` | Días o minutos desde el último acceso | `-atime +30` |
| `-ctime N`, `-cmin N` | Días o minutos desde el último cambio de atributos | `-ctime -1` |
| `-newer FICHERO` | Modificado después que `FICHERO` | `-newer marca` |

Por propietario y permisos:

| Prueba | Qué hace | Ejemplo |
| --- | --- | --- |
| `-user USUARIO` | Pertenece a ese usuario | `-user alu` |
| `-group GRUPO` | Pertenece a ese grupo | `-group alumnos` |
| `-perm MODO` | Permisos exactamente iguales a `MODO` | `-perm 644` |
| `-perm -MODO` | Tiene al menos todos los bits de `MODO` | `-perm -u+x` |
| `-perm /MODO` | Tiene alguno de los bits de `MODO` | `-perm /111` |
| `-readable` | El usuario actual puede leerlo | `-readable` |
| `-writable` | El usuario actual puede escribirlo | `-writable` |
| `-executable` | El usuario actual puede ejecutarlo (o entrar, si es directorio) | `-type f -executable` |

Profundidad y combinación de pruebas:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-maxdepth N` | No baja más de N niveles (1 = solo el directorio indicado) | `-maxdepth 1` |
| `-mindepth N` | Ignora los N primeros niveles | `-mindepth 1` |
| `-a`, `-and` | «y» (implícito entre pruebas seguidas) | `-type f -a -name '*.c'` |
| `-o`, `-or` | «o» | `-name '*.c' -o -name '*.h'` |
| `!`, `-not` | Niega la prueba siguiente | `! -name '*.bak'` |
| `\( … \)` | Agrupa pruebas. Las barras invertidas evitan que la *shell* interprete los paréntesis | `\( -name '*.c' -o -name '*.h' \)` |

Acciones:

| Acción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-print` | Imprime la ruta (acción por defecto) | `-print` |
| `-print0` | Imprime la ruta terminada en un carácter nulo, para nombres con espacios | `-print0` |
| `-printf FORMATO` | Imprime con formato (ver la [tabla de referencia](#formatos-de-printf-con-proyecto-src-main-c)) | `-printf '%s %p\n'` |
| `-ls` | Imprime una línea como `ls -dils` | `-ls` |
| `-exec CMD {} \;` | Ejecuta `CMD` una vez por fichero; `{}` es la ruta | `-exec chmod 644 {} \;` |
| `-exec CMD {} +` | Ejecuta `CMD` una vez con muchos ficheros a la vez | `-exec wc -l {} +` |
| `-ok CMD {} \;` | Como `-exec`, pero pregunta antes de ejecutar cada uno | `-ok rm {} \;` |
| `-delete` | Borra cada entrada encontrada | `-name '*.tmp' -delete` |

## Tablas de referencia

Los números de `-size`, `-mtime`, `-mmin` y similares:

| Forma | Significa | Ejemplo |
| --- | --- | --- |
| `+N` | Más de N | `-mtime +7`: modificado hace 8 días o más |
| `-N` | Menos de N | `-mmin -30`: en los últimos 30 minutos |
| `N` | Exactamente N | `-mtime 1`: hace entre 24 y 48 horas |

Los días de `-mtime` son periodos de 24 horas contados hacia atrás desde ahora, y las fracciones se descartan.
Por ejemplo, `-mtime 0` son las últimas 24 horas.
Con `-size` el tamaño se redondea hacia arriba a la unidad, así que `-size -1k` solo encuentra ficheros vacíos.
Para «menos de 1000 bytes» mejor `-size -1000c`.

Formatos de `-printf`, con `proyecto/src/main.c`:

| Formato | Qué imprime | Resultado |
| --- | --- | --- |
| `%p` | Ruta | `proyecto/src/main.c` |
| `%f` | Nombre sin directorio | `main.c` |
| `%h` | Directorio | `proyecto/src` |
| `%s` | Tamaño en bytes | `2048` |
| `%m` | Permisos en octal | `644` |
| `%u`, `%g` | Propietario y grupo | `alu` |
| `%TY-%Tm-%Td %TH:%TM` | Fecha de modificación por partes | `2026-10-03 12:00` |
| `\n`, `\t` | Salto de línea y tabulador |  |

## Combinaciones habituales

```bash
# Ficheros .log de más de 1 MiB
find /var/log -type f -name '*.log' -size +1M
```

```bash
# Borrar los temporales de hace más de una semana
find /tmp -name '*.tmp' -mtime +7 -delete
```

```bash
# Líneas de cada script y el total
find . -type f -name '*.sh' -exec wc -l {} +
```

```bash
# Recorrer los ficheros en un bucle, aunque tengan espacios
find "$dir" -type f -print0 | while IFS= read -r -d '' f; do echo "$f"; done
```

::: details Paso a paso

1. Con `dir=proyecto`, `find "$dir" -type f -print0` escribe la ruta de cada fichero terminada en un carácter nulo en lugar de un salto de línea, así que en la terminal salen pegadas:

   ```text
   proyecto/src/util.hproyecto/src/main.cproyecto/.ocultoproyecto/README.mdproyecto/docs/guía de uso.txt
   ```

2. `read -r -d ''` lee hasta cada carácter nulo, así que `f` recibe una ruta entera en cada vuelta, también `guía de uso.txt` con sus espacios.
3. `echo "$f"` escribe cada ruta en su línea:

   ```text
   proyecto/src/util.h
   proyecto/src/main.c
   proyecto/.oculto
   proyecto/README.md
   proyecto/docs/guía de uso.txt
   ```

:::

El bucle con `-print0` y `read -d ''` es el patrón «[Recorrer ficheros](../../s04-expansions-loops/patterns/loop-over-files.md)».

## Errores frecuentes

**Comodín sin comillas.**
Sin comillas, la *shell* expande `*.c` antes de llamar a `find`.
Si en el directorio actual hay un `x.c`, `find` recibe `-name x.c` y busca solo ese nombre.

```bash
# ✗ Con x.c en el directorio actual, no encuentra main.c
find proyecto -name *.c

# ✓
find proyecto -name '*.c'
```

**`-o` con una acción.**
El «y» implícito tiene mayor prioridad que `-o`, así que la acción solo se aplica a la última prueba.

```console
$ find proyecto -name '*.c' -o -name '*.h' -print
proyecto/src/util.h
$ find proyecto \( -name '*.c' -o -name '*.h' \) -print
proyecto/src/util.h
proyecto/src/main.c
```

**`-delete` y el orden.**
`find` evalúa de izquierda a derecha, así que `-delete` delante de las pruebas borra todo lo que recorre.

```bash
# ✗ Borra todo el árbol
find /tmp -delete -name '*.tmp'

# ✓ Prueba primero sin -delete y añádelo al final
find /tmp -name '*.tmp'
find /tmp -name '*.tmp' -delete
```

## Ver también

`man find` · [ficha de `ls`](../../s01-shell/cards/ls.md) · [ficha de `wc`](../../s03-pipes/cards/wc.md) · patrón «[Recorrer ficheros](../../s04-expansions-loops/patterns/loop-over-files.md)»
