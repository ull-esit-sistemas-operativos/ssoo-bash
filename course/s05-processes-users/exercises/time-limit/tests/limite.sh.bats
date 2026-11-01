bats_load_library check_helpers

setup() {
  cd "$CHECK_WORKDIR" || return
  rm -f "a b.txt" a b.txt
}

@test "si la orden termina a tiempo, lo dice y termina con éxito" {
  run_script 3 sleep 1
  assert_success
  assert_output "sleep 1: ha terminado con código 0"
}

@test "la salida de la orden aparece antes del resumen" {
  run_script 2 echo hola
  assert_success
  assert_output $'hola\necho hola: ha terminado con código 0'
}

@test "termina con el mismo código que la orden" {
  run_script 2 bash -c 'exit 3'
  ((status == 3)) ||
    fail "Se esperaba el código de salida 3 y ha sido $status: wait \"\$pid\" termina con el código de la orden"
  assert_output "bash -c exit 3: ha terminado con código 3"
}

@test "no espera el tiempo que falta si la orden ya ha terminado" {
  SECONDS=0
  run_script 5 true
  assert_success
  ((SECONDS < 3)) ||
    fail "Ha tardado $SECONDS s con una orden que termina enseguida: comprueba cada segundo con kill -0 si la orden sigue viva"
}

@test "si se acaba el tiempo, para la orden, lo dice y termina con código 124" {
  SECONDS=0
  run_script 1 sleep 6
  ((SECONDS < 4)) ||
    fail "Ha tardado $SECONDS s con un límite de 1 s: si la orden sigue viva, párala con kill \"\$pid\" y espérala con wait"
  ((status == 124)) || fail "Se esperaba el código de salida 124 y ha sido $status"
  assert_output "sleep 6: no ha terminado en 1 s y se ha parado"
}

@test "pasa los argumentos a la orden tal cual, también con espacios" {
  run_script 2 touch "a b.txt"
  assert_success
  assert_file_exists "a b.txt"
  assert_file_not_exists b.txt
}

@test "con menos de dos argumentos muestra el uso por stderr y termina con código 1" {
  run_script 5
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si los segundos no son un número mayor que 0, muestra un error por stderr y termina con código 1" {
  run_script dos true
  assert_failure 1
  assert_stderr --partial "dos no es un número de segundos"
  run_script 0 true
  assert_failure 1
  assert_stderr --partial "0 no es un número de segundos"
}
