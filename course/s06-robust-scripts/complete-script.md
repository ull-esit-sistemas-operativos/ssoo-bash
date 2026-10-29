Con todas las piezas, `resumen_log.sh` queda así.
El orden de las secciones es el que usaremos en todos los *scripts* a partir de ahora: configuración, funciones, opciones, comprobaciones y lógica.

```bash
#!/bin/bash
# resumen_log.sh: resume un log de acceso web
set -eu

# Configuración
top=${RESUMEN_TOP:-10}
codigos=()
log=

# Funciones
error_exit() {
    echo "$(basename "$0"): $1" >&2
    echo "Prueba «$(basename "$0") -h» para ver la ayuda." >&2
    exit 1
}

uso() {
    cat << EOF
Uso: $(basename "$0") [-n N] [-c CÓDIGO...] [-h] LOG

Resume un log de acceso web: las N IP con más peticiones
y el número de respuestas con cada código indicado.

Opciones:
  -n N          número de IP que se muestran (por defecto, $top)
  -c CÓDIGO...  códigos de respuesta que se cuentan (por defecto, 404)
  -h, --help    muestra esta ayuda
EOF
}

contar_codigo() {
    local codigo=$1
    awk -v c="$codigo" '$2 == c { n++ } END { print n + 0 }' "$tmp"
}

# Opciones
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

# Comprobaciones
[[ -n $log ]] || error_exit "falta el fichero de log"
[[ -r $log ]] || error_exit "no se puede leer $log"
[[ $top =~ ^[0-9]+$ ]] || error_exit "el valor de -n debe ser un número: $top"
[[ ${#codigos[@]} -gt 0 ]] || codigos=(404)

# Trabajo
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
trap 'exit 1' INT TERM

cut -d' ' -f1,9 "$log" > "$tmp"

echo "Las $top IP con más peticiones:"
cut -d' ' -f1 "$tmp" | sort | uniq -c | sort -nr | head -n "$top"
for codigo in "${codigos[@]}"; do
    echo "Respuestas $codigo: $(contar_codigo "$codigo")"
done
```

Al extraer los campos 1 y 9 con `cut`, el archivo temporal guarda la IP en su campo 1 y el código en su campo 2.
Por eso `contar_codigo` compara ahora `$2`.

**Resultado** con el *log* de la semana 3:

```console
$ ./resumen_log.sh -c 200 404 -n 2 acceso.log
Las 2 IP con más peticiones:
      3 192.168.1.10
      2 10.0.0.7
Respuestas 200: 3
Respuestas 404: 3
$ ./resumen_log.sh -n diez acceso.log
resumen_log.sh: el valor de -n debe ser un número: diez
Prueba «resumen_log.sh -h» para ver la ayuda.
$ echo $?
1
```
