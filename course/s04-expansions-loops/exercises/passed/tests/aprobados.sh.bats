bats_load_library check_helpers

# Con la configuración en español, si está instalada, como en el contenedor del curso.
setup() {
  local es
  es=$(locale -a 2>/dev/null | grep -im1 '^es_ES\.utf-\?8$') && export LC_ALL=$es
  cd "$CHECK_WORKDIR" || return
}

@test "con mínimo 7 muestra las tres notas de 7 o más, de mayor a menor" {
  run_script notas.csv 7
  assert_success
  assert_output $'marta SSOO 9\nmarta FP 8.5\nana SSOO 7.5' ||
    fail "Con la configuración en español, sort -n lee 8.5 como 8: antepón LC_ALL=C a cada comando que lea decimales, también a sort"
}

@test "el mínimo puede tener decimales: con 6.5 no sale el 6 de ana en FP" {
  run_script notas.csv 6.5
  assert_success
  refute_line "ana FP 6"
  assert_line "ana SSOO 7.5"
}

@test "con mínimo 10 no sale ninguna nota" {
  run_script notas.csv 10
  assert_success
  assert_output "" ||
    fail "Con la configuración en español, awk no reconoce 8.5 como número y lo compara como texto, y \"8.5\" va detrás de \"10\": antepón LC_ALL=C a awk"
}

@test "la nota igual al mínimo cuenta" {
  run_script notas.csv 7.5
  assert_line "ana SSOO 7.5"
}

@test "no muestra la cabecera ni las notas vacías" {
  run_script notas.csv 0
  refute_line --partial "alumno"
  refute_line --partial "luis FP"
  ((${#lines[@]} == 5)) || fail "Se esperaban las 5 notas que no están vacías y han salido ${#lines[@]} líneas"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp notas.csv "notas de octubre.csv"
  run_script "notas de octubre.csv" 9
  assert_success
  assert_output "marta SSOO 9"
}

@test "sin dos argumentos muestra el uso por stderr y termina con código 1" {
  run_script notas.csv
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script no_existe.csv 5
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.csv"
}

@test "si el mínimo no es un número, muestra un error por stderr y termina con código 3" {
  run_script notas.csv siete
  assert_failure 3
  assert_stderr --partial "siete no es una nota"
  assert_output ""
}
