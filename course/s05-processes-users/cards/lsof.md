¿Quién está usando este fichero, o por qué no puedo desmontar el USB?
`lsof` lista, para cada proceso, los ficheros que tiene abiertos: ficheros normales, su directorio de trabajo, librerías, tuberías y conexiones de red.

```text
lsof [opciones] [fichero...]
```

Sin argumentos, lista todo lo abierto por todos los procesos que el usuario puede ver.
Indicando un fichero, solo los procesos que lo tienen abierto.

## Ejemplo

```console
$ exec 3< notas.csv
$ tail -f acceso.log > /dev/null &
$ lsof notas.csv
COMMAND PID USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
bash    975  alu    3r   REG  254,0      106 787239 notas.csv
tail    976  alu    3r   REG  254,0      106 787239 notas.csv
$ lsof -t acceso.log
976
```

La *shell* abre `notas.csv` como descriptor 3 para lectura (`3r`).
Pero `tail` también lo tiene abierto aunque no lo usa, pues lo heredó al crearse como hijo de la *shell*.

## Opciones útiles

Qué procesos o ficheros (varias de estas opciones se combinan con «o» salvo que se añada `-a`):

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `FICHERO` | Los procesos que tienen abierto ese fichero | `lsof notas.csv` |
| `+D DIR` | Lo abierto dentro de ese directorio y sus subdirectorios | `lsof +D /media/usb` |
| `+d DIR` | Lo abierto dentro de ese directorio, sin bajar a los subdirectorios | `lsof +d /tmp` |
| `-p PID` | Lo abierto por esos procesos. `^PID` los excluye | `lsof -p 975` |
| `-u USUARIO` | Lo abierto por los procesos de ese usuario; `^USUARIO` los excluye | `lsof -u alu` |
| `-c PREFIJO` | Lo abierto por los procesos cuyo nombre empieza así | `lsof -c tail` |
| `-d FD` | Solo esos descriptores (`cwd`, `txt`, `0-2`…) | `lsof -d cwd` |
| `-i [DIRECCIÓN]` | Conexiones de red; `:80` un puerto, `tcp` o `udp` un protocolo | `lsof -i :80` |
| `-U` | *Sockets* de dominio Unix | `lsof -U` |
| `+L1` | Ficheros borrados que algún proceso sigue teniendo abiertos | `lsof +L1` |
| `-a` | Combina las condiciones con «y» en vez de con «o» | `lsof -a -u alu -c tail` |

Cómo se muestra:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-t` | Solo los PID, uno por línea y sin cabecera: para pasarlos a `kill` | `lsof -t notas.csv` |
| `-F CAMPOS` | Salida para programas: un campo por línea, con una letra delante (`p` PID, `c` orden, `u` UID, `f` descriptor, `n` nombre) | `lsof -F pcn notas.csv` |
| `-n` | No traduce direcciones IP a nombres (más rápido) | `lsof -n -i` |
| `-P` | No traduce números de puerto a nombres | `lsof -P -i` |
| `+c N` | Ancho de la columna `COMMAND` (0 = sin recortar) | `lsof +c 0` |
| `-l` | UID en número en vez de nombre | `lsof -l` |
| `-w` | Calla los avisos | `lsof -w` |

## Tablas de referencia

Columnas de la salida de `lsof`:

| Columna | Contiene |
| --- | --- |
| `COMMAND` | Nombre del proceso, recortado a 9 caracteres |
| `PID`, `USER` | PID y propietario del proceso |
| `FD` | Descriptor y modo de apertura ([tabla siguiente](#valores-de-la-columna-fd)) |
| `TYPE` | Tipo: `REG` fichero, `DIR` directorio, `CHR` dispositivo de caracteres, `FIFO` tubería, `IPv4`, `IPv6`, `unix` |
| `DEVICE` | Dispositivo donde está el fichero |
| `SIZE/OFF` | Tamaño, o posición de lectura (`0t…`) |
| `NODE` | Número de nodo-i |
| `NAME` | Ruta, o direcciones y puertos si es una conexión |

Valores de la columna `FD`:

| `FD` | Significa |
| --- | --- |
| `cwd` | Directorio de trabajo actual |
| `rtd` | Directorio raíz |
| `txt` | El ejecutable del programa |
| `mem` | Fichero proyectado en memoria (bibliotecas) |
| `0`, `1`, `2`… | Número de descriptor: entrada, salida y error estándar, y los que abra el proceso |
| `r`, `w`, `u` | Detrás del número: abierto para lectura, escritura o ambas |

## Combinaciones habituales

```bash
# Cuántos ficheros tiene abiertos cada proceso de un usuario
lsof -u "$usuario" 2>/dev/null | awk 'NR > 1 { print $2 }' | sort | uniq -c | sort -rn

# Qué procesos impiden desmontar un USB, y terminarlos
lsof -t +D /media/usb
kill $(lsof -t +D /media/usb)

# Qué programa está escuchando en el puerto 80
lsof -i :80

# Ficheros borrados que siguen ocupando disco porque alguien los tiene abiertos
lsof +L1
```

## Errores frecuentes

**Las condiciones se suman con «o».**
Es decir, `-u alu -c tail` lista lo de los procesos de `alu` más lo de los procesos `tail` de cualquiera.
En el entorno de prueba, 89 líneas frente a 13.

```bash
# ✗ Todo lo de alu, y además todo lo de cualquier tail
lsof -u alu -c tail

# ✓ Solo los tail de alu
lsof -a -u alu -c tail
```

**Sin root, solo lo propio.**
De los procesos de otros usuarios no puede leer qué tienen abierto, y escribe avisos por cada uno (`Permission denied`).
Para un *script*: `2>/dev/null` o `-w`.

**`COMMAND` recortado.**
Por defecto ocupa 9 caracteres: un proceso `process_api` aparece como `process_a`.
Para compararlo con un nombre: `+c 0`, o mejor `-F c`.

**Nombres con espacios en `NAME`.**
Un espacio en la ruta descuadra los campos para `awk`.
Con `-F n`, el nombre va en su propia línea.

## Ver también

`man lsof` · [ficha de `ps`](ps.md) · [ficha de `kill`](kill.md) · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md)
