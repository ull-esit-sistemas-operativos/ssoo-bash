Antes de comenzar a trabajar con las notas hay un problema que resolver.
`notas.csv` escribe los decimales con punto (`7.5`), como casi todos los ficheros de datos, los *logs* y la salida de `ps`.
Pero un equipo configurado en español espera la coma.
¿Qué pasa si calculamos la media de las notas con el comando `awk`, que veremos en el apartado siguiente?

```console
$ awk -F, 'NR > 1 && $3 != "" { s += $3; n++ } END { printf "%.2f\n", s / n }' notas.csv
6,80
```

Pero la media correcta es 7,10.
`awk` ha leído `7.5` como 7 y `4.5` como 4, y ha escrito el resultado con coma porque, como hemos mencionado, espera `,` en lugar de `.` como separador decimal.
Además el comando no ha avisado de ningún problema.

La **configuración regional** (*locale*) es el conjunto de convenciones del idioma y el país del usuario: el separador decimal, el formato de las fechas, el orden alfabético o el idioma de los mensajes.
Se elige con variables de entorno: `LANG` fija todas las convenciones, `LC_NUMERIC`, `LC_TIME` o `LC_COLLATE` cada una por separado, y `LC_ALL` las sobrescribe todas.
El comando `locale` muestra la configuración actual:

```console
$ locale | grep NUMERIC
LC_NUMERIC="es_ES.UTF-8"
```

Los comandos que interpretan números con decimales siguen esta configuración, tanto al leer como al escribir.
Por tanto, si los datos y la configuración no coinciden en la misma convención, el resultado es incorrecto.

Hay dos formas de hacer que coincidan: adaptar los datos o cambiar la configuración del comando.

## Adaptar los datos

Antes de procesar `notas.csv`, lo convertimos a la convención española con `tr`.
El punto decimal pasa a ser una coma y, como la coma ya no puede separar campos, el separador pasa a ser el punto y coma:

```console
$ tr ',.' ';,' < notas.csv > notas_es.csv
$ cat notas_es.csv
alumno;asignatura;nota
ana;SSOO;7,5
ana;FP;6
luis;SSOO;4,5
luis;FP;
marta;SSOO;9
marta;FP;8,5
pablo;SSOO;
```

`tr` cambia cada carácter una sola vez, así que las comas que salen de los puntos no se convierten después en punto y coma.
Desde aquí, en esta lectura trabajaremos con `notas_es.csv`.

Hay que tener en cuenta cuatro cosas:

- **El punto y coma va entre comillas.**
  Para la *shell*, `;` separa órdenes, así que como separador se escribe `-F';'` en `awk` y `-t';'` en `sort`.
- **Supone que el equipo está en español.**
  Compruébalo con `locale`.
  En un equipo con otra configuración el problema sería el contrario: los datos con coma y el comando esperando punto.
  En un equipo configurado en inglés, no haría falta hacer la conversión del archivo.
- **`tr` cambia todos los puntos y comas.**
  No solo los decimales, así que solo sirve si ningún otro campo los contiene, como un nombre con iniciales o un texto con comas.
- **En el programa de `awk`, los números van con punto.**
  Son código, no datos: `$3 >= 7.5` compara con siete y medio aunque los datos de entrada usen coma o los resultados se muestren, igualmente, con coma.

## Cambiar la configuración del comando

La otra forma es dejar los datos como están y cambiar la configuración de los comandos que los leen.
Anteponer `LC_ALL=C` a un comando hace que ese comando, y solo ese, use la configuración neutra `C`, que tiene el punto como separador decimal:

```console
$ LC_ALL=C awk -F, 'NR > 1 && $3 != "" { s += $3; n++ } END { printf "%.2f\n", s / n }' notas.csv
7.10
```

En una tubería hay que ponerlo en todos los comandos que lean o escriban decimales.
Si un eslabón lo lleva y otro no, los datos y la configuración vuelven a no coincidir.
Usaremos esta forma la semana que viene con la salida de `ps`, que siempre escribe los decimales con punto.

> [!NOTE] Distintas versiones, distinto comportamiento
> Un mismo comando puede comportarse de forma diferente según la versión instalada.
> `awk` es un buen ejemplo: en Ubuntu, `awk` es `mawk`, que sigue la configuración regional como hemos descrito.
> Pero en otros sistemas `awk` es `gawk`, el de GNU, que usa siempre el punto decimal, sea cual sea la configuración.
> Con `gawk`, los datos con punto funcionan sin más, y los que hemos convertido a coma con `tr` dan el problema contrario.
> `LC_ALL=C` funciona con los dos.
> Para saber cuál tienes, `awk -W version` muestra `mawk` o `GNU Awk`.
