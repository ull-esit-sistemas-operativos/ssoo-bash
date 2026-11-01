Los retos suponen el usuario `alu` del contenedor del curso, con UID 1000, grupo principal `alu` y grupo secundario `alumnos`.

## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `id -Gn alu | wc -w`?
  options:
    - id: a
      value: "`2`"
      isCorrect: true
      explanation: "Son `alu` y `alumnos`: `id -Gn` incluye también el grupo principal."
    - id: b
      value: "`1`"
      incorrectExplanation: "`id -Gn` incluye también el grupo principal, `alu`, además de `alumnos`."
    - id: c
      value: "`alu alumnos`"
      incorrectExplanation: "`wc -w` imprime cuántas palabras hay, no las palabras."
    - id: d
      value: Un error, porque `id` solo muestra los datos de quien lo ejecuta
      incorrectExplanation: "`id` admite el nombre de un usuario y muestra sus datos."
```

## Reto 2 · Prueba

Muestra solo el UID del usuario actual y, con otra orden, solo su nombre.

::: details Solución

```bash
id -u
id -un
```

```text
1000
alu
```

`whoami` da lo mismo que `id -un`.

:::

## Reto 3 · Combina

Escribe la línea que, al principio de un *script*, lo termina con un mensaje de error si no se está ejecutando como `root`.

::: details Solución

```bash
[[ $(id -u) -eq 0 ]] || { echo "hay que ejecutarlo como root" >&2; exit 1; }
```

Se compara el UID y no el nombre, porque lo que da los privilegios es el UID 0.

:::

## Reto 4 · Combina

```quiz
- id: "4"
  type: string
  content: |
    Ejecuta `passwd` en una terminal y déjalo esperando la contraseña actual.
    Desde otra terminal, muestra con `ps` el usuario de ese proceso.
    ¿Qué usuario aparece?
  options:
    - id: a
      value: "root"
```

::: details Solución

```bash
ps -o pid,user,ruser,comm -C passwd
```

```text
    PID USER     RUSER    COMMAND
   2301 root     alu      passwd
```

`passwd` tiene el permiso *setuid* y es de root (ver el apartado «Permisos especiales» de la lectura «[Permisos](../../s02-files/permissions.md)» de la semana 2).
Por eso el proceso tiene dos usuarios: el **UID real** es el de quien lo ha lanzado, `alu`, y el **UID efectivo**, el que decide los permisos, es el de root.
La columna `user` de `ps` muestra el efectivo y `ruser`, el real, igual que `id -u` y `id -ru`.
`/proc` da los dos números: la línea `Uid:` de `/proc/PID/status` empieza por el real y el efectivo, `1000` y `0`.

Termina `passwd` con [[Ctrl]]+[[C]] sin escribir nada.

:::
