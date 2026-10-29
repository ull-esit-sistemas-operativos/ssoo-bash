En `info.sh` escribimos `"$1"` cada vez que necesitábamos el directorio.
Si el *script* crece, ¿no sería más claro darle un nombre?

Una **variable** es un nombre al que se asigna un valor de texto, con `nombre=valor`, y cuyo valor se recupera con `$nombre`:

```bash
dir=$1
echo "Ordenando $dir"
```

No puede haber espacios alrededor del `=`.
Si escribimos `dir = $1`, bash entiende que queremos ejecutar un comando llamado `dir` con los argumentos `=` y el valor de `$1`.

Cuando la variable va pegada a más texto, hay que delimitar su nombre con llaves.
`"${dir}_copia"` es el valor de `dir` seguido de `_copia`, pero `"$dir_copia"` es el valor de una variable llamada `dir_copia`, que no existe y se sustituye por la cadena vacía.
Si detrás del nombre viene un carácter que no puede formar parte de él, como `/` o `.`, las llaves no hacen falta: `"$dir/imagenes"`.

Cuando usamos una variable, las comillas deciden qué llega al comando:

- **Comillas dobles.**
  `"$dir"` se sustituye por el valor y lo mantiene como un solo argumento, aunque tenga espacios.
  Es la forma que usaremos casi siempre.
- **Comillas simples.**
  `'$dir'` no se sustituye: llega el texto literal `$dir`.
- **Sin comillas.**
  `$dir` se sustituye y después se parte por los espacios.
  Un directorio llamado `mis fotos` llegaría como dos argumentos, `mis` y `fotos`.

## Comprobar los argumentos

La variable especial `$#` contiene el número de argumentos que recibió el *script*.
Con ella podemos parar a tiempo si nos llaman mal.
La estructura `if` la estudiaremos a fondo la semana que viene; de momento basta con este patrón:

```bash
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <directorio>"
    exit 1
fi
```

`-ne` significa «no es igual», comparando números.
`exit 1` termina el *script* con estado de salida 1, que indica un error.
Sin `exit`, el *script* devuelve el estado del último comando que ejecutó.
`exit 0` lo termina indicando éxito.

Con el mismo patrón comprobamos que el argumento es un directorio, con la condición `-d`:

```bash
if [[ ! -d $dir ]]; then
    echo "Error: $dir no es un directorio"
    exit 2
fi
```

El `!` niega la condición.
Usar estados distintos para errores distintos permite a quien llama al *script* saber qué falló.
