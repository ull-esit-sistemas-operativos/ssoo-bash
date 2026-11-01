Linux es un sistema multiusuario: en la misma máquina conviven ficheros de muchos usuarios y del propio sistema.
¿Cómo se decide quién puede leer, modificar o ejecutar cada uno?

Los **permisos** de un fichero son tres derechos (leer, escribir y ejecutar) que se conceden por separado a tres clases de usuarios: el propietario, el grupo del fichero y el resto.
Aparecen en las diez primeras columnas de `ls -l`:

```text
-rwxr-x--- 1 alu alu 512 oct 22 11:10 info.sh
```

El primer carácter es el tipo: `-` para un fichero normal, `d` para un directorio y `l` para un enlace simbólico.
Después vienen tres grupos de tres: `rwx` para el propietario (`alu`), `r-x` para el grupo (también `alu`: en muchas distribuciones de Linux cada usuario tiene un grupo con su mismo nombre) y `---` para los demás.
Un guion significa que ese permiso falta, es decir, que no se tiene ese derecho.

En un directorio, los mismos tres permisos significan cosas distintas:

| Permiso | En un fichero | En un directorio |
| --- | --- | --- |
| `r` | Leer el contenido | Listar los nombres que contiene |
| `w` | Modificar el contenido | Crear, borrar y renombrar entradas |
| `x` | Ejecutarlo | Entrar en él y acceder a lo que contiene |

Una consecuencia que sorprende es que borrar un fichero depende del permiso `w` del directorio que lo contiene, no del propio fichero.

## Notación octal y simbólica

`chmod` cambia los permisos y admite dos notaciones.
En la octal, cada permiso vale un número (`r` = 4, `w` = 2, `x` = 1) y cada clase se escribe como la suma de los suyos:

| Octal | Permisos | Uso típico |
| --- | --- | --- |
| `644` | `rw-r--r--` | Ficheros de texto |
| `755` | `rwxr-xr-x` | *Scripts* y directorios compartidos |
| `600` | `rw-------` | Ficheros privados |
| `700` | `rwx------` | Directorios privados |

La notación simbólica describe un cambio sobre los permisos actuales: quién (`u`, `g`, `o` o `a` para todos), qué operación (`+` añade, `-` quita, `=` fija) y qué permisos.

```bash
chmod 640 notas.csv          # rw-r----- exactamente
chmod u+x info.sh            # añade ejecución al propietario
chmod go-w datos             # quita escritura a grupo y otros
chmod u=rwx,g=rx,o= info.sh  # equivale a 750
```

## Permisos especiales

Las contraseñas se guardan en `/etc/shadow`, que solo root puede modificar.
¿Cómo puede entonces cualquier usuario cambiar la suya con `passwd`?

```console
$ ls -l /usr/bin/passwd /etc/shadow
-rw-r----- 1 root shadow    500 oct 28 04:16 /etc/shadow
-rwsr-xr-x 1 root root   118168 abr 19  2025 /usr/bin/passwd
```

La `s` en el lugar de la `x` del propietario es uno de los tres **permisos especiales**, que cambian con qué permisos se ejecuta un programa o quién puede borrar en un directorio:

- ***setuid*** (`s` en el propietario).
  El ejecutable se ejecuta con los permisos de su propietario, no con los del usuario que lo lanza.
  Como `passwd` es de root, puede escribir en `/etc/shadow`, y el propio programa se encarga de que cada usuario solo pueda cambiar su contraseña.
  Linux no hace caso de este permiso en los *scripts*, solo en los programas compilados.
- ***setgid*** (`s` en el grupo).
  En un ejecutable, lo mismo que *setuid* pero con el grupo.
  En un directorio, los ficheros que se crean dentro toman el grupo del directorio, no el de quien los crea, así que sirve para directorios compartidos.
- ***sticky*** (`t` en otros).
  En un directorio en el que todos pueden escribir, cada uno solo puede borrar o renombrar sus propios ficheros.
  Es el caso de `/tmp`, que tiene `drwxrwxrwt`.

En octal, se escriben con una cifra más delante de los permisos normales: *setuid* vale 4, *setgid* 2 y *sticky* 1.
En simbólica, son `u+s`, `g+s` y `+t`.

```bash
chmod 4755 programa  # rwsr-xr-x
chmod 2770 comun     # rwxrws---
chmod 1777 tmp       # rwxrwxrwt
```

Si falta la `x` que hay debajo, `ls -l` muestra la letra en mayúscula, como en `rwSr-xr-x`.
Indica que el permiso especial está puesto, pero no sirve de nada porque no se puede ejecutar.

## Cambiar el propietario y el grupo

Qué permisos se nos aplican depende de si somos el propietario del fichero, pertenecemos a su grupo o no.
Ambos datos se pueden cambiar:

- **`chown usuario:grupo fichero`.**
  Cambia el propietario y el grupo.
  Cambiar el propietario está reservado a root.
- **`chgrp grupo fichero`.**
  Cambia solo el grupo.
  El propietario puede hacerlo siempre que pertenezca al grupo de destino.

En el contenedor del curso, `alu` pertenece también al grupo `alumnos`, así que podemos darle ese grupo a `info.sh`.
Con los permisos `rwxr-x---`, tus compañeros del grupo pasan a poder leerlo y ejecutarlo:

```console
$ chgrp alumnos info.sh
$ ls -l info.sh
-rwxr-x--- 1 alu alumnos 512 oct 22 11:10 info.sh
```

## La máscara de permisos

¿Con qué permisos nace un fichero nuevo?
Los programas suelen pedir `666` para ficheros y `777` para directorios al crearlos, y el sistema les quita los bits que indique la máscara.

La **máscara de permisos** (`umask`) es el conjunto de permisos que se retiran a todo fichero o directorio que crea la *shell*.
Con la habitual, `022`, los ficheros nacen con `644` y los directorios con `755`.
Con `umask 077`, nacerían con `600` y `700`.

```console
$ umask
0022
$ umask 027
$ touch nuevo; mkdir nuevodir
$ ls -ld nuevo nuevodir
-rw-r----- 1 alu alu    0 oct 22 11:20 nuevo
drwxr-x--- 2 alu alu 4096 oct 22 11:20 nuevodir
```

La máscara solo afecta a la *shell* actual y a lo que se ejecute desde ella.
Al cerrar la terminal, vuelve a la de siempre.
