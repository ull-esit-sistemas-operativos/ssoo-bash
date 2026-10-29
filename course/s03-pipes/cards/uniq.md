¿Cuántas peticiones ha hecho cada IP?
`uniq` cuenta, elimina o muestra las líneas repetidas, siempre que estén seguidas.
Por eso casi siempre va detrás de `sort`.

```text
uniq [opciones] [fichero]
```

Sin fichero, lee de la entrada estándar.

## Ejemplo

```console
$ cat colores.txt
rojo
rojo
verde
rojo
$ uniq colores.txt
rojo
verde
rojo
$ sort colores.txt | uniq -c
      3 rojo
      1 verde
```

## Opciones útiles

Qué líneas se muestran:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-c`, `--count` | Antepone a cada línea el número de veces que aparece | `uniq -c` |
| `-d`, `--repeated` | Solo las líneas repetidas, una vez cada una | `uniq -d` |
| `-D`, `--all-repeated` | Todas las copias de las líneas repetidas | `uniq -D` |
| `-u`, `--unique` | Solo las líneas que no se repiten | `uniq -u` |

Cómo se comparan:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-i`, `--ignore-case` | Sin distinguir mayúsculas | `uniq -ci` |
| `-f N`, `--skip-fields=N` | Ignora los N primeros campos, separados por blancos | `uniq -f 1` |
| `-s N`, `--skip-chars=N` | Ignora los N primeros caracteres | `uniq -s 3` |
| `-w N`, `--check-chars=N` | Compara solo los N primeros caracteres | `uniq -w 10` |

Con `-f` o `-s`, la línea que se imprime es la primera del grupo.
Para quitar repetidas sin contar, `sort -u` hace lo mismo que `sort | uniq` en un solo paso.

## Combinaciones habituales

```bash
# Las 10 IP con más peticiones
cut -d' ' -f1 acceso.log | sort | uniq -c | sort -rn | head
```

::: details Paso a paso

1. `cut -d' ' -f1 acceso.log` deja la IP de cada petición:

   ```text
   192.168.1.10
   10.0.0.7
   192.168.1.10
   172.16.0.3
   10.0.0.7
   192.168.1.10
   ```

2. `sort` las ordena, y así quedan juntas las repetidas:

   ```text
   10.0.0.7
   10.0.0.7
   172.16.0.3
   192.168.1.10
   192.168.1.10
   192.168.1.10
   ```

3. `uniq -c` deja una línea por IP, con las veces que aparece:

   ```text
         2 10.0.0.7
         1 172.16.0.3
         3 192.168.1.10
   ```

4. `sort -rn` ordena por ese número, de mayor a menor:

   ```text
         3 192.168.1.10
         2 10.0.0.7
         1 172.16.0.3
   ```

5. `head` deja las 10 primeras. Aquí solo hay tres IP, así que salen todas.

:::

```bash
# Usuarios ordenados por número de procesos
ps -eo user= | sort | uniq -c | sort -rn
```

```bash
# Valores que aparecen más de una vez (alumnos con varias notas)
tail -n +2 notas.csv | cut -d, -f1 | sort | uniq -d
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

2. `cut -d, -f1` deja el alumno de cada línea:

   ```text
   ana
   ana
   luis
   luis
   marta
   marta
   pablo
   ```

3. `sort` los ordena, y así quedan juntos los repetidos:

   ```text
   ana
   ana
   luis
   luis
   marta
   marta
   pablo
   ```

4. `uniq -d` deja una línea por cada valor repetido:

   ```text
   ana
   luis
   marta
   ```

:::

Contar por clave es el patrón «[Agregar por clave](../patterns/aggregate-by-key.md)».

## Errores frecuentes

**Entrada sin ordenar.**
`uniq` solo junta líneas consecutivas, así que sin `sort` cuenta mal y no avisa.

```console
$ uniq -c colores.txt
      2 rojo
      1 verde
      1 rojo
$ sort colores.txt | uniq -c
      3 rojo
      1 verde
```

**Espacios delante del contador.**
`uniq -c` alinea el número a la derecha con espacios, así que para `cut -d' '` el primer campo está vacío.

```bash
# ✗ Imprime líneas vacías
sort colores.txt | uniq -c | cut -d' ' -f1

# ✓ awk separa por blancos y se salta los iniciales
sort colores.txt | uniq -c | awk '{print $1}'
```

**`-f` separa por blancos.**
No hay opción de delimitador, así que `-f` no sirve para saltar campos de un CSV.
Por tanto nos obliga a usar primero `cut` o `awk`.

## Ver también

`man uniq` · [ficha de `sort`](sort.md) · [ficha de `cut`](cut.md) · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md) · patrón «[Agregar por clave](../patterns/aggregate-by-key.md)»
