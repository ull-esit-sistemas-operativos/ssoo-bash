bats_load_library check_helpers

perms() { stat -c %A "$1"; }

@test "deja notas.csv con permisos rw------- y lo muestra con ls -l" {
  chmod 644 notas.csv
  run_script notas.csv
  assert_success
  [[ $(perms notas.csv) == -rw------- ]] || fail "Se esperaban los permisos -rw------- y son $(perms notas.csv): hay que quitar r, w y x a g y a o"
  assert_output --regexp '^-rw------- .* notas\.csv$'
}

@test "no cambia los permisos del propietario" {
  chmod 750 notas.csv
  run_script notas.csv
  [[ $(perms notas.csv) == -rwx------ ]] || fail "Se esperaban los permisos -rwx------ y son $(perms notas.csv): el propietario debe conservar los suyos"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp notas.csv "mis notas.csv"
  chmod 664 "mis notas.csv"
  run_script "mis notas.csv"
  assert_success
  [[ $(perms "mis notas.csv") == -rw------- ]] || fail "Se esperaban los permisos -rw------- y son $(perms "mis notas.csv")"
}

@test "sin un argumento muestra el uso y termina con código 1" {
  run_script
  assert_failure 1
  assert_message "Uso:"
}

@test "si no es un fichero, muestra un error y termina con código 2" {
  run_script proyecto
  assert_failure 2
  assert_message "Error: proyecto no es un fichero"
}

@test "si el fichero no existe, muestra un error y termina con código 2" {
  run_script no_existe.txt
  assert_failure 2
  assert_message "Error: no_existe.txt no es un fichero"
}
