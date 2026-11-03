En la [ficha de `sort`](../s03-pipes/cards/sort.md) vimos que, en un equipo en español, `sort -n` lee mal los decimales con punto.
Antes de trabajar con las notas conviene ver por qué pasa y cómo evitarlo.
`notas.csv` escribe los decimales con punto (`7.5`), como casi todos los ficheros de datos, los *logs* y la salida de `ps`.
Pero un equipo configurado en español espera la coma.
¿Qué pasa si ordenamos las notas de mayor a menor con `sort -n`?

```console
$ tail -n +2 notas.csv | sort -t, -k3,3nr
marta,FP,8.5
ana,SSOO,7.5
luis,SSOO,4.5
marta,SSOO,9
ana,FP,6
luis,FP,
pablo,SSOO,
```

El 9 de marta sale detrás de 4.5.
`sort` ha tomado el punto como separador de miles, como en `1.000`, así que ha leído `8.5` como 85 y `4.5` como 45.
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
Ahora `sort` lee bien las notas:

```console
$ tail -n +2 notas_es.csv | sort -t';' -k3,3nr | head -n 3
marta;SSOO;9
marta;FP;8,5
ana;SSOO;7,5
```

Hay que tener en cuenta tres cosas:

- **El punto y coma va entre comillas.**
  Para la *shell*, `;` separa órdenes, así que como separador se escribe `-t';'` en `sort`.
- **Supone que el equipo está en español.**
  Compruébalo con `locale`.
  En un equipo con otra configuración el problema sería el contrario: los datos con coma y el comando esperando punto.
  En un equipo configurado en inglés, no haría falta hacer la conversión del archivo.
- **`tr` cambia todos los puntos y comas.**
  No solo los decimales, así que solo sirve si ningún otro campo los contiene, como un nombre con iniciales o un texto con comas.

## Cambiar la configuración del comando

La otra forma es dejar los datos como están y cambiar la configuración de los comandos que los leen.
Anteponer `LC_ALL=C` a un comando hace que ese comando, y solo ese, use la configuración neutra `C`, que tiene el punto como separador decimal:

```console
$ tail -n +2 notas.csv | LC_ALL=C sort -t, -k3,3nr | head -n 3
marta,SSOO,9
marta,FP,8.5
ana,SSOO,7.5
```

En una tubería hay que ponerlo en todos los comandos que lean o escriban decimales.
Si un eslabón lo lleva y otro no, los datos y la configuración vuelven a no coincidir.

`awk`, que veremos a continuación, trata los decimales de otra forma.
