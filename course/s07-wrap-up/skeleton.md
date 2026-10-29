Es la estructura de `resumen_log.sh` de la semana 6, sin la parte específica.
Conviene tenerlo en los apuntes y saber escribirlo de memoria:

```bash
#!/bin/bash
# nombre.sh: qué hace, en una línea
set -eu

# Configuración
valor=${VARIABLE_ENTORNO:-defecto}
lista=()
fichero=

# Funciones
error_exit() {
    echo "$(basename "$0"): $1" >&2
    exit 1
}

uso() {
    cat << EOF
Uso: $(basename "$0") [-o VALOR] [-l ELEMENTO...] [-h] FICHERO
EOF
}

# Opciones
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) uso; exit 0 ;;
        -o)
            [[ $# -ge 2 ]] || error_exit "a -o le falta el valor"
            valor=$2
            shift 2
            ;;
        -l)
            shift
            while [[ $# -gt 0 && $1 != -* ]]; do
                lista+=("$1")
                shift
            done
            ;;
        -*) error_exit "opción desconocida: $1" ;;
        *)
            [[ -z $fichero ]] || error_exit "sobra el argumento: $1"
            fichero=$1
            shift
            ;;
    esac
done

# Comprobaciones
[[ -n $fichero ]] || error_exit "falta el fichero"
[[ -r $fichero ]] || error_exit "no se puede leer $fichero"

# Lógica
```

Aquí la lista de `-l` termina en el siguiente argumento que empieza por guion.
Si los elementos tienen una forma reconocible, como los códigos numéricos de `resumen_log.sh`, es mejor comprobar esa forma con `=~`.
Si el *script* no necesita un fichero, se quitan las líneas de `fichero`.
