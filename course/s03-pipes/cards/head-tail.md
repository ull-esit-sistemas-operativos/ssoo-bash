¿Los 3 primeros de una clasificación, o todo menos la cabecera?
`head` se queda con el principio de un texto y `tail` con el final.

```text
head [-n N] [fichero...]
tail [-n N] [fichero...]
```

Sin fichero, leen de la entrada estándar.
Sin `-n`, muestran 10 líneas.

## Ejemplo

```console
$ head -n 3 notas.csv
alumno,asignatura,nota
ana,SSOO,7.5
ana,FP,6
$ tail -n 2 notas.csv
marta,FP,8.5
pablo,SSOO,
$ tail -n +2 notas.csv
ana,SSOO,7.5
ana,FP,6
luis,SSOO,4.5
luis,FP,
marta,SSOO,9
marta,FP,8.5
pablo,SSOO,
```

El tercero empieza en la línea 2: es la forma de saltar la cabecera.

## Opciones útiles

De `head`:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-n N`, `--lines=N` | Las N primeras líneas | `head -n 3` |
| `-n -N` | Todas menos las N últimas | `head -n -1` |
| `-c N`, `--bytes=N` | Los N primeros bytes | `head -c 100` |
| `-c -N` | Todo menos los N últimos bytes | `head -c -1` |
| `-q`, `--quiet` | Con varios ficheros, sin las cabeceras `==> fichero <==` | `head -q -n 1 *.csv` |
| `-v`, `--verbose` | Con la cabecera aunque sea un solo fichero | `head -v notas.csv` |

De `tail`:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-n N`, `--lines=N` | Las N últimas líneas | `tail -n 2` |
| `-n +N` | Desde la línea N hasta el final | `tail -n +2` |
| `-c N`, `--bytes=N` | Los N últimos bytes | `tail -c 100` |
| `-c +N` | Desde el byte N hasta el final | `tail -c +5` |
| `-f`, `--follow` | Sigue mostrando lo que se añade al fichero, hasta Ctrl+C | `tail -f acceso.log` |
| `-F` | Como `-f`, y sigue aunque el fichero se renombre o se cree de nuevo (rotación de *logs*) | `tail -F /var/log/syslog` |
| `--pid=PID` | Con `-f`, termina cuando acaba ese proceso | `tail -f log --pid=1234` |
| `-q`, `-v` | Sin o con cabeceras, como en `head` | `tail -q -n 1 *.log` |

## Combinaciones habituales

```bash
# Las 3 IP con más peticiones
cut -d' ' -f1 acceso.log | sort | uniq -c | sort -rn | head -n 3
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

5. `head -n 3` deja las tres primeras. Aquí solo hay tres IP, así que salen todas.

:::

```bash
# Solo la línea 5
head -n 5 notas.csv | tail -n 1
```

::: details Paso a paso

1. `head -n 5 notas.csv` deja las 5 primeras líneas:

   ```text
   alumno,asignatura,nota
   ana,SSOO,7.5
   ana,FP,6
   luis,SSOO,4.5
   luis,FP,
   ```

2. `tail -n 1` deja la última de ellas, que es la 5 del fichero:

   ```text
   luis,FP,
   ```

:::

```bash
# Ordenar sin mover la cabecera
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

3. Las llaves juntan las dos salidas en una, con la cabecera arriba:

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
# Ver los errores de un log según llegan
tail -f /var/log/syslog | grep --line-buffered error
```

## Errores frecuentes

**`-n 2` frente a `-n +2` en `tail`.**
El signo cambia el sentido: sin `+` cuenta desde el final; con `+`, desde el principio.

```bash
# ✗ Las 2 últimas líneas, no «todo menos la cabecera»
tail -n 2 notas.csv

# ✓ Desde la línea 2
tail -n +2 notas.csv
```

**El signo menos en `head`.**
`head -n -1` no es «la última línea», sino todas menos la última.
Para la última, `tail -n 1`.

**Seguir un *log* por una tubería.**
Cuando la salida de `grep` no va a la terminal sino a otra tubería, `grep` la acumula en un búfer y no la entrega hasta llenarlo.
Con `tail -f` delante llegan pocas líneas, el búfer tarda en llenarse y parece que no pasa nada.
`--line-buffered` hace que entregue cada línea al momento.

```bash
# ✗ Llegan peticiones con 404, pero no aparece ninguna IP
tail -f acceso.log | grep 404 | cut -d' ' -f1

# ✓ Cada IP aparece en cuanto llega su petición
tail -f acceso.log | grep --line-buffered 404 | cut -d' ' -f1
```

Si `grep` es el último comando y escribe directamente en la terminal, no hace falta: ya muestra cada línea al momento.

## Ver también

`man head` · `man tail` · [ficha de `sort`](sort.md) · [ficha de `wc`](wc.md)
