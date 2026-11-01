Cada proceso y cada fichero pertenecen a un usuario.
Para el sistema, un **usuario** es un número —el identificador de usuario (UID)— con un nombre asociado.
Los usuarios se agrupan en grupos, cada uno con su identificador de grupo (GID).

- **`id`.**
  Muestra el UID, el grupo principal y todos los grupos del usuario actual, o del que le indiquemos.
  `id -un` imprime solo el nombre, mientras que `id -u` muestra solo el UID.
- **`who`.**
  Lista los usuarios conectados: nombre, terminal, hora de entrada y, a veces, desde dónde.
- **`w`.**
  Es como `who`, pero además muestra qué está haciendo cada usuario.
- **`/etc/passwd`.**
  Contiene una línea por usuario con siete campos separados por dos puntos.

```console
$ id
uid=1000(alu) gid=1000(alu) grupos=1000(alu),1001(alumnos)
$ grep '^alu:' /etc/passwd
alu:x:1000:1000:Alumno ULL:/home/alu:/bin/bash
```

Los campos de `/etc/passwd` son el nombre, una `x`, el UID, el GID principal, el nombre completo, el directorio personal y la *shell*.
La `x` está donde antes iba la contraseña, que ahora se guarda en otro fichero.
Se procesan bien con `cut -d:` o con `awk -F:`.
En máquinas cuyos usuarios están centralizados en un servidor, no todos están en `/etc/passwd`.
En ese caso `getent passwd` muestra la lista completa con el mismo formato.

## Actuar como otro usuario

Algunas tareas exigen actuar como otro usuario, normalmente el administrador (root):

- **`sudo orden`.**
  Ejecuta una sola orden como root, pidiendo nuestra propia contraseña.
  Solo funciona si el administrador nos ha dado ese derecho.
- **`su - usuario`.**
  Abre una *shell* como otro usuario, pidiendo la contraseña de ese usuario.
  Sin indicar un nombre de usuario, se refiere a root.

En las máquinas del aula no tendremos permisos de administrador, así que estos comandos los tendremos que practicar en nuestra propia máquina.
