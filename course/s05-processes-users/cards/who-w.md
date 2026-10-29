¿Quién está conectado ahora, desde dónde y qué está haciendo?
`who` lista las sesiones abiertas y `w` añade lo que hace cada una y la carga del sistema.
`users` solo da los nombres, y `last`, el historial de sesiones, incluidas las ya cerradas.

```text
who [opciones]
w [opciones] [usuario]
users
last [opciones] [usuario]
```

Para saber quién es un usuario para el sistema (UID, grupos) se usa `id` (ver la [ficha de `id`](id.md)).

## Ejemplo

Salidas típicas, con dos usuarios y tres sesiones.

```text
$ who
alu      pts/0        2026-10-24 09:12 (10.0.0.5)
luis     pts/1        2026-10-24 10:40 (10.0.0.7)
alu      pts/2        2026-10-24 11:03 (10.0.0.5)
$ users
alu alu luis
$ w
 11:05:31 up 3 days,  2:14,  3 users,  load average: 0,08, 0,03, 0,01
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU  WHAT
alu      pts/0    10.0.0.5         09:12    1:53m  0.21s  0.21s -bash
luis     pts/1    10.0.0.7         10:40    0.00s  0.05s  0.05s vim notas.sh
alu      pts/2    10.0.0.5         11:03    0.00s  0.02s  0.00s w
```

Cada línea de `who` es una sesión: usuario, terminal, fecha y hora de entrada y, entre paréntesis, desde dónde se conectó.
Un mismo usuario aparece tantas veces como sesiones tenga abiertas.

## Opciones útiles

`who`:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-H`, `--heading` | Añade una línea de cabecera | `who -H` |
| `-q`, `--count` | Solo los nombres y el número de sesiones | `who -q` |
| `-u`, `--users` | Añade el tiempo de inactividad y el PID de la sesión | `who -u` |
| `-m`, `am i` | Solo la sesión del terminal actual | `who am i` |
| `-b`, `--boot` | Fecha y hora del último arranque | `who -b` |
| `-r`, `--runlevel` | Nivel de ejecución actual | `who -r` |
| `-a`, `--all` | Todo lo anterior junto | `who -a` |

`w`:

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `USUARIO` | Solo las sesiones de ese usuario | `w alu` |
| `-h`, `--no-header` | Sin la línea de resumen ni la de títulos | `w -h` |
| `-s`, `--short` | Sin las columnas `LOGIN@`, `JCPU` y `PCPU` | `w -s` |
| `-i`, `--ip-addr` | La dirección IP en `FROM`, en vez del nombre | `w -i` |

`last` (las opciones pueden variar según la versión instalada):

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `USUARIO` | Solo las sesiones de ese usuario | `last alu` |
| `reboot` | Solo los arranques del sistema | `last reboot` |
| `-n N` | Solo las N más recientes | `last -n 5` |
| `-F`, `--fulltimes` | Fechas completas de entrada y salida | `last -F` |
| `-i`, `--ip` | La dirección IP en vez del nombre | `last -i` |

## Tablas de referencia

Columnas de `w`:

| Columna | Contiene |
| --- | --- |
| `USER`, `TTY`, `FROM` | Usuario, terminal y desde dónde se conectó |
| `LOGIN@` | Hora de entrada |
| `IDLE` | Tiempo sin teclear nada en esa sesión |
| `JCPU` | CPU usada por todos los procesos de la sesión |
| `PCPU` | CPU usada por el proceso que se está ejecutando |
| `WHAT` | Orden que se está ejecutando |

La primera línea de `w` es la de `uptime`: hora, tiempo desde el arranque, número de sesiones y carga media del sistema en los últimos 1, 5 y 15 minutos.

## Combinaciones habituales

```bash
# Usuarios conectados, sin repetir
who | cut -d' ' -f1 | sort -u
```

::: details Paso a paso

1. Con las sesiones del ejemplo, `who | cut -d' ' -f1` deja el usuario de cada sesión:

   ```text
   alu
   luis
   alu
   ```

2. `sort -u` los ordena y quita los repetidos:

   ```text
   alu
   luis
   ```

:::

```bash
# ¿Está conectado este usuario?
who | cut -d' ' -f1 | grep -qx "$usuario"
```

::: details Paso a paso

1. Con las sesiones del ejemplo, `who | cut -d' ' -f1` deja el usuario de cada sesión:

   ```text
   alu
   luis
   alu
   ```

2. Con `usuario=luis`, `grep -qx "$usuario"` no escribe nada, pero termina con estado 0 porque una línea entera es `luis`.

:::

```bash
# Sesiones abiertas por cada usuario
who | cut -d' ' -f1 | sort | uniq -c | sort -rn
```

::: details Paso a paso

1. Con las sesiones del ejemplo, `who | cut -d' ' -f1` deja el usuario de cada sesión:

   ```text
   alu
   luis
   alu
   ```

2. `sort` los ordena, y así quedan juntos los repetidos:

   ```text
   alu
   alu
   luis
   ```

3. `uniq -c` deja una línea por usuario, con las veces que aparece:

   ```text
         2 alu
         1 luis
   ```

4. `sort -rn` ordena por ese número, de mayor a menor. Aquí ya estaban en ese orden.

:::

```bash
# Las 5 últimas entradas de un usuario
last -n 5 "$usuario"
```

Aquí se puede usar `cut -d' '` porque el nombre está al principio de la línea.
Para el resto de columnas mejor `awk`.

## Errores frecuentes

**Un usuario, varias líneas.**
`who` y `users` listan sesiones, no usuarios.
Para contar usuarios hay que quitar repetidos.

```bash
# ✗ Cuenta sesiones: 3 en el ejemplo
who | wc -l

# ✓ Cuenta usuarios: 2
who | cut -d' ' -f1 | sort -u | wc -l
```

**Comparar el nombre con `grep` sin `-x`.**
`grep alu` también encaja con `alumno`.
Mejor `grep -x`, que exige la línea entera.

**`who am i` no es `whoami`.**
`who am i` busca la sesión del terminal desde el que se ejecuta.
Por eso, con `sudo` sigue mostrando el usuario que entró en el sistema, y en un *script* sin terminal no muestra nada.
`whoami` muestra el usuario con el que se ejecuta la orden, que con `sudo` es `root`.
Para saber quién ejecuta un *script*, usar `whoami` o `id -un` (ver la [ficha de `id`](id.md)).

**`who`, `w`, `users` y `last` vacíos.**
En WSL, en contenedores y en algunas máquinas virtuales no se registran las sesiones, y estos comandos no muestran nada aunque haya alguien conectado.
Para saber qué usuarios tienen procesos, `ps -eo user= | sort -u`.

**La carga media sale con coma.**
En un equipo en español, `w` y `uptime` escriben la carga media con coma decimal (`0,08`).
Si se procesa con `awk` o `sort -n`, coincide con la configuración regional y no hay que convertir nada.
Con `LC_ALL=C` delante dejaría de coincidir.

## Ver también

`man who` · `man w` · `man last` · [ficha de `id`](id.md) · [ficha de `ps`](ps.md)
