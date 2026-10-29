Las comillas sirven para decidir qué expansiones queremos y cuáles no.
Hay tres mecanismos:

- **Barra invertida.**
  `\` protege el carácter siguiente: `echo \*` imprime un asterisco.
- **Comillas simples.**
  Todo lo que encierran es literal.
  No hay forma de incluir una comilla simple dentro.
- **Comillas dobles.**
  Todo es literal salvo `$`, `` ` `` y `\`.
  Por tanto, dentro de comillas dobles se expanden las variables `$var`, la aritmética `$(( ))` y la sustitución de comandos `$( )`, pero no hay división en palabras ni expansión de nombres de fichero.

| Escrito | `$var` | `$(comando)` | `*` | Se parte por espacios |
| --- | --- | --- | --- | --- |
| Sin comillas | sí | sí | sí | sí |
| `"…"` | sí | sí | no | no |
| `'…'` | no | no | no | no |

Veamos el efecto con una variable que contiene espacios y un asterisco, en un directorio con `a.txt` y `b.txt`:

```console
$ x="hola   *"
$ echo $x
hola a.txt b.txt
$ echo "$x"
hola   *
$ echo '$x'
$x
```

Sin comillas, `$x` se parte en `hola` y `*`, se pierden los espacios repetidos y el asterisco se expande.
De ahí la regla práctica del curso: pon comillas dobles alrededor de cada expansión, salvo que quieras expresamente que se parta en palabras.

Los trozos entrecomillados se pueden encadenar sin espacios, y bash los une en una sola palabra: `echo 'Precio: '"$precio"' €'`.

Además hay una cuarta forma, `$'...'`.
Funciona como las comillas simples, pero interpreta las secuencias de escape con barra invertida: `\t` es un tabulador, `\n` un salto de línea y `\\` una barra.
Sirve para escribir en una orden caracteres que no se pueden teclear, como el tabulador que separa los campos de muchos ficheros:

```bash
sort -t$'\t' -k2,2 datos.tsv   # ordena por el segundo campo, separado por tabuladores
sep=$'\t'                      # una variable que contiene un tabulador
```

Para imprimir texto con saltos de línea o tabuladores no hace falta: `printf`, que veremos más adelante en esta semana, ya interpreta `\n` y `\t`.
