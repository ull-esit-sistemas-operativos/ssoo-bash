bats_load_library check_helpers

# Cada prueba lanza sus propios procesos sleep con el fichero abierto como entrada estándar
# (sin el descriptor 3 de bats, para que no espere por ellos) y los termina al acabar.
setup() {
  cd "$CHECK_WORKDIR" || return
  pids=()
}

teardown() {
  ((${#pids[@]} == 0)) || kill "${pids[@]}" 2>/dev/null || true
}

abrir() {
  sleep 30 < "$1" > /dev/null 2>&1 3>&- &
  pids+=("$!")
}

@test "dice qué proceso tiene abierto el fichero, con su PID y su nombre" {
  abrir notas.csv
  run_script notas.csv
  assert_success
  assert_output "notas.csv: ${pids[0]} sleep"
}

@test "muestra una línea por proceso" {
  abrir notas.csv
  abrir notas.csv
  run_script notas.csv
  assert_success
  assert_line "notas.csv: ${pids[0]} sleep"
  assert_line "notas.csv: ${pids[1]} sleep"
  ((${#lines[@]} == 2)) || fail "Se esperaban dos líneas y ha salido:"$'\n'"$output"
}

@test "si nadie tiene abierto el fichero, lo dice y sigue con los demás" {
  abrir notas.csv
  run_script alumnos.txt notas.csv
  assert_success ||
    fail "lsof -t termina con código 1 cuando nadie tiene abierto el fichero; con set -e, eso detiene el script"
  assert_output $'alumnos.txt: nadie lo tiene abierto\nnotas.csv: '"${pids[0]}"' sleep'
}

@test "-k para los procesos con SIGTERM y lo dice" {
  abrir notas.csv
  run_script -k notas.csv
  assert_success
  assert_output "notas.csv: parado ${pids[0]} sleep"
  local estado=0
  wait "${pids[0]}" || estado=$?
  ((estado == 143)) || fail "sleep ha terminado con código $estado, y con SIGTERM habría sido 143"
}

@test "funciona con nombres que tienen espacios" {
  cp notas.csv "notas de hoy.csv"
  abrir "notas de hoy.csv"
  run_script "notas de hoy.csv"
  assert_success
  assert_output "notas de hoy.csv: ${pids[0]} sleep"
}

@test "sin ficheros muestra el uso por stderr y termina con código 1" {
  run_script -k
  assert_failure 1
  assert_stderr --partial "uso:"
  assert_output ""
}

@test "una opción desconocida es un error por stderr con código 1" {
  run_script -x notas.csv
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
  assert_output ""
}

@test "si algún fichero no existe, muestra un error por stderr, termina con código 2 y no para nada" {
  abrir notas.csv
  run_script -k notas.csv no_existe.csv
  assert_failure 2
  assert_stderr --partial "no existe no_existe.csv"
  assert_output ""
  kill -0 "${pids[0]}" || fail "Se ha parado el sleep: comprueba todos los ficheros antes de hacer nada"
}
