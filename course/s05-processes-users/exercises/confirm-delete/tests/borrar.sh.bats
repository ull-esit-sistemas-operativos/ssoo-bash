bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza con los mismos ficheros.
setup() {
  cd "$CHECK_WORKDIR" || return
  echo a > a.txt
  echo b > "b c.txt"
}

@test "borra el fichero si la respuesta es s y lo dice" {
  run_script_with_input $'s\n' a.txt
  assert_success
  assert_output "Borrado: a.txt"
  assert_file_not_exists a.txt
}

@test "lo conserva si la respuesta es n y lo dice" {
  run_script_with_input $'n\n' a.txt
  assert_success
  assert_output "Conservado: a.txt"
  assert_file_exists a.txt
}

@test "acepta S, si y sí, y N y no" {
  for r in S si sí; do
    echo a > a.txt
    run_script_with_input "$r"$'\n' a.txt
    assert_file_not_exists a.txt
  done
  for r in N no; do
    run_script_with_input "$r"$'\n' "b c.txt"
    assert_file_exists "b c.txt"
  done
}

@test "pregunta por cada fichero, también por los que tienen espacios" {
  run_script_with_input $'n\ns\n' a.txt "b c.txt"
  assert_success
  assert_output $'Conservado: a.txt\nBorrado: b c.txt'
  assert_file_exists a.txt
  assert_file_not_exists "b c.txt"
}

@test "con otra respuesta, avisa por stderr y conserva el fichero" {
  run_script_with_input $'quizá\n' a.txt
  assert_success
  assert_stderr --partial "Respuesta no válida: quizá"
  assert_file_exists a.txt
}

@test "sin argumentos muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si un fichero no existe, avisa por stderr, sigue con los demás y termina con código 2" {
  run_script_with_input $'s\n' no_existe.txt a.txt
  assert_failure 2
  assert_stderr --partial "no_existe.txt no es un fichero"
  assert_output "Borrado: a.txt" ||
    fail "Se esperaba que preguntara por a.txt después del error: el fichero que no existe no debe consumir una respuesta"
}
