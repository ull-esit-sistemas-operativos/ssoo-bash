bats_load_library check_helpers

@test "muestra la primera y la última línea de notas.csv" {
  run_script notas.csv
  assert_success
  assert_output $'Primera línea:\nalumno,asignatura,nota\nÚltima línea:\npablo,SSOO,'
}

@test "con un fichero de una sola línea, esa línea es la primera y la última" {
  echo "única" > una.txt
  run_script una.txt
  assert_output $'Primera línea:\núnica\nÚltima línea:\núnica'
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp notas.csv "mis notas.csv"
  run_script "mis notas.csv"
  assert_success
  assert_line --index 1 "alumno,asignatura,nota"
}

@test "si el fichero no existe, muestra el error y el script termina con error" {
  run_script no_existe.txt
  ((status != 0)) || fail "Se esperaba un código de salida distinto de 0: el script termina con el estado de su última orden, que debe ser el tail"
  assert_stderr --partial "no_existe.txt"
}
