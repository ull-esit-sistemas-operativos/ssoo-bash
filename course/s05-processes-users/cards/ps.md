¿Qué se está ejecutando, de quién es y cuánto consume?
`ps` muestra una foto de los procesos en este instante, con las columnas que se le pidan.

```text
ps [opciones]
```

Sin opciones, solo muestra los procesos del terminal actual.
Para elegir columnas, `-o`; para elegir procesos, `-e`, `-u`, `-p` o `-C`.

## Ejemplo

```console
$ ps
  PID TTY          TIME CMD
  887 pts/0    00:00:00 bash
  888 pts/0    00:00:00 sleep
  890 pts/0    00:00:00 ps
$ ps -o pid,ppid,stat,etime,comm
  PID  PPID STAT     ELAPSED COMMAND
  887   886 Ss+        00:00 bash
  888   887 S+         00:00 sleep
  891   887 R+         00:00 ps
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
alu        887   886  0 00:12 pts/0    00:00:00 bash
alu        888   887  0 00:12 pts/0    00:00:00 sleep 300
alu        894   887  0 00:12 pts/0    00:00:00 ps -f
```

## Opciones útiles

Qué procesos:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-e`, `-A` | Todos los procesos del sistema | `ps -e` |
| `-u USUARIO` | Los de ese usuario (nombre o UID; varios separados por comas) | `ps -u alu` |
| `-p PID` | Los de esos PID | `ps -p 887,888` |
| `--ppid PID` | Los hijos de ese proceso | `ps --ppid 887` |
| `-C NOMBRE` | Los que se llaman así (por el nombre del ejecutable) | `ps -C sshd` |
| `-t TTY` | Los de ese terminal | `ps -t pts/0` |

Qué columnas y en qué orden:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-o CAMPOS` | Esas columnas (ver la [tabla de referencia](#campos-de-o)), separadas por comas | `ps -o pid,user,comm` |
| `CAMPO=` | Esa columna sin título. Con todas así, no hay línea de cabecera | `ps -eo pid=,comm=` |
| `--no-headers` | Sin línea de cabecera | `ps -e --no-headers` |
| `-f` | Formato completo: UID, PID, PPID, inicio, terminal y orden completa | `ps -ef` |
| `-l` | Formato largo: añade estado, prioridad y tamaño | `ps -l` |
| `--sort=CAMPO` | Ordena por esa columna; con `-` delante, de mayor a menor | `--sort=-pmem` |
| `-H`, `--forest` | Muestra el árbol de procesos con sangría | `ps -e --forest` |
| `-ww` | No recorta la orden al ancho del terminal | `ps -efww` |

También existe el estilo BSD, sin guion: `ps aux` muestra todos los procesos con usuario, `%CPU`, `%MEM` y la orden.
Mezclar los dos estilos en una misma orden confunde.
En los *scripts*, mejor usar `-e` y `-o`.

## Tablas de referencia

Campos de `-o`:

| Campo | Título | Contiene |
| --- | --- | --- |
| `pid`, `ppid` | `PID`, `PPID` | PID del proceso y de su padre |
| `user`, `uid` | `USER`, `UID` | Usuario efectivo, por nombre o por número |
| `group` | `GROUP` | Grupo efectivo |
| `pcpu` o `%cpu` | `%CPU` | CPU usada desde que empezó, en % |
| `pmem` o `%mem` | `%MEM` | Memoria física en uso, en % del total |
| `rss` | `RSS` | Memoria física en uso, en KiB |
| `vsz` | `VSZ` | Memoria virtual, en KiB |
| `stat` | `STAT` | Estado ([tabla siguiente](#estados-de-la-columna-stat)) |
| `tty` | `TT` | Terminal; `?` si no tiene |
| `etime` | `ELAPSED` | Tiempo desde que empezó, como `[[dd-]hh:]mm:ss` |
| `etimes` | `ELAPSED` | Tiempo desde que empezó, en segundos |
| `time` | `TIME` | Tiempo de CPU acumulado |
| `lstart` | `STARTED` | Fecha y hora de inicio completas |
| `ni` | `NI` | Valor *nice* (prioridad) |
| `nlwp` | `NLWP` | Número de hilos |
| `comm` | `COMMAND` | Nombre del ejecutable, recortado a 15 caracteres |
| `args` | `COMMAND` | Orden completa con sus argumentos |

Estados de la columna `STAT`:

| Estado | Significa |
| --- | --- |
| `R` | Ejecutándose o listo para ejecutarse |
| `S` | Dormido, esperando un evento (el más habitual) |
| `D` | Esperando E/S, sin poder interrumpirse |
| `T` | Detenido (Ctrl+Z o `SIGSTOP`) |
| `Z` | Zombi: terminó y su padre aún no ha recogido su estado |
| `I` | Hilo del núcleo inactivo |
| `s`, `+`, `l` | Detrás de la letra: líder de sesión, en primer plano, multihilo |
| `<`, `N` | Detrás de la letra: prioridad alta, prioridad baja |

## Combinaciones habituales

```bash
# Número de procesos de cada usuario
ps -eo user= | sort | uniq -c | sort -rn

# Los 5 procesos que más memoria usan
ps -eo pid,user,pmem,comm --sort=-pmem | head -n 6

# PID de los procesos de un usuario que llevan más de una hora
ps -u "$usuario" -o pid=,etimes= | awk '$2 > 3600 { print $1 }'

# ¿Está en marcha? Buscar procesos por nombre
pgrep -a firefox
```

`pgrep` busca por nombre y devuelve PID.
Con `-a` muestra también la orden, con `-u` filtra por usuario y con `-x` exige el nombre exacto.
Su pareja para enviar señales es `pkill`, con las mismas opciones.

## Errores frecuentes

**`grep` se encuentra a sí mismo.**
En `ps aux | grep sleep`, el propio `grep sleep` también es un proceso y sale en la lista.

```console
$ ps aux | grep sleep
alu        855  0.0  0.0   5712  2228 ?        S    00:12   0:00 sleep 300
alu        866  0.0  0.0   6572  2444 ?        S    00:12   0:00 grep sleep
$ pgrep -a sleep
855 sleep 300
```

**Columnas alineadas con espacios.**
`cut -d' '` no sirve para la salida de `ps`.
Pide solo las columnas que necesitas con `-o` y sácalas con `awk`, que separa por blancos.

**`comm` frente a `args`.**
`comm` es el nombre del ejecutable, recortado a 15 caracteres.
Por ejemplo, un *script* de Python aparece como `python3`.
Para ver con qué argumentos se lanzó, `args`.

**Decimales de `%mem` y `%cpu`.**
Salen con punto aunque el *locale* sea español, así que `mawk` los lee mal.
Compara con `LC_ALL=C awk` (ver la [ficha de `awk`](../../s04-expansions-loops/cards/awk.md)).

## Ver también

`man ps` («STANDARD FORMAT SPECIFIERS» para todos los campos) · [ficha de `kill`](kill.md) · [ficha de `lsof`](lsof.md) · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md)
