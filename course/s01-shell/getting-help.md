Nadie recuerda todas las opciones de todos los comandos, ni hace falta.
Lo que sí conviene es saber dónde mirar:

- **`man comando`.**
  Abre la página de manual.
  Se recorre con las mismas teclas que `less`, así que `/` sirve para buscar una opción.
  Las secciones más útiles son NAME, SYNOPSIS y DESCRIPTION.
- **`comando --help`.**
  Casi todos los comandos externos imprimen un resumen de sus opciones.
  Es más rápido que `man` cuando solo dudamos de la letra de una opción.
- **`type comando`.**
  Dice qué tipo de cosa es un nombre: un alias, una función, un comando interno de la *shell* o un programa en disco.
- **`help comando`.**
  Muestra la ayuda de los comandos internos de la *shell*, que muchas veces no tienen página de manual propia.

```console
$ type cd
cd es una orden interna del shell
$ type ls
ls es un alias de «ls --color=auto»
$ help cd
```

Los mensajes exactos dependen del idioma configurado y de la distribución.
Lo importante es la idea: `cd` no es un programa aparte, sino parte de la propia *shell*, y por eso su ayuda está en `help` y no en `man`.

Para entender una línea de órdenes que encontramos escrita, [explainshell](https://explainshell.com) separa cada parte y muestra el fragmento de la página de manual que la explica.
