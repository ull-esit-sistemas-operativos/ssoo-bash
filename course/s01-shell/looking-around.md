Sin argumentos, `ls` lista el directorio de trabajo; con argumentos, lista los ficheros o directorios que le indiquemos.
Sus opciones más útiles son estas:

| Opción | Qué hace |
| --- | --- |
| `-l` | Formato largo: permisos, propietario, tamaño, fecha y nombre |
| `-a` | Incluye los ficheros ocultos, cuyo nombre empieza por `.` |
| `-h` | Con `-l`, tamaños legibles (`4,0K`, `1,2M`) en lugar de bytes |
| `-t` | Ordena por fecha de modificación, el más reciente primero |
| `-R` | Entra recursivamente en los subdirectorios |

Cada línea del formato largo tiene siete columnas:

```text
-rw-r--r-- 1 alu alu 2048 oct 22 10:15 notas.csv
```

Son el tipo y los permisos (`-rw-r--r--`, que veremos la semana que viene), el número de enlaces, el propietario, el grupo, el tamaño en bytes, la fecha de última modificación y el nombre.

Para ver el contenido de un fichero de texto tenemos dos comandos.
`cat` vuelca el contenido entero en la terminal, lo que es útil con ficheros cortos.
`less` lo muestra por páginas: avanzamos con la barra espaciadora, retrocedemos con `b`, buscamos con `/texto` (y `n` para la siguiente coincidencia) y salimos con `q`.

Por último, `echo` imprime sus argumentos separados por un espacio.
Esto parece poca cosa, pero será la forma más sencilla de mostrar mensajes desde un *script*:

```console
$ echo Hola, $USER
Hola, alu
```
