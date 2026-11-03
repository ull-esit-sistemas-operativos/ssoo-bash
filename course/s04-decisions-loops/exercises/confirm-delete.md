`borrar.sh` recibe uno o varios ficheros y pregunta por cada uno si se borra.

## Qué tiene que hacer

- Por cada fichero pregunta `¿Borrar FICHERO? [s/n] ` y lee la respuesta.
- Con `s`, `S`, `si` o `sí` lo borra y muestra `Borrado: FICHERO`.
- Con `n`, `N` o `no` lo conserva y muestra `Conservado: FICHERO`.
- Con cualquier otra respuesta lo conserva y avisa por el error estándar: `Respuesta no válida: RESPUESTA. Se conserva FICHERO`.
- Si no hay respuesta en 10 segundos, o la entrada se acaba, lo conserva y avisa por el error estándar: `Sin respuesta. Se conserva FICHERO`.
- Funciona con nombres que tienen espacios, como `b c.txt`.

```console
$ bash borrar.sh a.txt "b c.txt"
¿Borrar a.txt? [s/n] n
Conservado: a.txt
¿Borrar b c.txt? [s/n] s
Borrado: b c.txt
```

## Errores

Los mensajes de error van al error estándar:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe ningún argumento | `Uso: borrar.sh <fichero>...` | 1 |
| Algún argumento no es un fichero | `Error: FICHERO no es un fichero`, sin preguntar, y sigue con los demás | 2, al terminar |

::: details Pista

`read -p` muestra la pregunta y lee la respuesta, y con `-t` termina con error si se agota el tiempo; lo mismo hace si se acaba la entrada.
Las pruebas le dan las respuestas por la entrada estándar, así que la pregunta no aparece en lo que comprueban.
Un `case` con `s|S|si|sí)` reconoce todas las formas del sí.

:::
