Una cadena de `if` y `elif` que compara la misma variable con distintos valores es difícil de leer.
Para ese caso existe una estructura específica.

**`case`** compara un valor con una lista de patrones y ejecuta el bloque del primero que encaja.
Los patrones usan la misma sintaxis que los comodines, `|` separa alternativas y `*` actúa como caso por defecto:

```bash
case $resp in
    s|S|si|sí) kill "$pid" ;;
    n|N|no)    echo "No se hace nada" ;;
    *)         echo "Respuesta no válida: $resp" >&2 ;;
esac
```

Cada bloque termina con `;;`.
Los patrones permiten clasificar sin expresiones complicadas.
Por ejemplo, si `$stat` contiene el estado de un proceso —columna `stat` de `ps`— `case $stat in R*) … ;; S*) … ;; esac` lo clasifica por su primera letra.
