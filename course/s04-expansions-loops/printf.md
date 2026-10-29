`echo` no sabe alinear columnas.
`printf` recibe un formato y una lista de valores, y sustituye cada especificación del formato por un valor:

| Especificación | Significado |
| --- | --- |
| `%s` | Texto |
| `%d` | Número entero |
| `%10s` | Texto alineado a la derecha en 10 columnas |
| `%-10s` | Texto alineado a la izquierda en 10 columnas |
| `\n` | Salto de línea (`printf` no lo añade por su cuenta) |

Si hay más valores que especificaciones, `printf` repite el formato, lo que permite imprimir una tabla en una sola llamada:

```console
$ printf '%-6s %3d\n' ana 7 luis 10
ana      7
luis    10
```

El `printf` de bash también lee los números según la configuración regional.
En un equipo en español, `printf '%.2f\n' 7,5` imprime `7,50`, pero `printf '%.2f\n' 7.5` falla con «número no válido» e imprime `7,00`.
`awk` tiene su propio `printf`, con las mismas especificaciones, que es más cómodo cuando el número sale de un cálculo:

```console
$ printf 'ana 7,5\nluis 10\n' | awk '{ printf "%-6s %5.2f\n", $1, $2 }'
ana     7,50
luis   10,00
```

Si un número con decimales ya viene formateado y solo hay que imprimirlo desde bash, mejor trátalo como texto con `%s`, en lugar de usar `%f`.
