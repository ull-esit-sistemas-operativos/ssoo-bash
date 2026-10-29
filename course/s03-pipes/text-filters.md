Un filtro es un comando que lee texto de la entrada estándar (o de los ficheros que le pasemos), lo transforma y lo escribe en la salida estándar.
Estos son los que usaremos a diario:

| Comando | Qué hace | Opciones útiles |
| --- | --- | --- |
| `grep patrón` | Deja pasar las líneas que contienen el patrón | `-i` sin distinguir mayúsculas, `-v` las que no lo contienen, `-c` cuenta, `-n` numera, `-w` palabra completa, `-o` solo la parte que encaja, `-q` sin salida |
| `cut` | Extrae campos o caracteres | `-d` separador, `-f` campos (`-f1,3`, `-f2-`), `-c` caracteres |
| `sort` | Ordena líneas | `-n` numérico, `-r` inverso, `-u` sin repetidos |
| `uniq` | Elimina repeticiones consecutivas | `-c` cuenta, `-d` solo las repetidas |
| `wc` | Cuenta | `-l` líneas, `-w` palabras, `-c` bytes |
| `head` | Primeras líneas | `-n N` |
| `tail` | Últimas líneas | `-n N`, `-n +N` desde la línea N, `-f` sigue el fichero mientras crece |
| `tr` | Sustituye o borra caracteres | `tr 'a-z' 'A-Z'`, `-d` borra, `-s` comprime repetidos |
| `tee fichero` | Copia su entrada a un fichero y a la salida | `-a` añade al final |

Algunas combinaciones resuelven problemas que aparecen continuamente:

- **Saltar una cabecera.**
  `tail -n +2 datos.csv` imprime desde la segunda línea.
- **Espacios repetidos.**
  `cut -d' '` trata cada espacio como un separador, así que dos espacios seguidos crean un campo vacío.
  `tr -s ' '` los reduce a uno antes de cortar.
- **Vigilar un *log*.**
  `tail -f acceso.log | grep ' 404 '` muestra los errores 404 según llegan, hasta que pulsamos [[Ctrl]]+[[C]].

## Buscar en un campo concreto

`grep -c 404 acceso.log` parece contar los errores 404, pero cuenta las líneas que contienen «404» en cualquier parte, también en la ruta o en el tamaño.
Es más fiable extraer primero el campo y buscar después la línea completa:

```bash
cut -d' ' -f9 acceso.log | grep -c '^404$'
```

En un patrón de `grep`, `^` representa el principio de la línea y `$` el final, así que `'^404$'` solo encaja con líneas que son exactamente `404`.
Las comillas simples evitan que la *shell* interprete el `$`.
Las expresiones regulares completas son tema de la semana 4.
