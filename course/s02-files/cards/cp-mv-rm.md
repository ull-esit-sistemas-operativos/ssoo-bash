¿Copiar un directorio entero, renombrar sin pisar nada o borrar sin sorpresas?
`cp` copia, `mv` mueve o renombra y `rm` borra.

```text
cp [opciones] origen... destino
mv [opciones] origen... destino
rm [opciones] fichero...
```

Si el destino es un directorio que existe, `cp` y `mv` dejan dentro los orígenes con su nombre; si no, el destino es el nombre nuevo.
Con varios orígenes, el destino tiene que ser un directorio.

## Ejemplo

```console
$ cp -r proyecto copia
$ mv copia/README.md copia/LEEME.md
$ rm -r copia/docs
$ ls -A copia
LEEME.md  .oculto  src
```

`cp -r` copia el árbol entero, `mv` renombra `README.md` dentro de la copia y `rm -r` borra `docs` con lo que contiene.
`proyecto` queda como estaba.

## Opciones útiles

De `cp`:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-r`, `-R`, `--recursive` | Copia directorios con todo lo que contienen | `cp -r proyecto copia` |
| `-i`, `--interactive` | Pregunta antes de sobrescribir | `cp -i a.txt b.txt` |
| `-p` | Conserva los permisos y las fechas | `cp -p info.sh copia.sh` |
| `-a`, `--archive` | Como `-r -p`, y copia los enlaces simbólicos como enlaces | `cp -a proyecto copia` |
| `-u`, `--update` | Solo copia si el origen es más reciente que el destino, o el destino no existe | `cp -u *.txt copia/` |
| `-v`, `--verbose` | Dice qué copia | `cp -v *.c src/` |

De `mv`:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-i`, `--interactive` | Pregunta antes de sobrescribir | `mv -i borrador.txt notas.txt` |
| `-v`, `--verbose` | Dice qué mueve | `mv -v *.log logs/` |

De `rm`:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-r`, `-R`, `--recursive` | Borra directorios con todo lo que contienen | `rm -r copia` |
| `-i` | Pregunta antes de borrar cada fichero | `rm -i *.tmp` |
| `-I` | Pregunta una sola vez si va a borrar más de tres ficheros o un directorio | `rm -rI copia` |
| `-f`, `--force` | No pregunta, y no avisa si el fichero no existe | `rm -f salida.txt` |
| `-d`, `--dir` | Borra también directorios vacíos, como `rmdir` | `rm -d vacio` |
| `-v`, `--verbose` | Dice qué borra | `rm -v *.tmp` |

En los tres, `--` marca el fin de las opciones: `rm -- -raro.txt` borra un fichero cuyo nombre empieza por guion.

## Combinaciones habituales

```bash
# Copia de seguridad de un árbol, con sus permisos y fechas
cp -a proyecto proyecto.bak
```

```bash
# Mover varios ficheros a un directorio
mv *.txt *.csv datos/
```

```bash
# Borrar un árbol viendo qué se borra
rm -rv copia
```

```bash
# Probar un patrón antes de borrar con él
echo *.tmp
rm *.tmp
```

## Errores frecuentes

**El destino ya existe, o no.**
`cp -r proyecto copia` crea `copia` la primera vez, pero si se repite, `copia` ya existe y la nueva copia queda dentro, en `copia/proyecto`.
Lo mismo pasa con `mv`.
Si lo que se quiere es el contenido, `cp -r proyecto/. copia` copia lo que hay dentro de `proyecto`, también los ficheros ocultos.

**Sobrescribir sin aviso.**
`cp` y `mv` sustituyen el destino si ya existe, sin preguntar.
Con `-i` preguntan antes.

**Copiar un directorio sin `-r`.**
`cp proyecto copia` no copia nada.
Avisa de que omite el directorio, porque sin `-r` solo copia ficheros.
`mv`, en cambio, mueve directorios sin ninguna opción.

**`rm -rf` con una variable vacía.**
En `rm -rf "$dir"/*`, si `dir` está vacía, la orden se queda en `rm -rf /*`.
Antes de borrar con una variable, comprueba que tiene el valor que esperas, como en «[Variables y argumentos](../variables-and-arguments.md)».

## Ver también

`man cp` · `man mv` · `man rm` · lectura «[Copiar, mover y borrar](../copy-move-remove.md)» · [ficha de `find`](find.md) (`-delete`)
