bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una crea de nuevo el proyecto calc.
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf calc "mi calc"
  mkdir -p "calc/src/operaciones básicas" calc/docs
  printf 'int suma(int a, int b);\n' > "calc/src/operaciones básicas/suma.h"
  printf 'int sumatorio = 0;\nint main(void)\n{\n    return suma(1, 2) + suma(3, 4);\n}\n' > calc/main.c
  printf 'int resta(int a, int b);\n' > calc/src/resta.h
  printf 'suma(a, b) devuelve a + b\n' > calc/docs/suma.txt
}

@test "cambia el identificador en los ficheros de C, también en los subdirectorios" {
  run_script suma sumar calc
  assert_success
  run cat "calc/src/operaciones básicas/suma.h"
  assert_output "int sumar(int a, int b);"
  run grep -c 'return sumar(1, 2) + sumar(3, 4);' calc/main.c
  assert_output 1
}

@test "dice cuántas líneas cambia en cada fichero, ordenados por nombre, y en cuántos ficheros" {
  run_script suma sumar calc
  assert_success
  assert_output $'calc/main.c: 1 líneas\ncalc/src/operaciones básicas/suma.h: 1 líneas\nCambiado suma por sumar en 2 ficheros'
}

@test "solo cambia palabras completas, y no toca los demás ficheros" {
  run_script suma sumar calc
  grep -q '^int sumatorio = 0;$' calc/main.c || fail "Ha cambiado sumatorio: busca y cambia solo la palabra completa"
  run cat calc/docs/suma.txt
  assert_output "suma(a, b) devuelve a + b"
}

@test "-n dice qué cambiaría sin cambiar nada" {
  run_script -n suma sumar calc
  assert_success
  assert_output $'calc/main.c: 1 líneas\ncalc/src/operaciones básicas/suma.h: 1 líneas\nSe cambiaría suma por sumar en 2 ficheros'
  grep -q 'suma(1, 2)' calc/main.c || fail "-n ha cambiado calc/main.c"
}

@test "si no aparece, o no hay ficheros de C, lo dice y termina con éxito" {
  run_script producto multiplicar calc
  assert_success
  assert_output "No aparece producto en calc"
  run_script suma sumar calc/docs
  assert_success ||
    fail "Si no hay ficheros de C, xargs sin -r ejecuta grep sin ficheros, y grep espera a leer el teclado"
  assert_output "No aparece suma en calc/docs"
}

@test "funciona con un directorio cuyo nombre tiene espacios" {
  mv calc "mi calc"
  run_script resta restar "mi calc"
  assert_success
  assert_output $'mi calc/src/resta.h: 1 líneas\nCambiado resta por restar en 1 ficheros'
}

@test "-h muestra la ayuda y termina con éxito" {
  run_script -h
  assert_success
  assert_line --index 0 --partial "Uso: sustituir.sh"
}

@test "sin tres argumentos, o con una opción desconocida, es un error por stderr con código 1" {
  run_script suma sumar
  assert_failure 1
  assert_stderr --partial "uso:"
  run_script -x suma sumar calc
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
  assert_output ""
}

@test "si VIEJO o NUEVO no es un identificador, es un error por stderr con código 1 y no cambia nada" {
  run_script suma 2suma calc
  assert_failure 1
  assert_stderr --partial "2suma no es un identificador de C"
  run_script 'suma.*' x calc
  assert_failure 1
  assert_stderr --partial "suma.* no es un identificador de C"
  grep -q 'suma(1, 2)' calc/main.c || fail "Ha cambiado calc/main.c: comprueba los argumentos antes de cambiar nada"
}

@test "si no es un directorio, muestra un error por stderr y termina con código 2" {
  run_script suma sumar notas.csv
  assert_failure 2
  assert_stderr --partial "notas.csv no es un directorio"
  assert_output ""
}
