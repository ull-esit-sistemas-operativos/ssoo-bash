Hasta ahora nuestros *scripts* ejecutaban siempre las mismas órdenes.
Pero ¿qué debe hacer `resumen_log.sh` si el fichero no existe, o si está vacío?

La estructura **`if`** ejecuta una orden y, según su estado de salida, elige qué bloque ejecutar: el de `then` si fue 0 y el de `else` en otro caso.
La condición es una orden cualquiera:

```bash
if grep -q ' 404 ' "$log"; then
    echo "Hay errores 404"
else
    echo "No hay errores 404"
fi
```

Para encadenar varias condiciones se usa `elif`, que funciona como un `else` seguido de otro `if`.

## El comando \[\[ \]\]

La mayoría de las veces, la condición que queremos comprobar no es un comando sino una comparación.
Para eso bash tiene `[[ ]]`, que evalúa una expresión y devuelve 0 si es cierta y 1 si no lo es:

| Tipo | Expresión | Es cierta si… |
| --- | --- | --- |
| Cadenas | `$a == $b`, `$a != $b` | son iguales o distintas |
| Cadenas | `-z $a`, `-n $a` | `$a` está vacía o no lo está |
| Números | `$a -eq $b`, `-ne`, `-lt`, `-le`, `-gt`, `-ge` | igual, distinto, menor, menor o igual, mayor, mayor o igual |
| Ficheros | `-e $f`, `-f $f`, `-d $f` | existe, es un fichero normal, es un directorio |
| Ficheros | `-r $f`, `-w $f`, `-x $f` | se puede leer, escribir, ejecutar |
| Lógica | `! expr`, `expr && expr`, `expr \|\| expr` | negación, y, o |

Los espacios después de `[[` y antes de `]]` son obligatorios.
Dentro de `[[ ]]` las variables no se parten por los espacios, así que no hacen falta comillas en `[[ -r $log ]]`; pero ponerlas tampoco hace daño.

Hay que distinguir bien la comparación de textos de la de números.
`==` y `!=` comparan cadenas: `[[ 5 == 05 ]]` es falso, porque son textos distintos.
Para números se usan `-eq`, `-ne`, `-lt`, `-le`, `-gt` y `-ge`.
Por ejemplo, `[[ 5 -eq 05 ]]` es cierto.

La trampa más habitual está en `<` y `>`: dentro de `[[ ]]` también comparan cadenas, por orden alfabético.
Por eso `[[ 10 < 9 ]]` es cierto, ya que el carácter `1` va antes que el `9`, pero `[[ 10 -lt 9 ]]` es falso, tal y como esperamos.
Para comparar números con los símbolos `<` y `>`, bash tiene la forma aritmética `(( ))`, que veremos al final del apartado «Aritmética entera».

> [!NOTE] La forma antigua: `[ ]`
> En muchos *scripts* y en finales de otros años verás condiciones como `[ -r "$log" ]`.
> `[` es otro nombre del comando `test` de POSIX, más antiguo que `[[ ]]`, y funciona casi igual.
> Pero exige poner siempre las variables entre comillas y no admite `&&` ni `||` dentro.
> En el curso usaremos siempre `[[ ]]`.

## && y ||

Para decisiones de una línea, `&&` ejecuta la segunda orden solo si la primera terminó bien, y `||` solo si falló:

```bash
[[ -r $log ]] || echo "No puedo leer $log" >&2
mkdir -p informes && echo "Directorio listo"
```

Sirven para casos sencillos.
Cuando hay que hacer más de una acción, un `if` es más claro.

## Aritmética entera

Todo en bash es texto: `1+1` es una cadena de tres caracteres.
Para calcular hay que pedirlo explícitamente con **`$(( ))`**, que evalúa una expresión entera y se sustituye por su resultado.
Dentro, las variables no necesitan `$`:

```bash
total=6
errores=3
porcentaje=$(( errores * 100 / total ))
echo "$porcentaje%"                        # 50%
echo "$(( 7 / 2 )) y resto $(( 7 % 2 ))"  # 3 y resto 1
```

La división es entera y trunca los decimales.
Por eso se multiplica por 100 antes de dividir: `errores / total * 100` daría 0.
Para trabajar con decimales usaremos `awk` en la semana 4.

Como `$(( ))` se sustituye por su resultado, puede ir en cualquier sitio donde iría un texto.
Puede ir dentro de un `echo`, como en la última línea del ejemplo, o a la derecha de una asignación para guardar el resultado en una variable.
Por ejemplo, `porcentaje=$(( errores * 100 / total ))` deja en `porcentaje` el texto `50`, que después usamos como cualquier otra variable.

Para las comparaciones existe también la forma `(( ))`, sin el `$` delante.
No se sustituye por ningún resultado, sino que evalúa la expresión y devuelve 0 si es cierta.
Es la manera más natural de comparar números con `<`, `>`, `<=`, `>=`, `==` y `!=`, y dentro las variables tampoco necesitan `$`:

```bash
if (( errores > 0 )); then
    echo "Hay $errores errores"
fi
```
