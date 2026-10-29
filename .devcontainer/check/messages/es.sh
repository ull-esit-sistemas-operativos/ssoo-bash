# shellcheck shell=bash disable=SC2034
# Mensajes en español para `check`. Cadenas de formato de printf.
MSG_usage='Uso: check [opciones] [DIR | SCRIPT]

Analiza un script de Bash con shellcheck y, si DIR es un ejercicio
(contiene un fichero .exercise), ejecuta sus pruebas con bats.

Opciones:
  --lint-only           solo ejecuta shellcheck
  --tests-only          solo ejecuta las pruebas
  --tap                 salida TAP para otros programas
  -v, --verbose         muestra también los detalles de lo que pasa
  --tests RUTA          pruebas (fichero .bats o directorio), sustituye a .exercise
  --fixtures DIR        ficheros de ejemplo copiados antes de las pruebas
  --script FICHERO      script a probar, relativo a DIR
  --severity NIVEL      severidad de shellcheck: error|warning|info|style
  --notes NIVEL         muestra también, sin fallar, los avisos hasta NIVEL
  --exclude CÓDIGOS     omite estas comprobaciones de shellcheck (SC2012,SC2034)
  --timeout SEG         tiempo máximo por prueba
  --install-shellcheck  descarga shellcheck si no está instalado
  --shellcheck-path     muestra la ruta del shellcheck que se usa
  -h, --help            muestra esta ayuda
'
MSG_bad_option='opción desconocida: %s (consulta check --help)'
MSG_too_many_args='demasiados argumentos (consulta check --help)'
MSG_not_found='no existe: %s'
MSG_bad_timeout='tiempo límite no válido: %s'
MSG_bad_severity='severidad no válida: %s'
MSG_no_tests='este directorio no tiene pruebas configuradas'
MSG_exercise_title='Comprobando el ejercicio: %s'
MSG_lint_heading='Estilo y errores comunes (shellcheck)'
MSG_lint_name='shellcheck %s'
MSG_lint_notes='Avisos (no impiden superar el ejercicio):'
MSG_shellcheck_missing='shellcheck no está instalado (instálalo con: check --install-shellcheck)'
MSG_install_unsupported='no hay una versión de shellcheck para %s: instálalo con el gestor de paquetes'
MSG_install_downloading='Descargando shellcheck %s…'
MSG_install_no_downloader='hace falta curl o wget para descargar shellcheck'
MSG_install_download_failed='no se ha podido descargar %s'
MSG_install_bad_checksum='%s no coincide con su suma de comprobación'
MSG_no_scripts='no se han encontrado scripts .sh'
MSG_tests_heading='Pruebas'
MSG_skipped='(omitida)'
MSG_timeout_name='tiempo límite superado'
MSG_test_timeout='no ha terminado en %s s. ¿Tu script espera una entrada o tiene un bucle infinito?'
MSG_timeout_detail='Las pruebas han tardado más de %s segundos. ¿Tu script espera una entrada o tiene un bucle infinito?'
MSG_tests_error='no se han podido ejecutar las pruebas'
MSG_tests_incomplete='solo han terminado %s de %s pruebas'
MSG_nothing_checked='No hay nada que comprobar.'
MSG_summary_ok='Todo correcto: %s/%s ✔'
MSG_summary_fail='Superadas %s de %s comprobaciones'

# Header of a multi-line value, as in "output (3 lines):".
MSG_tr_lines='%s (%s líneas):'

declare -gA MSG_TR=(
  ["output differs"]="la salida (stdout) no es la esperada"
  ["stderr differs"]="la salida de error (stderr) no es la esperada"
  ["output does not contain substring"]="la salida no contiene el texto esperado"
  ["stderr does not contain substring"]="la salida de error no contiene el texto esperado"
  ["output should not contain substring"]="la salida no debería contener este texto"
  ["stderr should not contain substring"]="la salida de error no debería contener este texto"
  ["output does not contain line"]="ninguna línea de la salida es la esperada"
  ["no output line contains substring"]="ninguna línea de la salida contiene el texto"
  ["no output line matches regular expression"]="ninguna línea de la salida cumple la expresión regular"
  ["regular expression does not match output"]="la salida no cumple la expresión regular"
  ["output non-empty, but expected no output"]="no debería mostrarse nada por la salida estándar"
  ["stderr non-empty, but expected no stderr"]="no debería mostrarse nada por la salida de error"
  ["no output"]="no se ha mostrado nada por la salida estándar"
  ["no stderr"]="no se ha mostrado nada por la salida de error"
  ["line differs"]="la línea no es la esperada"
  ["command failed"]="el comando ha fallado (código de salida distinto de 0)"
  ["command succeeded, but it was expected to fail"]="el comando ha terminado con éxito, pero debería haber fallado"
  ["command failed as expected, but status differs"]="el comando ha fallado, pero con un código de salida distinto"
  ["values do not equal"]="los valores no coinciden"
  ["assertion failed"]="la comprobación ha fallado"
  ["file does not exist"]="el fichero no existe"
  ["file exists, but it was expected to be absent"]="el fichero existe, pero no debería"
  ["directory does not exist"]="el directorio no existe"
  ["files are not the same"]="los ficheros no son iguales"
)
declare -gA MSG_TR_LABEL=(
  [expected]="esperado"
  [actual]="obtenido"
  [output]="salida"
  [stderr]="stderr"
  [status]="código"
  [substring]="texto"
  [regexp]="expresión"
  [line]="línea"
  [index]="índice"
  [path]="ruta"
)
