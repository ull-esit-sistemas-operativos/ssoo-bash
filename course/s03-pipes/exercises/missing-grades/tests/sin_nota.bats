bats_load_library check_helpers

@test "muestra quién tiene alguna nota vacía en notas.csv" {
  run_script notas.csv
  assert_success
  assert_output $'luis\npablo'
}

@test "no repite a nadie aunque le falten varias notas" {
  printf 'alumno,asignatura,nota\nzoe,SSOO,\nzoe,FP,\nana,FP,6\n' > repes.csv
  run_script repes.csv
  assert_success
  assert_output "zoe"
}

@test "los muestra en orden alfabético" {
  printf 'alumno,asignatura,nota\nzoe,SSOO,\nbea,FP,\nana,FP,6\n' > orden.csv
  run_script orden.csv
  assert_success
  assert_output $'bea\nzoe'
}

@test "si no falta ninguna nota, no muestra nada y termina con éxito" {
  printf 'alumno,asignatura,nota\nana,SSOO,7.5\n' > completas.csv
  run_script completas.csv
  assert_output ""
  ((status == 0)) || fail "Se esperaba el código de salida 0 y ha sido $status: que no falte ninguna nota no es un error"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp notas.csv "notas del curso.csv"
  run_script "notas del curso.csv"
  assert_success
  assert_output $'luis\npablo'
}

@test "sin argumentos muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script no_existe.csv
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.csv"
  assert_output ""
}
