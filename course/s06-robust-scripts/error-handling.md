Por defecto, bash sigue adelante aunque una orden falle.
Un `cd` que falla seguido de un `rm *` puede borrar el directorio equivocado.

Hay dos opciones de bash que conviene activar al principio de todo *script*:

- **`set -e`.**
  El *script* termina en cuanto una orden falla.
  No se aplica a las órdenes que son condición de un `if` o un `while`, ni a las que van antes de `&&` o `||`, porque ahí el fallo es esperado.
- **`set -u`.**
  Usar una variable que no existe es un error, en lugar de valer la cadena vacía.
  Permite, por ejemplo, detectar las erratas en los nombres de variable.

Se pueden escribir juntas: `set -eu`.
Existe también `set -o pipefail`, que hace que una tubería falle si falla cualquiera de sus comandos, no solo el último.
No la usaremos por defecto, porque una tubería que acaba en `head` puede fallar sin que haya ningún error real.

> [!NOTE] `grep -c` y `set -e`
> `grep` termina con estado 1 cuando no encuentra nada, aunque `-c` imprima un 0 perfectamente válido.
> Con `set -e`, `n=$(grep -c 404 "$log")` termina el *script* si no hay ningún 404.
> Por eso `contar_codigo` cuenta con `awk`.
> Otra solución es añadir `|| true` al final de la orden.

Un detalle que sorprende es que con `set -e`, `linea=$(head -n 1 "$fichero")` detiene el *script* si `head` falla.
Pero `local linea=$(head -n 1 "$fichero")` no lo detiene, pues el estado de salida de esa línea es el de `local`, que siempre termina bien.
Lo mismo pasa con `export`.
Si queremos detectar el fallo, debemos declarar la variable en una línea y asignarla en la siguiente:

```bash
local linea                     # Declara la variable
linea=$(head -n 1 "$fichero")   # Si head falla, set -e detiene el script
```

`set -e` no sustituye a las comprobaciones explícitas: un *script* que muere con el mensaje de `cut` o de otro comando no explica qué se hizo mal.
Por eso, después del bucle que procesa las opciones, debemos comprobar todo lo que necesitamos para la ejecución del *script* y avisar con `error_exit`:

```bash
[[ -n $log ]] || error_exit "falta el fichero de log"
[[ -r $log ]] || error_exit "no se puede leer $log" 2
[[ $top =~ ^[0-9]+$ ]] || error_exit "el valor de -n debe ser un número: $top"
[[ ${#codigos[@]} -gt 0 ]] || codigos=(404)
command -v awk > /dev/null || error_exit "no se encuentra awk"
```

`command -v` termina bien si el comando existe, así que sirve para comprobar que tenemos lo que el *script* necesita antes de empezar.
También podemos usar `type -P`, pero la opción `-P` no forma parte del estándar POSIX.
