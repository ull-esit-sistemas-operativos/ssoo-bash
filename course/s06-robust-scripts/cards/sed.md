¿Cómo cambio un texto por otro en todas las líneas de un fichero, o en el propio fichero?
`sed` (de *stream editor*) lee su entrada línea a línea, aplica a cada una las órdenes que le damos y escribe el resultado en la salida estándar.

```text
sed [-n] [-E] [-i[SUFIJO]] 'ORDEN' [fichero...]
```

La orden más usada es `s/patrón/texto/`, que cambia lo que encaje con el patrón, una expresión regular como las de `grep`.
Delante de la orden puede ir una dirección que elige a qué líneas se aplica, como `2,3` o `/ 404 /`.
Sin `-i`, el fichero no cambia: `sed` solo escribe el resultado.

## Ejemplo

Con el `acceso.log` de esta semana:

```console
$ sed 's/ - - / /' acceso.log | head -n 2
192.168.1.10 [21/Oct/2026:10:15:32 +0200] "GET /index.html HTTP/1.1" 200 5120
10.0.0.7 [21/Oct/2026:10:15:40 +0200] "GET /logo.png HTTP/1.1" 404 512
$ sed -n '2,3p' acceso.log
10.0.0.7 - - [21/Oct/2026:10:15:40 +0200] "GET /logo.png HTTP/1.1" 404 512
192.168.1.10 - - [21/Oct/2026:10:16:02 +0200] "GET /tema1.html HTTP/1.1" 200 8340
$ sed '/ 200 /d' acceso.log
10.0.0.7 - - [21/Oct/2026:10:15:40 +0200] "GET /logo.png HTTP/1.1" 404 512
10.0.0.7 - - [21/Oct/2026:10:17:16 +0200] "GET /favicon.ico HTTP/1.1" 404 512
192.168.1.10 - - [21/Oct/2026:10:18:44 +0200] "GET /tema2.html HTTP/1.1" 404 512
```

La primera quita los dos guiones de cada línea, la segunda escribe solo las líneas 2 y 3, y la tercera borra las peticiones con código 200.

## Opciones útiles

| Opción | Qué hace | Ejemplo |
| --- | --- | --- |
| `-n` | No escribe cada línea; solo lo que pida `p` | `sed -n '2,3p' acceso.log` |
| `-E` | Usa expresiones regulares extendidas, las de `grep -E` | `sed -E 's/[0-9]+$/N/' acceso.log` |
| `-i` | Cambia el fichero en vez de escribir el resultado | `sed -i 's/a/b/' copia.log` |
| `-i.bak` | Lo mismo, guardando antes una copia con ese sufijo | `sed -i.bak 's/a/b/' copia.log` |
| `-e ORDEN` | Añade una orden; se puede repetir | `sed -e 's/a/b/' -e '/^$/d'` |

## Combinaciones habituales

```bash
# Sacar la IP y el código de cada petición, con grupos
sed -E 's/^([0-9.]+) .*" ([0-9]{3}) .*/\1 \2/' acceso.log
```

::: details Paso a paso

1. `^([0-9.]+)` encaja con la IP del principio de la línea y la guarda en el grupo 1.
2. ` .*" ` se come todo hasta las últimas comillas, que cierran la petición, y el espacio que las sigue.
3. `([0-9]{3})` encaja con el código y lo guarda en el grupo 2, y ` .*` se come el resto de la línea.
4. Como el patrón encaja con la línea entera, `\1 \2` la sustituye por la IP y el código:

   ```text
   192.168.1.10 200
   10.0.0.7 404
   192.168.1.10 200
   172.16.0.3 200
   10.0.0.7 404
   192.168.1.10 404
   ```

:::

Con campos separados por espacios, `awk '{ print $1, $9 }'` hace lo mismo y se lee mejor.
Los grupos de `sed` sirven cuando lo que buscamos no ocupa siempre el mismo campo.

```bash
# Cambiar un texto en el propio fichero, guardando una copia por si acaso
sed -i.bak 's|HTTP/1.1|HTTP/2|' copia.log
```

```bash
# Quitar los comentarios y las líneas vacías de un fichero de configuración
sed -E '/^[[:space:]]*(#|$)/d' /etc/ssh/sshd_config
```

```bash
# Marcar lo que ha encajado, con &
sed 's/[0-9]*$/(&)/' acceso.log
```

## Tablas de referencia

Órdenes:

| Orden | Qué hace |
| --- | --- |
| `s/patrón/texto/` | Cambia lo primero que encaje en cada línea por el texto |
| `p` | Escribe la línea, normalmente con `-n` |
| `d` | Borra la línea: no se escribe |
| `q` | Termina, después de escribir la línea actual |

Direcciones, delante de la orden:

| Dirección | Líneas a las que se aplica |
| --- | --- |
| (ninguna) | Todas |
| `3` | La línea 3 |
| `2,4` | De la 2 a la 4 |
| `3,$` | De la 3 hasta la última |
| `/patrón/` | Las que encajan con el patrón |

Detrás de `s///`, y dentro del texto de sustitución:

| Elemento | Qué hace |
| --- | --- |
| `g` | Cambia todo lo que encaje en la línea, no solo lo primero |
| `p` | Escribe la línea si ha habido cambio; con `-n`, solo esas |
| `&` | En el texto, lo que ha encajado con el patrón |
| `\1`, `\2`… | En el texto, lo que ha encajado con cada grupo `( )`, con `-E` |

## Errores frecuentes

**Redirigir al mismo fichero.**
`sed 's/a/b/' f > f` deja `f` vacío: la *shell* lo vacía al preparar la redirección, antes de que `sed` empiece a leer (ver la lectura «[Redirecciones](../../s03-pipes/redirections.md)»).
Para cambiar el fichero se usa `-i`.

**`-i` no se puede deshacer.**
Sin sufijo, el fichero original desaparece.
Mientras probamos la orden, mejor sin `-i`, mirando la salida, o con `-i.bak`.

**Barras en el patrón.**
Una `/` dentro del patrón o del texto termina la orden antes de tiempo:

```console
$ sed 's/HTTP/1.1/HTTP/2/' acceso.log
sed: -e expression #1, char 12: unknown option to `s'
```

`s` admite otro separador, el carácter que vaya justo detrás: `s|HTTP/1.1|HTTP/2|`.

**El punto encaja con cualquier carácter.**
`echo 'a.b.c' | sed 's/./-/g'` escribe `-----`.
Para un punto literal, `\.`.

**`+`, `?`, `|` y los grupos necesitan `-E`.**
Sin `-E`, `sed` usa las expresiones regulares básicas, en las que `+` y `( )` son caracteres normales: `echo aaa | sed 's/a+/X/'` escribe `aaa`.

**Variables entre comillas dobles.**
Para usar una variable, la orden va entre comillas dobles, como en `sed "s/$viejo/$nuevo/"`.
Si el valor contiene `/`, `&` o un punto, `sed` los interpreta: hay que elegir un separador que no aparezca o, si es un texto fijo, usar `${v//viejo/nuevo}` (ver la lectura «[Recortar y transformar el valor de una variable](../../s04-expansions-loops/parameter-expansion.md)»).

**`-i` en macOS.**
El `sed` de macOS y de los BSD exige un sufijo tras `-i`, aunque sea vacío: `sed -i '' 's/a/b/' f`.

## Ver también

`man sed` · `info sed` (el manual completo de GNU) · lectura «[Expresiones regulares](../../s04-expansions-loops/regular-expressions.md)» · [ficha de `tr`](../../s03-pipes/cards/tr.md) · [ficha de `awk`](../../s04-expansions-loops/cards/awk.md)
