¿Cuántos?
`wc` cuenta líneas, palabras y bytes; detrás de una tubería, cuenta cuántos resultados ha dado.

```text
wc [opciones] [fichero...]
```

Sin fichero, lee de la entrada estándar.
Sin opciones, imprime líneas, palabras y bytes, en ese orden.

## Ejemplo

```console
$ wc notas.csv
  8   8 106 notas.csv
$ wc -l notas.csv acceso.log
  8 notas.csv
  6 acceso.log
 14 total
$ wc -l < notas.csv
8
```

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-l`, `--lines` | Líneas (en realidad, saltos de línea) | `wc -l` |
| `-w`, `--words` | Palabras: grupos de caracteres separados por blancos | `wc -w` |
| `-c`, `--bytes` | Bytes | `wc -c` |
| `-m`, `--chars` | Caracteres; con tildes o ñ es menor que `-c` | `wc -m` |
| `-L`, `--max-line-length` | Longitud de la línea más larga | `wc -L` |

## Combinaciones habituales

```bash
# Filas de datos, sin contar la cabecera
tail -n +2 notas.csv | wc -l
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

2. `wc -l` cuenta las líneas:

   ```text
   7
   ```

:::

```bash
# Sesiones abiertas en el sistema
who | wc -l
```

```bash
# Cuántos scripts hay en el árbol
find . -type f -name '*.sh' | wc -l
```

```bash
# Guardar la cuenta en una variable, sin el nombre del fichero
n=$(wc -l < notas.csv)
```

Para contar las líneas que encajan con un patrón, `grep -c` lo hace en un paso.

## Errores frecuentes

**El nombre del fichero en la salida.**
Con un fichero como argumento, `wc` imprime el número y el nombre; para guardar solo el número, redirige la entrada.

```bash
# ✗ n vale «8 notas.csv»
n=$(wc -l notas.csv)

# ✓ n vale «8»
n=$(wc -l < notas.csv)
```

**La última línea sin salto.**
`-l` cuenta saltos de línea, así que una última línea sin `\n` no cuenta.

```console
$ printf 'a\nb' | wc -l
1
```

**Bytes no son caracteres.**
Con UTF-8, cada tilde o ñ ocupa dos bytes.

```console
$ echo 'canción' | wc -c
9
$ echo 'canción' | wc -m
8
```

## Ver también

`man wc` · [ficha de `grep`](grep.md) (`-c`) · [ficha de `ls`](../../s01-shell/cards/ls.md) · [ficha de `head` y `tail`](head-tail.md)&#32;
