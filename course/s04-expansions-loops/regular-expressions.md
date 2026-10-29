Con `grep` hemos buscado textos fijos.
Pero ¿cómo buscamos las líneas sin nota, o las notas entre 9 y 10?
Necesitamos describir un conjunto de textos, no uno solo.

Una **expresión regular** es un patrón que describe un conjunto de cadenas de texto.
Se parecen a los comodines, pero no son lo mismo: en una expresión regular, `*` no significa «cualquier cosa», sino «el elemento anterior repetido cero o más veces».

| Elemento | Significado | Tipo |
| --- | --- | --- |
| `.` | Cualquier carácter | Básica |
| `*` | El elemento anterior, cero o más veces | Básica |
| `^` y `$` | Principio y final de la línea | Básica |
| `[abc]`, `[0-9]` | Un carácter de la lista o del rango | Básica |
| `[^abc]` | Un carácter que no está en la lista | Básica |
| `\.` | Un punto literal | Básica |
| `+` | El elemento anterior, una o más veces | Extendida |
| `?` | El elemento anterior, cero o una vez | Extendida |
| `{n,m}` | El elemento anterior, entre n y m veces | Extendida |
| `a\|b` | `a` o `b` | Extendida |
| `( )` | Agrupa elementos | Extendida |

`grep` usa por defecto las expresiones regulares básicas; con `grep -E` acepta también las extendidas, que son las que usaremos.
Escribe siempre el patrón entre comillas simples, para que la *shell* no expanda los `*`, `$` o `|`.

```bash
grep -E ',$' notas.csv                        # líneas sin nota
grep -E ',(9|10)(\.[0-9]+)?$' notas.csv       # notas de 9 a 10
grep -oE '^[0-9]+(\.[0-9]+){3}' acceso.log    # las IP del log
```

La segunda línea se lee así: una coma, después 9 o 10, después opcionalmente un punto seguido de cifras, y el final de la línea.
Encaja con `9`, `9.5` y `10`, pero no con `8.5`.
