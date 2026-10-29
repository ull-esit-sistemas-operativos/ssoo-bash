bats_load_library check_helpers

@test "tiene permiso de ejecución" {
  assert_script_executable
}

@test "./ver.sh notas.csv muestra la ruta absoluta y después el contenido" {
  run_script_direct notas.csv
  assert_success
  assert_line --index 0 "Ruta:"
  assert_line --index 1 "$(realpath notas.csv)"
  assert_line --index 2 "Contenido:"
  assert_line --index 3 "alumno,asignatura,nota"
  assert_line --index 10 "pablo,SSOO,"
}

@test "la ruta es absoluta aunque el fichero se dé con una ruta relativa" {
  run_script proyecto/src/main.c
  assert_line --index 1 "$(realpath proyecto/src/main.c)"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp notas.csv "mis notas.csv"
  run_script "mis notas.csv"
  assert_success
  assert_line --index 1 "$(realpath "mis notas.csv")"
  assert_line --index 3 "alumno,asignatura,nota"
}

@test "si el fichero no existe, cat muestra el error y el script termina con error" {
  run_script no_existe.txt
  ((status != 0)) || fail "Se esperaba un código de salida distinto de 0: el script termina con el estado de su última orden, que debe ser el cat"
  assert_stderr --partial "no_existe.txt"
}
