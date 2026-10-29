Casi cualquier *script* que escribamos con lo visto en el curso se apoya en estas diez competencias.
La tabla sirve también de índice para repasar.

| # | Competencia | Semanas | Herramientas principales |
| --- | --- | --- | --- |
| 1 | Procesar argumentos | 1, 2, 6 | `$1`, `$#`, `shift`, `case`, `${VAR:-defecto}` |
| 2 | Recorrer entradas | 4, 5 | `for`, `while IFS= read -r` |
| 3 | Filtrar y transformar texto | 3, 4 | `grep -E`, `cut`, `tr`, `head`, `tail`, `awk` |
| 4 | Agrupar y agregar | 3, 4, 5 | `sort \| uniq -c`, *arrays* de `awk` |
| 5 | Ordenar y presentar | 3, 4 | `sort -t -k -n -r -u`, `printf` |
| 6 | Operaciones de conjuntos | 4 | `comm`, `grep -vxFf`, `sort -u` |
| 7 | Consultar el sistema | 1, 2, 5 | `ls`, `find`, `ps -o`, `who`, `id`, `lsof` |
| 8 | Actuar sobre el sistema | 2, 5 | `cp`, `mv`, `rm`, `mkdir`, `kill`, `mktemp` |
| 9 | Aritmética | 3, 4, 5 | `$(( ))`, `awk` para decimales y tiempos |
| 10 | Robustez | 1, 3, 6 | comillas, `[[ ]]`, `set -eu`, `error_exit`, ShellCheck |
