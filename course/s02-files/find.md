`ls` solo mira dentro de los directorios que le indicamos.
¿Y si queremos todos los `.txt` modificados esta semana, estén donde estén dentro de `~/ssoo`?

`find` recorre un árbol de directorios completo y, para cada entrada, comprueba una serie de condiciones.
Las que se cumplen todas se imprimen o reciben una acción.
Su forma general es `find punto_de_partida condiciones acción`.

| Condición | Significado |
| --- | --- |
| `-name 'patrón'` | El nombre encaja con el patrón (`-iname` sin distinguir mayúsculas) |
| `-type f` / `-type d` / `-type l` | Es un fichero, un directorio o un enlace simbólico |
| `-size +1M` / `-size +100k` | Ocupa más de 1 MiB o de 100 KiB |
| `-mtime -7` | Se modificó hace menos de 7 días |
| `-maxdepth 1` | No baja más de un nivel en la jerarquía de directorios (se escribe antes que las demás condiciones) |

```bash
find ~/ssoo -name '*.txt' -mtime -7
```

Las comillas de `'*.txt'` son imprescindibles.
Sin ellas, si en el directorio de trabajo hubiera un `.txt`, la *shell* expandiría el patrón antes de llamar a `find`, y este buscaría solo ese nombre concreto.

La acción `-exec` ejecuta una orden por cada resultado, sustituyendo `{}` por su ruta.
La orden termina con `\;`, con la barra para que la *shell* no interprete el punto y coma como un separador de órdenes:

```bash
find ~/ssoo -type f -name '*.sh' -exec chmod u+x {} \;
```

> [!WARNING] La trampa de `-size` con tamaños negativos
> `find` redondea hacia arriba el tamaño de cada fichero a la unidad indicada.
> Así, `-size -1M` significa «menos de una unidad de 1 MiB», y solo encaja con ficheros vacíos.
> Para «menos de 1 MiB» hay que usar una unidad menor: `-size -1024k`.
