bats_load_library check_helpers

@test "muestra las 3 palabras más frecuentes de texto.txt, como uniq -c" {
  run_script texto.txt 3
  assert_success
  assert_line --index 0 --regexp '^ *3 el$'
  assert_line --index 1 --regexp '^ *2 gato$'
  assert_line --index 2 --regexp '^ *2 y$'
  ((${#lines[@]} == 3)) || fail "Se esperaban 3 líneas y ha mostrado ${#lines[@]}"
}

@test "a igual número de veces, las ordena alfabéticamente" {
  printf 'b a c\nc b a\n' > empate.txt
  run_script empate.txt 3
  assert_success
  assert_line --index 0 --regexp '^ *2 a$'
  assert_line --index 1 --regexp '^ *2 b$'
  assert_line --index 2 --regexp '^ *2 c$'
}

@test "con N mayor que el número de palabras, las muestra todas" {
  run_script colores.txt 5
  assert_success
  assert_line --index 0 --regexp '^ *3 rojo$'
  assert_line --index 1 --regexp '^ *1 verde$'
  ((${#lines[@]} == 2)) || fail "Se esperaban 2 líneas y ha mostrado ${#lines[@]}"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp texto.txt "mi texto.txt"
  run_script "mi texto.txt" 1
  assert_success
  assert_output --regexp '^ *3 el$'
}

@test "sin dos argumentos muestra el uso por stderr y termina con código 1" {
  run_script texto.txt
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si N es menor que 1, muestra un error por stderr y termina con código 1" {
  run_script texto.txt 0
  assert_failure 1
  assert_stderr --partial "Error:"
  assert_output ""
}

@test "si N no es un número, muestra un error por stderr y termina con código 1" {
  local n
  for n in 2x abc -3; do
    run_script texto.txt "$n"
    assert_failure 1
    assert_stderr "Error: N tiene que ser un número de 1 o más" ||
      fail "Con N=$n se esperaba solo el mensaje de error del script: comprueba con =~ que N tiene solo dígitos antes de compararlo con -lt"
    assert_output ""
  done
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script no_existe.txt 3
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.txt"
  assert_output ""
}
