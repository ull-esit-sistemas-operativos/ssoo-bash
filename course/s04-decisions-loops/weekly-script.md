En la semana 2, `ordenar.sh` repartía los ficheros de un directorio con un `find` por cada extensión.
Ahora lo rehacemos con lo de esta semana: un `for` recorre los ficheros y un `case` decide la carpeta de cada uno.
Lo construimos en cuatro pasos.

1. **Comprobar el argumento.**
   Es el mismo `if` de la semana 2, con los mensajes en el error estándar:

   ```bash
   if [[ $# -ne 1 ]]; then
       echo "Uso: $0 <directorio>" >&2
       exit 1
   fi
   dir=$1
   if [[ ! -d $dir ]]; then
       echo "Error: $dir no es un directorio" >&2
       exit 2
   fi
   ```
2. **Crear las carpetas.**
   Igual que antes, `-p` permite ejecutar el *script* varias veces:

   ```bash
   mkdir -p "$dir/imagenes" "$dir/documentos" "$dir/otros"
   ```
3. **Recorrer los ficheros.**
   El comodín da todas las entradas del primer nivel, incluidas las carpetas recién creadas, así que saltamos lo que no sea un fichero normal.
   El mismo `[[ -f $f ]]` resuelve el directorio vacío, porque el comodín queda sin expandir y `$f` vale literalmente `descargas/*`, que no existe.

   ```bash
   movidos=0
   for f in "$dir"/*; do
       [[ -f $f ]] || continue
       # paso 4
       movidos=$(( movidos + 1 ))
   done
   echo "Ficheros movidos: $movidos"
   ```
4. **Elegir la carpeta.**
   `${f##*/}` deja el nombre sin el directorio, y `,,` lo pasa a minúsculas para que `*.jpg` encaje también con `foto 1.JPG`:

   ```bash
   nombre=${f##*/}
   case ${nombre,,} in
       *.jpg|*.png) carpeta=imagenes ;;
       *.pdf|*.txt) carpeta=documentos ;;
       *)           carpeta=otros ;;
   esac
   mv -- "$f" "$dir/$carpeta/"
   ```

**Resultado** sobre un directorio con `foto 1.JPG`, `apuntes.pdf` y `lista`:

```console
$ ./ordenar.sh descargas
Ficheros movidos: 3
$ ls -R descargas
descargas:
documentos  imagenes  otros

descargas/documentos:
apuntes.pdf

descargas/imagenes:
foto 1.JPG

descargas/otros:
lista
```

Frente a la versión de la semana 2, añadir una extensión es añadirla a un patrón, no escribir otro `find`.
Hay también una diferencia de comportamiento: `*` no incluye los ficheros ocultos, así que un `.borrador` se queda donde estaba.
