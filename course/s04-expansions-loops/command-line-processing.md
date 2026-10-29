¿Por qué `echo $x` a veces pierde espacios, o muestra nombres de ficheros que no hemos escrito?
Porque la orden que se ejecuta no es exactamente la que tecleamos: bash la transforma antes.

Una **expansión** es cada una de las transformaciones que bash aplica a una línea después de separarla en palabras y antes de ejecutarla.
Se aplican siempre en este orden:

1. **Llaves.**
   `{a,b}` y `{1..5}` generan varias palabras: `foto{1..3}.jpg` da `foto1.jpg foto2.jpg foto3.jpg`.
   Los rangos admiten ceros a la izquierda y un paso: `{01..03}` da `01 02 03` y `{0..20..5}` da `0 5 10 15 20`.
2. **Tilde.**
   `~` se sustituye por el directorio personal.
3. **Parámetros, aritmética y sustitución de comandos.**
   `$var`, `${var}`, `$(( ))` y `$( )` se sustituyen por su valor, de izquierda a derecha.
4. **División en palabras.**
   El resultado de las expansiones del paso 3 que no estaban entre comillas se parte por los espacios, tabuladores y saltos de línea.
5. **Nombres de fichero.**
   Las palabras con comodines se sustituyen por los ficheros que encajan.
6. **Eliminación de comillas.**
   Las comillas que quedan desaparecen; solo servían para proteger.

Conocer el orden explica comportamientos que parecen caprichosos.
Como las llaves van antes que las variables, `{1..$n}` no funciona:

```console
$ n=3
$ echo {1..$n}
{1..3}
```

Y como los comodines van después de las variables, una variable sin comillas cuyo valor contiene `*` acaba expandida como un patrón.

Por ejemplo, en un directorio con `a.txt` y `b.txt`:

```console
$ operacion="2 * 3"
$ echo $operacion
2 a.txt b.txt 3
$ echo "$operacion"
2 * 3
```

Sin comillas, el valor se parte en `2`, `*` y `3`, y el `*` se expande a los ficheros del directorio.
Con comillas dobles llega intacto, como veremos en el apartado siguiente.
