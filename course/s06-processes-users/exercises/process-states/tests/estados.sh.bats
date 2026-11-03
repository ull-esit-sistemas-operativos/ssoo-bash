bats_load_library check_helpers

@test "cuenta los procesos de ps.txt por estado" {
  run_script ps.txt
  assert_success
  assert_output $'En ejecución: 1\nDurmiendo: 5\nDetenidos: 1\nZombis: 1\nOtros: 1'
}

@test "clasifica por la primera letra del estado: Ss, Ssl y S+ duermen" {
  run_script ps.txt
  assert_line "Durmiendo: 5" ||
    fail "Ss, Ssl y S+ son procesos dormidos: en case, el patrón S* encaja con todos los que empiezan por S"
}

@test "no cuenta la cabecera" {
  run_script ps.txt
  assert_line "Otros: 1" ||
    fail "La línea de cabecera, con STAT, no es un proceso: sáltala"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp ps.txt "ps de hoy.txt"
  run_script "ps de hoy.txt"
  assert_success
  assert_line "Zombis: 1"
}

@test "sin un argumento muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script no_existe.txt
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.txt"
  assert_output ""
}
