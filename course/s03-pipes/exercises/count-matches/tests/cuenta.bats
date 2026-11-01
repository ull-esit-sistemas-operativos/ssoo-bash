bats_load_library check_helpers

@test "cuenta las líneas de texto.txt que contienen gato" {
  run_script gato texto.txt
  assert_success
  assert_output "2"
}

@test "el patrón puede tener espacios" {
  run_script "el perro" texto.txt
  assert_success
  assert_output "1"
}

@test "el patrón puede empezar por guion" {
  printf 'uno\nopción -v\ndos\n' > guion.txt
  run_script -v guion.txt
  assert_success
  assert_output "1" ||
    fail "Se esperaba 1 y ha salido «$output»: grep toma -v por una opción; con grep -e el patrón llega como patrón"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp texto.txt "mi texto.txt"
  run_script gato "mi texto.txt"
  assert_success
  assert_output "2"
}

@test "si ninguna línea lo contiene, muestra 0 y termina con éxito" {
  run_script zzz texto.txt
  assert_output "0"
  ((status == 0)) || fail "Se esperaba el código de salida 0 y ha sido $status: grep -c termina con 1 cuando no encuentra nada, y el script devuelve el estado de su última orden"
}

@test "sin dos argumentos muestra el uso por stderr y termina con código 1" {
  run_script gato
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script gato no_existe.txt
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.txt"
  assert_output ""
}
