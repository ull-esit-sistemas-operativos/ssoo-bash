A veces un resultado intermedio se usa varias veces.
Para `resumen_log.sh`, podemos extraer una sola vez los dos campos que nos interesan (IP y código) y trabajar después sobre ese fichero, mucho más pequeño que el *log*.
¿Dónde lo guardamos, y quién lo borra?

`mktemp` crea un fichero vacío con un nombre único en `/tmp` e imprime su ruta.
Nunca se debe inventar un nombre fijo como `/tmp/datos.txt`, porque dos ejecuciones a la vez se pisarían.

Para borrarlo pase lo que pase, usamos **`trap`**, que registra órdenes para que se ejecuten cuando el *script* recibe una señal o termina.
La señal especial `EXIT` corresponde a la salida del *script*, por cualquier motivo:

```bash
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
trap 'exit 1' INT TERM
```

La segunda línea borra el temporal al salir, también cuando `error_exit` llama a `exit`.
La tercera convierte un [[Ctrl]]+[[C]] o un `kill` en una salida normal, de forma que también pasa por `EXIT`.

`EXIT` no es una señal del sistema, sino una pseudoseñal de bash.
De las señales de la semana 5, las que tiene sentido capturar son las que piden terminar, como `INT` y `TERM`.
`KILL` no se puede capturar.
Por lo que enviar `kill -KILL` al *script* lo termina sin pasar por el `trap`, haciendo que el fichero temporal se quede en `/tmp`.

Algunos comandos aplican esta técnica por nosotros.
Por ejemplo, `sed -i`, que cambia un fichero en su sitio, escribe el resultado en un temporal del mismo directorio y, al terminar, le da el nombre del original (ver la [ficha de `sed`](cards/sed.md)).
