¿Que tu *script* se pueda ejecutar, o que nadie más lea tus notas?
`chmod` cambia los permisos de ficheros y directorios.

```text
chmod [opciones] MODO fichero...
```

`MODO` va en notación octal, como `640`, o simbólica, como `u+x`.
Solo el propietario del fichero, o root, puede cambiar sus permisos.

## Ejemplo

```console
$ ls -l proyecto/src/main.c
-rw-r--r-- 1 alu alu 2048 oct  3 12:00 proyecto/src/main.c
$ chmod u+x,o-r proyecto/src/main.c
$ ls -l proyecto/src/main.c
-rwxr----- 1 alu alu 2048 oct  3 12:00 proyecto/src/main.c
$ chmod 644 proyecto/src/main.c
```

En el ejemplo anterior, la notación simbólica cambia solo lo que se indica, es decir, añade la ejecución al propietario y quita la lectura a los demás.
La octal fija todos los permisos de una sola vez.

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-R`, `--recursive` | Cambia también todo lo que hay dentro de un directorio | `chmod -R go-w proyecto` |
| `-v`, `--verbose` | Dice qué ha hecho con cada fichero | `chmod -v 600 notas.csv` |
| `-c`, `--changes` | Como `-v`, pero solo con los ficheros que cambian | `chmod -c u+x *.sh` |
| `--reference=FICHERO` | Copia los permisos de otro fichero | `chmod --reference=a.sh b.sh` |

## Combinaciones habituales

```bash
# Hacer ejecutables todos los scripts del directorio
chmod u+x *.sh
```

```bash
# Ficheros con 644 y directorios con 755 en todo un árbol
find proyecto -type f -exec chmod 644 {} +
find proyecto -type d -exec chmod 755 {} +
```

```bash
# Un directorio en el que solo entra su propietario
chmod 700 privado
```

## Tablas de referencia

La notación simbólica indica quién, qué operación y qué permisos, sin espacios, y separa con comas varios cambios (`u+x,o-r`).

| Parte | Valores |
| --- | --- |
| Quién | `u` el propietario, `g` el grupo, `o` los demás, `a` todos (también si no se pone nada) |
| Operación | `+` añade, `-` quita, `=` fija exactamente esos y quita los demás |
| Permisos | `r`, `w`, `x`; `X` ejecución solo para directorios y para ficheros que ya la tienen para alguien; `s` y `t`, los [permisos especiales](../permissions.md#permisos-especiales) |

La notación octal usa una cifra por clase (propietario, grupo y demás), que es la suma de `r` = 4, `w` = 2 y `x` = 1.

| Cifra | Permisos | Cifra | Permisos |
| --- | --- | --- | --- |
| `0` | `---` | `4` | `r--` |
| `1` | `--x` | `5` | `r-x` |
| `2` | `-w-` | `6` | `rw-` |
| `3` | `-wx` | `7` | `rwx` |

## Errores frecuentes

**`chmod -R` con `x` minúscula.**
`chmod -R a+x proyecto` es una operación recursiva que también hace ejecutables los ficheros de texto.
Para que solo los directorios ganen la `x`, que es la que deja entrar en ellos, se usa la `X` mayúscula.

```bash
# ✗ README.md y guía de uso.txt pasan a ser ejecutables
chmod -R a+x proyecto

# ✓ Solo los directorios, y los ficheros que ya eran ejecutables
chmod -R a+X proyecto
```

**Menos cifras de las que parece.**
Las cifras octales que faltan son ceros a la izquierda: `chmod 64 notas.csv` equivale a `chmod 064`, y deja `----rw-r--`, sin ningún permiso para el propietario.

**Un directorio con `r` pero sin `x`.**
La `r` deja listar los nombres que contiene, pero sin la `x` no se puede entrar en él ni leer sus ficheros.
Por eso los directorios suelen tener `r` y `x` a la vez, como en `755` o `700`.

**`=` quita lo que no nombra.**
`chmod g=r` deja al grupo solo con la lectura, es decir, si tenía escritura o ejecución, las pierde.
Para añadir sin tocar lo demás, `+`.

## Ver también

`man chmod` · lectura «[Permisos](../permissions.md)» · [ficha de `ls`](../../s01-shell/cards/ls.md) (cómo se leen los permisos en `ls -l`) · [ficha de `find`](find.md) (`-perm`)
