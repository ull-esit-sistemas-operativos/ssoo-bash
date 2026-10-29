Todo programa debería explicar cómo se usa.
Escribir la ayuda con un `echo` por línea es tedioso y se lee mal en el código.

Un ***here document*** pasa como entrada estándar de un comando las líneas que siguen, hasta una línea que contiene solo el delimitador elegido.
Las variables y las sustituciones de comandos se expanden dentro, salvo que el delimitador se escriba entre comillas (`<< 'EOF'`):

```bash
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
```

El delimitador de cierre tiene que ir al principio de la línea, sin espacios delante, aunque el resto de la función esté indentado.

Si se escribe `<<-` en lugar de `<<`, bash quita los tabuladores del principio de cada línea, también los de la línea del delimitador.
Así el *here document* se puede indentar con el resto de la función.
Solo funciona con tabuladores, no con espacios, y hay que tener cuidado porque muchos editores convierten los tabuladores en espacios sin avisar.
