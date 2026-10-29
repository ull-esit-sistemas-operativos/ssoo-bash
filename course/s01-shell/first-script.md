Cada vez que queremos saber qué hay en un directorio escribimos las mismas órdenes.
¿No sería más cómodo escribirlas una vez y repetirlas con un solo nombre?

Un ***script*** es un fichero de texto con órdenes que la *shell* ejecuta una tras otra, como si las escribiéramos nosotros.
Durante la sesión construiremos `info.sh`, que recibe un directorio y muestra su ruta absoluta, cuántas entradas tiene y las 5 más recientes.
Llegar a ejecutarlo lleva tres pasos.

1. **Escribir el fichero.**
   Con cualquier editor de texto (nano, VS Code) creamos `info.sh` con este contenido:

   ```bash
   #!/bin/bash
   # info.sh: muestra un resumen de un directorio
   echo "Ruta:"
   realpath "$1"
   ```

   La primera línea es el ***shebang***: los caracteres `#!` seguidos de la ruta del intérprete que debe ejecutar el fichero.
   Sin ella, el sistema no sabe si el fichero es de bash, de Python o de otra cosa.
   El resto de líneas que empiezan por `#` son comentarios.
2. **Darle permiso de ejecución.**
   Un fichero recién creado no se puede ejecutar.
   La orden `chmod +x info.sh` le añade ese permiso.
   Si después ejecutamos `ls -l`, veremos aparecer una `x` en los permisos.
3. **Ejecutarlo.**
   Escribimos su ruta seguida del directorio que queremos resumir:

   ```console
   alu@ull:~/ssoo/practicas$ ./info.sh /etc
   Ruta:
   /etc
   ```

> [!NOTE] Otro *shebang*: `#!/usr/bin/env bash`
> En otros *scripts* verás esta forma, que busca bash en los directorios del PATH en lugar de en una ruta fija.
> Es más portable entre sistemas, porque bash no siempre está en `/bin`, pero en este curso usaremos `#!/bin/bash`.

## Por qué hay que escribir ./

Si probamos a escribir solo `info.sh`, bash responde que el comando no existe.
¿Cómo encuentra entonces `ls`, que tampoco escribimos con su ruta?

La variable **PATH** contiene la lista de directorios, separados por dos puntos, en los que la *shell* busca los comandos que escribimos sin ruta:

```console
$ echo $PATH
/usr/local/bin:/usr/bin:/bin
```

El contenido exacto varía de una máquina a otra, pero el directorio de trabajo no está incluido.
Es una medida de seguridad: si lo estuviera, alguien podría dejar en un directorio compartido un programa malicioso llamado `ls` y lo ejecutaríamos sin darnos cuenta.
Por eso, para ejecutar un *script* que está en el directorio actual, le damos una ruta; en este caso, relativa: `./info.sh`.

## Argumentos

Lo que escribimos detrás del nombre del *script* llega dentro de él como **parámetros posicionales**: `$1` es el primer argumento, `$2` el segundo, y así sucesivamente.
`$0` contiene el nombre con el que se invocó el *script*.

Escribimos `"$1"` entre comillas dobles para que un directorio con espacios en el nombre llegue entero al comando `realpath`.
Lo explicaremos con detalle en las próximas semanas.
De momento, la regla es poner comillas dobles alrededor de cada `$`.

Completemos el *script* con las otras dos partes del resumen:

```bash
#!/bin/bash
# info.sh: muestra un resumen de un directorio
echo "Ruta:"
realpath "$1"
echo "Número de entradas:"
ls -A "$1" | wc -l
echo "Las 5 más recientes:"
ls -t "$1" | head -n 5
```

La opción `-A` funciona como `-a`, pero sin incluir `.` ni `..`, que no son entradas reales.
El carácter `|` envía la salida de `ls` a otro comando: `wc -l` cuenta sus líneas y `head -n 5` recorta y se queda con las 5 primeras.
Cuando la salida de `ls` no va a la pantalla de la terminal, imprime un nombre por línea, y eso es lo que hace que la cuenta funcione.
Estas combinaciones, las tuberías, son el tema de la semana 3.

**Resultado** con un directorio que contiene tres ficheros, de los que `info.sh` es el último modificado:

```console
alu@ull:~/ssoo/practicas$ ./info.sh ~/ssoo/practicas
Ruta:
/home/alu/ssoo/practicas
Número de entradas:
3
Las 5 más recientes:
info.sh
borrador.txt
notas.txt
```
