¿Quién soy para el sistema, y puedo hacer esto?
`id` muestra cómo identifica el sistema a un usuario: su UID, su grupo principal y todos sus grupos, que son lo que decide los permisos del usuario.
Lo que no da `id`, como la *shell* o el directorio personal, está en `/etc/passwd`.

```text
id [opciones] [usuario]
whoami
groups [usuario]
```

Sin usuario, hablan del usuario que ejecuta la orden.
Para saber quién está conectado se usa `who` (ver la [ficha de `who` y `w`](who-w.md)).

## Ejemplo

```console
$ id
uid=1000(alu) gid=1000(alu) groups=1000(alu),1001(alumnos)
$ id -un
alu
$ id -Gn
alu alumnos
$ id root
uid=0(root) gid=0(root) groups=0(root)
$ groups alu
alu : alu alumnos
```

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-u`, `--user` | Solo el UID efectivo | `id -u` |
| `-g`, `--group` | Solo el GID del grupo principal | `id -g` |
| `-G`, `--groups` | Los GID de todos los grupos | `id -G` |
| `-n`, `--name` | Con `-u`, `-g` o `-G`: nombres en vez de números | `id -un` |
| `-r`, `--real` | Con `-u`, `-g` o `-G`: el ID real en vez del efectivo | `id -ru` |

Atajos de la misma familia:

| Comando | Equivale a | Diferencia |
| --- | --- | --- |
| `whoami` | `id -un` | Solo para el usuario actual |
| `groups` | `id -Gn` | Con un usuario como argumento, antepone `usuario :` |

Cuando las cuentas están centralizadas en un servidor, no todos los usuarios ni grupos aparecen en `/etc/passwd` y `/etc/group`.
`getent passwd` y `getent group` muestran la lista completa con el mismo formato, y aceptan un nombre de usuario para buscar: `getent passwd alu`.

## Tablas de referencia

Campos de `/etc/passwd`, separados por `:`; usando como ejemplo la línea `alu:x:1000:1000:Alumno ULL:/home/alu:/bin/bash`:

| Campo | Ejemplo | Contiene |
| --- | --- | --- |
| 1 | `alu` | Nombre de usuario |
| 2 | `x` | Contraseña. La `x` indica que está en `/etc/shadow` |
| 3 | `1000` | UID |
| 4 | `1000` | GID del grupo principal |
| 5 | `Alumno ULL` | Nombre completo y otros datos (GECOS) |
| 6 | `/home/alu` | Directorio personal |
| 7 | `/bin/bash` | *Shell*; `/usr/sbin/nologin` en las cuentas que no pueden iniciar sesión |

En Ubuntu, los usuarios personas tienen UID desde 1000.
Los inferiores son cuentas del sistema, y `root` tiene el 0.

Campos de `/etc/group`, con la línea `alumnos:x:1001:alu`: como ejemplo

| Campo | Ejemplo | Contiene |
| --- | --- | --- |
| 1 | `alumnos` | Nombre del grupo |
| 2 | `x` | Contraseña del grupo; casi nunca se usa |
| 3 | `1001` | GID |
| 4 | `alu` | Miembros secundarios, separados por comas |

## Combinaciones habituales

```bash
# ¿Se está ejecutando como root?
[[ $(id -u) -eq 0 ]] || { echo "hay que ejecutarlo como root" >&2; exit 1; }
```

```bash
# ¿Pertenece al grupo sudo?
id -nG "$usuario" | tr ' ' '\n' | grep -qx sudo
```

::: details Paso a paso

1. Con `usuario=alu`, `id -nG "$usuario"` escribe sus grupos en una línea:

   ```text
   alu alumnos
   ```

2. `tr ' ' '\n'` pone cada grupo en su línea:

   ```text
   alu
   alumnos
   ```

3. `grep -qx sudo` no escribe nada. `-x` exige que la línea entera sea `sudo`, para que no encaje con un grupo llamado, por ejemplo, `nosudo`, y `-q` deja solo el estado de salida: aquí 1, porque `alu` no está en `sudo`.

:::

```bash
# Usuarios personas con shell bash
awk -F: '$3 >= 1000 && $7 ~ /bash$/ { print $1 }' /etc/passwd
```

```bash
# Miembros secundarios de un grupo
getent group alumnos | cut -d: -f4
```

## Errores frecuentes

**Números o nombres.**
`id -G` da GID; para comparar con un nombre de grupo hace falta `-n`.

**El grupo principal no aparece en `/etc/group`.**
El cuarto campo de `/etc/group` solo lista los miembros secundarios.
El grupo principal de cada usuario está en el cuarto campo de `/etc/passwd`, así que buscar al usuario en `/etc/group` no basta.

```console
$ grep '^alu:' /etc/group
alu:x:1000:
$ id -Gn alu
alu alumnos
```

Para saber si un usuario pertenece a un grupo, mejor `id -Gn`, que incluye los dos.

**`whoami` no es `who am i`.**
`whoami` da el usuario con el que se ejecuta la orden; `who am i`, la sesión del terminal.
Con `sudo` dan resultados distintos (ver la [ficha de `who` y `w`](who-w.md)).

## Ver también

`man id` · `man 5 passwd` · `man 5 group` · [ficha de `who` y `w`](who-w.md) · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md)
