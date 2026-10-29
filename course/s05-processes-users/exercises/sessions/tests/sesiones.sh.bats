bats_load_library check_helpers

@test "muestra las dos sesiones de alu y cuántas son" {
  run_script who.txt alu
  assert_success
  assert_output $'pts/0 desde las 09:12 (10.0.0.5)\npts/2 desde las 11:03 (10.0.0.5)\nSesiones de alu: 2'
}

@test "cuenta las sesiones después del bucle" {
  run_script who.txt luis
  assert_line --index 1 "Sesiones de luis: 1" ||
    fail "Si el while está al final de una tubería, el contador se pierde al terminar el bucle: lee el fichero con done < \"\$fichero\""
}

@test "el usuario tiene que coincidir entero" {
  cp who.txt otro.txt
  echo "alumno   pts/3        2026-10-24 12:00 (10.0.0.9)" >> otro.txt
  run_script otro.txt alu
  refute_line --partial "pts/3"
  assert_line "Sesiones de alu: 2"
}

@test "un usuario sin sesiones tiene 0 y no es un error" {
  run_script who.txt sara
  assert_success
  assert_output "Sesiones de sara: 0"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp who.txt "who de hoy.txt"
  run_script "who de hoy.txt" alu
  assert_success
  assert_line "Sesiones de alu: 2"
}

@test "sin dos argumentos muestra el uso por stderr y termina con código 1" {
  run_script who.txt
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script no_existe.txt alu
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.txt"
  assert_output ""
}
