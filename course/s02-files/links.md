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
lrwxrwxrwx 1 alu alumnos 20 oct 22 11:02 datos -> /home/alu/ssoo/datos
```

La `l` inicial indica que es un enlace simbólico y la flecha muestra a dónde apunta.
El número de la segunda columna de `ls -l` es el número de enlaces duros del fichero.
