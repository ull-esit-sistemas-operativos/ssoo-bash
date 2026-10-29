bats_load_library check_helpers

# Con la configuración en español, como en el contenedor del curso: notas.sh adapta los datos
# a la coma decimal y awk escribe las medias con coma.
setup() {
  local es
  es=$(locale -a 2>/dev/null | grep -im1 '^es_ES\.utf-\?8$') ||
    skip "Esta prueba necesita la configuración regional es_ES.UTF-8"
  export LC_ALL=$es
  cd "$CHECK_WORKDIR" || return
}

@test "con notas.csv muestra la media de cada asignatura, por orden alfabético" {
  run_script notas.csv
  assert_success
  assert_line --index 0 "ASIGNATURA MEDIA"
  [[ ${lines[1]} == "FP          7,25" && ${lines[2]} == "SSOO        7,00" ]] ||
    fail "Se esperaban «FP          7,25» y «SSOO        7,00» y ha salido:"$'\n'"$output"$'\n'"En español, awk lee 7.5 como 7: cambia los puntos por comas con tr ',.' ';,' antes de awk. Las notas vacías no cuentan"
}

@test "con notas.csv la mejor media es la de marta" {
  run_script notas.csv
  assert_line "Mejor media: marta 8,75" ||
    fail "No ha salido «Mejor media: marta 8,75»: en español, awk lee 8.5 como 8 si no cambias los puntos por comas"
}

@test "con notas.csv faltan la de luis en FP y la de pablo en SSOO" {
  run_script notas.csv
  assert_line --index 4 "Sin nota:"
  assert_line --index 5 "luis (FP)"
  assert_line --index 6 "pablo (SSOO)"
  ((${#lines[@]} == 7)) || fail "Se esperaban 7 líneas y han salido ${#lines[@]}"
}

@test "funciona con otras asignaturas y sin notas que falten" {
  printf 'alumno,asignatura,nota\neva,BD,10\neva,SO,5\njon,BD,6.5\n' > otras.csv
  run_script otras.csv
  assert_success
  assert_output $'ASIGNATURA MEDIA\nBD          8,25\nSO          5,00\nMejor media: eva 7,50\nSin nota:'
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp notas.csv "notas de octubre.csv"
  run_script "notas de octubre.csv"
  assert_success
  assert_line "Mejor media: marta 8,75"
}

@test "sin un argumento muestra el uso por stderr y termina con código 1" {
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
