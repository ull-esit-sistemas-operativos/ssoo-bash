bats_load_library check_helpers

# dir/ con 6 ficheros de fechas distintas: de f1 (el más antiguo) a f6 (el más reciente).
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf fechas
  mkdir fechas
  local i
  for i in 1 2 3 4 5 6; do touch -d "2026-10-0$i 10:00" "fechas/f$i"; done
}

@test "empieza por el shebang de bash" {
  assert_shebang
}

@test "tiene permiso de ejecución" {
  assert_script_executable
}

@test "se ejecuta como ./info.sh" {
  run_script_direct proyecto
  assert_success
}

@test "muestra la ruta absoluta del directorio" {
  run_script proyecto
  assert_success
  assert_line --index 0 "Ruta:"
  assert_line --index 1 "$(realpath proyecto)" ||
    fail "Se esperaba la ruta absoluta en la segunda línea y ha salido «${lines[1]}»: realpath la calcula"
}

@test "cuenta las 4 entradas de proyecto, incluida la oculta" {
  run_script proyecto
  assert_line --index 2 "Número de entradas:"
  [[ ${lines[3]} =~ ^\ *4$ ]] ||
    fail "Se esperaba 4 en la cuarta línea y ha salido «${lines[3]}»: ls -A muestra las ocultas, pero no . ni .."
}

@test "muestra las 5 entradas más recientes, de la más nueva a la más antigua" {
  run_script fechas
  assert_success
  assert_line --index 4 "Las 5 más recientes:"
  [[ ${lines[*]:5} == "f6 f5 f4 f3 f2" ]] ||
    fail "Se esperaban f6, f5, f4, f3 y f2, una por línea, y ha salido «${lines[*]:5}»: ls -t ordena por fecha y head -n 5 se queda con las 5 primeras"
}

@test "funciona con un directorio cuyo nombre tiene espacios" {
  rm -rf "mis datos"
  mkdir "mis datos"
  touch "mis datos/notas.txt"
  run_script "mis datos"
  assert_success
  assert_line --index 1 "$(realpath "mis datos")"
  [[ ${lines[3]} =~ ^\ *1$ ]] || fail "Se esperaba 1 en la cuarta línea y ha salido «${lines[3]}»: pon \"\$1\" entre comillas dobles"
  assert_line --index 5 "notas.txt"
}

@test "si el directorio no existe, ls muestra el error" {
  run_script no_existe
  assert_stderr --partial "no_existe"
}
