bats_load_library check_helpers

# Con la configuración en español, si está instalada, como en el contenedor del curso.
setup() {
  local es
  es=$(locale -a 2>/dev/null | grep -im1 '^es_ES\.utf-\?8$') && export LC_ALL=$es
  cd "$CHECK_WORKDIR" || return
}

fila() { printf '%-10s %5s %6s' "$@"; }

@test "sin -a muestra la cabecera y una fila por alumno del CSV, en orden alfabético" {
  run_script notas.csv
  assert_success
  assert_output "$(fila ALUMNO NOTAS MEDIA; echo; fila ana 2 6.75; echo; fila luis 1 4.50; echo; fila marta 2 8.75; echo; fila pablo 0 -)"
}

@test "la media tiene dos decimales con punto y no cuenta las notas vacías" {
  run_script notas.csv
  assert_line --index 2 "$(fila luis 1 4.50)" ||
    fail "luis tiene una nota, 4.5, y otra vacía: su media es 4.50; si sale 4,00 o 4,50, antepón LC_ALL=C a awk"
}

@test "-a elige los alumnos, en el orden en que se dan, y uno sin notas tiene 0 y -" {
  run_script -a sara ana notas.csv
  assert_success
  assert_output "$(fila ALUMNO NOTAS MEDIA; echo; fila sara 0 -; echo; fila ana 2 6.75)"
}

@test "el fichero puede ir antes de -a" {
  run_script notas.csv -a marta
  assert_success
  assert_line --index 1 "$(fila marta 2 8.75)"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp notas.csv "notas de octubre.csv"
  run_script -a ana "notas de octubre.csv"
  assert_success
  assert_line --index 1 "$(fila ana 2 6.75)"
}

@test "-a sin alumnos es un error por stderr con código 1" {
  run_script notas.csv -a
  assert_failure 1
  assert_stderr --partial "a -a le falta al menos un alumno"
  assert_output ""
}

@test "sin fichero, o con una opción desconocida, es un error por stderr con código 1" {
  run_script -a ana
  assert_failure 1
  assert_stderr --partial "falta el fichero de notas"
  run_script -x notas.csv
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script no_existe.csv
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.csv"
  assert_output ""
}
