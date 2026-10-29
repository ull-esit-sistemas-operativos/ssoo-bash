bats_load_library check_helpers

@test "muestra las líneas de cada fichero y el total" {
  printf 'a\nb\nc\n' > tres.txt
  run_script notas.csv tres.txt
  assert_success
  assert_line --regexp '^ *8 notas\.csv$'
  assert_line --regexp '^ *3 tres\.txt$'
  assert_line --regexp '^ *11 total$'
}

@test "funciona con ficheros cuyo nombre tiene espacios" {
  cp notas.csv "mis notas.csv"
  run_script "mis notas.csv" notas.csv
  assert_success
  assert_line --regexp '^ *8 mis notas\.csv$'
  assert_line --regexp '^ *16 total$'
}

@test "si un fichero no existe, cuenta el otro, muestra el error y termina con error" {
  run_script notas.csv no_existe.txt
  ((status != 0)) || fail "Se esperaba un código de salida distinto de 0: wc termina con error si no puede leer algún fichero"
  assert_line --regexp '^ *8 notas\.csv$'
  assert_stderr --partial "no_existe.txt"
}
