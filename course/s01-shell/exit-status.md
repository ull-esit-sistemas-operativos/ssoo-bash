¿Qué pasa si le damos a `info.sh` un directorio que no existe?
`realpath` y `ls` imprimen un error, pero el *script* sigue adelante y muestra «0» entradas.
Para reaccionar ante un fallo, primero tenemos que poder detectarlo.

El **estado de salida** es un número entre 0 y 255 que toda orden devuelve al terminar: 0 significa que todo fue bien y cualquier otro valor indica un fallo.
La variable `$?` guarda el estado de la última orden ejecutada:

```console
$ ls /noexiste
ls: no se puede acceder a '/noexiste': No existe el fichero o el directorio
$ echo $?
2
$ echo $?
0
```

El segundo `echo $?` imprime 0 porque ahora `$?` contiene el estado del `echo` anterior, que funcionó.
Si queremos usar un estado, hay que consultarlo justo después de la orden que nos interesa.

Un *script* también tiene estado de salida: el de la última orden que ejecutó.
La semana que viene aprenderemos a comprobar los argumentos al principio de `info.sh` y a terminar con un estado de error propio cuando falten.
