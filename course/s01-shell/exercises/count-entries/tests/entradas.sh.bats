bats_load_library check_helpers

@test "cuenta las 4 entradas de proyecto, incluida la oculta" {
  run_script proyecto
  assert_success
  assert_line --index 0 "Número de entradas:"
  [[ ${lines[1]} =~ ^\ *4$ ]] || fail "Se esperaba 4 en la segunda línea y ha salido «${lines[1]}»: ls -A muestra las ocultas, pero no . ni .."
}

@test "después lista las entradas, una por línea" {
  run_script proyecto
  assert_line --index 2 "Entradas:"
  assert_line ".oculto"
  assert_line "README.md"
  assert_line "docs"
  assert_line "src"
  ((${#lines[@]} == 7)) || fail "Se esperaban 7 líneas (dos títulos, la cuenta y 4 entradas) y han salido ${#lines[@]}: . y .. no son entradas reales"
}

@test "funciona con un directorio cuyo nombre tiene espacios" {
  mkdir -p "mis datos"
  cp notas.csv "mis datos/"
  run_script "mis datos"
  assert_success
  [[ ${lines[1]} =~ ^\ *1$ ]] || fail "Se esperaba 1 en la segunda línea y ha salido «${lines[1]}»"
  assert_line "notas.csv"
}

@test "si el directorio no existe, ls muestra el error y el script termina con error" {
  run_script no_existe
  ((status != 0)) || fail "Se esperaba un código de salida distinto de 0: el script termina con el estado de su última orden, que debe ser el ls de la lista"
  assert_stderr --partial "no_existe"
}
