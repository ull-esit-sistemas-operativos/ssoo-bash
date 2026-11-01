A veces queremos que un mismo fichero esté accesible desde dos sitios sin duplicar su contenido.
Para eso existen los enlaces, que se crean con `ln`.

- **Enlace duro.**
  Un segundo nombre para el mismo fichero.
  Los dos nombres son iguales a todos los efectos: el contenido solo desaparece cuando se borra el último.
  Se crea con `ln original nombre`.
  No puede apuntar a un directorio ni a un fichero en otro sistema de ficheros.
- **Enlace simbólico.**
  Un fichero pequeño que contiene la ruta de otro.
  Se crea con `ln -s original nombre`.
  Puede apuntar a directorios y a otros sistemas de ficheros, pero si se borra el original se queda roto.

```console
$ ln -s /home/alu/ssoo/datos datos
$ ls -l datos
lrwxrwxrwx 1 alu alu 20 oct 22 11:02 datos -> /home/alu/ssoo/datos
```

La `l` inicial indica que es un enlace simbólico y la flecha muestra a dónde apunta.
El número de la segunda columna de `ls -l` es el número de enlaces duros del fichero.

`readlink` escribe la ruta que guarda un enlace simbólico, y `readlink -f`, la ruta absoluta del fichero al que lleva, como `realpath`:

```console
$ readlink datos
/home/alu/ssoo/datos
```

`ln -s` guarda la ruta tal cual, sin comprobar que exista.
Si es relativa, se sigue desde el directorio donde está el enlace, no desde donde estábamos al crearlo.
Por eso `ln -s notas.csv proyecto/notas` crea un enlace roto: lleva a `proyecto/notas.csv`.
Desde `proyecto`, el fichero es `../notas.csv`, y esa es la ruta que tiene que guardar el enlace: `ln -s ../notas.csv proyecto/notas`.
