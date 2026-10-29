Con `$1` y `$2` fijos, el usuario tendría que recordar en qué posición va cada cosa.
¿Cómo aceptamos `-n 5 acceso.log` y también `acceso.log -n 5`?

La idea es recorrer los argumentos de izquierda a derecha con un bucle, decidir con `case` qué es cada uno y descartarlo cuando ya lo hemos tratado.
**`shift`** elimina el primer argumento y desplaza los demás: lo que era `$2` pasa a ser `$1` y `$#` disminuye.
`shift 2` elimina dos.

Cada tipo de argumento se trata de forma distinta:

- **Opción sin valor** (`-h`).
  Se actúa y se hace `shift`.
- **Opción con valor** (`-n 5`).
  Se comprueba que el valor existe o es válido, se guarda `$2` y se hace `shift 2`.
- **Opción con lista** (`-c 200 404`).
  Se hace `shift` y después se toman argumentos mientras parezcan elementos de la lista.
  En nuestro caso, mientras sean números.
- **Argumento normal** (`acceso.log`).
  Se guarda y se hace `shift`.
- **Opción desconocida.**
  Cualquier otra cosa que empiece por guion es un error.

## Arrays

Los códigos de `-c` son una lista de longitud variable.
En una sola variable de texto tendríamos que separarlos con espacios y volver a partirlos después, con los problemas que ya conocemos.

Un **array** de bash es una variable que guarda una lista de valores.
Estas son las operaciones que necesitaremos:

| Operación | Qué hace | Resultado con `codigos=(200 404)` |
| --- | --- | --- |
| `codigos=()` | Crea un *array* vacío | — |
| `codigos=(200 404)` | Crea un *array* con esos elementos | — |
| `codigos+=("$1")` | Añade un elemento al final | con `$1` igual a 500, `200 404 500` |
| `"${codigos[@]}"` | Se expande a todos los elementos, cada uno como una palabra, preservando los espacios | `200` `404` |
| `${#codigos[@]}` | Número de elementos | `2` |
| `${codigos[0]}` | Un elemento concreto. Los índices empiezan en 0 | `200` |

## El bucle de opciones

```bash
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            uso
            exit 0
            ;;
        -n)
            [[ $# -ge 2 ]] || error_exit "a -n le falta el valor"
            top=$2
            shift 2
            ;;
        -c)
            shift
            [[ $# -gt 0 && $1 =~ ^[0-9]+$ ]] || error_exit "a -c le falta al menos un código"
            while [[ $# -gt 0 && $1 =~ ^[0-9]+$ ]]; do
                codigos+=("$1")
                shift
            done
            ;;
        -*)
            error_exit "opción desconocida: $1"
            ;;
        *)
            [[ -z $log ]] || error_exit "sobra el argumento: $1"
            log=$1
            shift
            ;;
    esac
done
```

Dentro de `[[ ]]`, `==` no solo compara textos fijos: si el lado derecho va sin comillas, es un patrón de comodines, con la misma sintaxis que en `case`.
Así, `[[ $log == *.log ]]` es cierto si `$log` termina en `.log`.
Si el patrón va entre comillas, `[[ $log == "*.log" ]]`, se compara literalmente y solo es cierto si `$log` vale exactamente `*.log`.

Cuando un comodín no basta, como aquí, donde necesitamos «uno o más dígitos», se usa el operador `=~` de `[[ ]]`.
Comprueba si el texto encaja con una expresión regular extendida, como las que usa `grep`, y el patrón va sin comillas.

La lista de `-c` termina en el primer argumento que no es un número, así que `-c 200 404 acceso.log` funciona: `acceso.log` no se confunde con un código.
