¿Cómo termino un proceso que no responde?
`kill` no mata por sí mismo sino que envía una señal, y es el proceso, o el núcleo, quien decide qué hacer con ella.
La señal por defecto, `TERM`, le pide que termine.

```text
kill [-SEÑAL] PID...
kill -l [NÚMERO]
```

La señal se da por nombre (`-TERM`, `-s TERM`) o por número (`-15`).
En bash, `kill` es una orden interna y también acepta trabajos: `kill %1`.

## Ejemplo

```console
$ sleep 100 &
[1] 874
$ kill -STOP 874
$ ps -o pid,stat,comm -p 874
  PID STAT COMMAND
  874 T    sleep
$ kill -CONT 874
$ ps -o pid,stat,comm -p 874
  PID STAT COMMAND
  874 S    sleep
$ kill 874
$ kill 874
bash: kill: (874) - No such process
```

`STOP` lo detiene (estado `T`), `CONT` lo reanuda y `TERM` lo termina.
El segundo `kill` falla porque el proceso ya no existe.

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-SEÑAL` | Envía esa señal, por nombre (con o sin `SIG`) o por número | `kill -INT 874` |
| `-s SEÑAL` | Igual, con la señal como argumento aparte | `kill -s HUP 874` |
| `-l` | Lista todas las señales con su número | `kill -l` |
| `-l N` | Traduce un número a nombre, o un nombre a número | `kill -l 9` → `KILL` |
| `-0` | No envía nada; solo comprueba si el proceso existe y se le pueden enviar señales | `kill -0 874` |
| `%N` | El trabajo N del terminal en vez de un PID | `kill %1` |

Para elegir procesos por nombre o por usuario en vez de por PID: `pkill` (`pkill -u alu sleep`) y `killall` (`killall firefox`).

## Tablas de referencia

Señales más usadas (números de Linux en x86):

| Señal | Número | Acción por defecto | Se puede capturar | Se envía con |
| --- | --- | --- | --- | --- |
| `HUP` | 1 | Terminar | Sí | Se cierra el terminal; por convenio, los servicios releen su configuración |
| `INT` | 2 | Terminar | Sí | Ctrl+C |
| `QUIT` | 3 | Terminar con volcado de memoria | Sí | Ctrl+\\ |
| `KILL` | 9 | Terminar | No | `kill -9`: último recurso |
| `USR1`, `USR2` | 10, 12 | Terminar | Sí | Uso libre de cada programa |
| `SEGV` | 11 | Terminar con volcado | Sí | Acceso a memoria inválido |
| `PIPE` | 13 | Terminar | Sí | Escribir en una tubería que nadie lee |
| `ALRM` | 14 | Terminar | Sí | Temporizador (`alarm`) |
| `TERM` | 15 | Terminar | Sí | `kill` sin señal: la forma educada de pedir el fin |
| `CHLD` | 17 | Ignorar | Sí | Un hijo termina o se detiene |
| `CONT` | 18 | Continuar | Sí | `fg`, `bg` |
| `STOP` | 19 | Detener | No | `kill -STOP` |
| `TSTP` | 20 | Detener | Sí | Ctrl+Z |

En un *script*, `trap` captura las señales que se pueden capturar.
Además acepta `EXIT`, que no es una señal del sistema, pero se ejecuta al terminar el *script* por cualquier motivo (salvo `KILL`).

## Combinaciones habituales

```bash
# Terminar los procesos de un usuario que llevan más de una hora
ps -u "$usuario" -o pid=,etimes= | awk '$2 > 3600 { print $1 }' | xargs -r kill

# ¿Sigue vivo?
kill -0 "$pid" 2>/dev/null && echo "sigue vivo"

# Pedir que termine y, si a los 5 segundos sigue, forzarlo
kill "$pid"; sleep 5; kill -0 "$pid" 2>/dev/null && kill -KILL "$pid"

# En un script: borrar el temporal al salir, pase lo que pase
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
```

`xargs -r` pasa los PID que recibe como argumentos de `kill`, y no lo ejecuta si no recibe ninguno.

## Errores frecuentes

**Empezar por `kill -9`.**
`KILL` no se puede capturar: el proceso no borra sus temporales ni guarda nada, y su `trap ... EXIT` no se ejecuta.
Primero `TERM`, y luego `KILL` solo si no responde.

**Procesos de otro usuario.**
Sin ser root, solo se pueden enviar señales a los procesos propios.
`kill` falla y devuelve 1.

```console
$ kill 1
bash: kill: (1) - Operation not permitted
```

**`kill -0` no mata.**
Solo comprueba.
Su fallo puede significar que el proceso no existe o que no es tuyo.
El mensaje de error dice cuál es el caso.

**`kill` sin PID.**
Con una variable vacía (`kill $pid` sin comillas y sin valor), `kill` se queja de que le faltan argumentos.
Comprueba antes que la lista de PID no está vacía, o usa `xargs -r`.

## Ver también

`help kill` · `man 7 signal` (todas las señales) · `help trap`
