bats_load_library check_helpers

@test "notas.csv es correcto: lo dice y termina con éxito" {
  run_script notas.csv
  assert_success
  assert_output "Todo correcto"
}

@test "dice qué líneas fallan y por qué, cuántos errores hay y termina con código 3" {
  printf 'alumno,asignatura,nota\nana,SSOO,7.5\nluis,FP\nmarta,SSOO,11\n,FP,5\npablo,SSOO,6,5\nsara,FP,\n' > mal.csv
  run_script mal.csv
  assert_failure 3
  assert_output $'mal.csv: línea 3: no tiene tres campos\nmal.csv: línea 4: nota no válida: 11\nmal.csv: línea 5: falta el alumno o la asignatura\nmal.csv: línea 6: no tiene tres campos\nErrores: 4'
}

@test "una nota es un número de 0 a 10, con decimales, también 10.0, o está vacía" {
  printf 'alumno,asignatura,nota\na,X,0\nb,X,10\nc,X,9.25\nd,X,\ne,X,10.0\nf,X,10.5\ng,X,siete\n' > notas2.csv
  run_script notas2.csv
  assert_failure 3
  assert_output $'notas2.csv: línea 7: nota no válida: 10.5\nnotas2.csv: línea 8: nota no válida: siete\nErrores: 2'
}

@test "comprueba la cabecera" {
  printf 'nombre,materia,nota\nana,SSOO,7\n' > cab.csv
  run_script cab.csv
  assert_failure 3
  assert_line "cab.csv: línea 1: la cabecera no es alumno,asignatura,nota"
}

@test "con varios ficheros, los comprueba todos y suma los errores" {
  printf 'alumno,asignatura,nota\nana,SSOO,12\n' > a.csv
  printf 'alumno,asignatura,nota\nluis,FP,-1\n' > "notas de b.csv"
  run_script notas.csv a.csv "notas de b.csv"
  assert_failure 3
  assert_output $'a.csv: línea 2: nota no válida: 12\nnotas de b.csv: línea 2: nota no válida: -1\nErrores: 2'
}

@test "sin argumentos muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "uso:"
  assert_output ""
}

@test "si no puede leer algún fichero, muestra un error por stderr y termina con código 2 sin comprobar nada" {
  run_script notas.csv no_existe.csv
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.csv"
  assert_output ""
}
