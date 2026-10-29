En `resumen_log.sh` escribimos varias veces el mismo código: un `echo` al error estándar seguido de un `exit`.
El problema es que cada copia es una ocasión de equivocarse.

Una **función** es un bloque de órdenes con nombre, que se invoca como si fuera un comando más.
Se define con `nombre() { … }` antes de usarla:

```bash
error_exit() {
    echo "$(basename "$0"): $1" >&2
    echo "Prueba «$(basename "$0") -h» para ver la ayuda." >&2
    exit 1
}

[[ -r $log ]] || error_exit "no se puede leer $log"
```

Dentro de una función, `$1`, `$2` y `$#` son los argumentos de la función, no los del *script*.
`$0` sigue siendo el nombre del *script*, y `exit` termina el *script* entero.

Por eso, si una función necesita los argumentos del *script*, hay que pasárselos al llamarla.
Con `procesar "$@"`, la función recibe todos, tal y como llegaron al *script*, preservando los espacios.

Una función no devuelve valores como en otros lenguajes.
`return N` fija su estado de salida, que sirve para usarla en un `if`.
Para producir un dato, la función lo escribe en la salida estándar y quien la llama lo captura con `$( )`:

```bash
contar_codigo() {
    local codigo=$1
    awk -v c="$codigo" '$9 == c { n++ } END { print n + 0 }' "$log"
}

echo "Respuestas 404: $(contar_codigo 404)"
```

Sin `local`, las variables de una función son globales.
Es decir, `codigo` existiría después en el resto del *script* y podría pisar otra con el mismo nombre.
Con `local`, solo existe durante la llamada.
La opción `-v` de `awk` crea una variable de `awk` con el valor de una de bash.
Es la forma segura de pasarle datos, en lugar de meterlos dentro del programa entre comillas.
El `n + 0` hace que imprima 0, y no una línea vacía, cuando no hay ninguna coincidencia.
