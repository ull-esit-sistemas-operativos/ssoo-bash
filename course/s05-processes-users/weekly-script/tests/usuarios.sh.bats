bats_load_library check_helpers

# ps y who se sustituyen por versiones que dan siempre la misma salida: root con 3 procesos,
# alu con 2 y daemon con 1; conectados, alu y luis (who.txt). Todo, en español, como en el
# contenedor del curso, para que se note si awk no lee los decimales con LC_ALL=C.
setup() {
  local es bin=$BATS_TEST_TMPDIR/bin
  es=$(locale -a 2>/dev/null | grep -im1 '^es_ES\.utf-\?8$') && export LC_ALL=$es
  mkdir -p "$bin"
  cat > "$bin/ps" <<'PS'
#!/bin/bash
# Columnas pedidas con -o (separadas por comas o en varias -o); sin cabecera si acaban en =.
cols=() header=1
while (($#)); do
  case $1 in
    -o) IFS=, read -ra c <<< "$2"; cols+=("${c[@]}"); shift ;;
    -o*) IFS=, read -ra c <<< "${1#-o}"; cols+=("${c[@]}") ;;
  esac
  shift
done
((${#cols[@]})) || cols=(user %mem)
for c in "${cols[@]}"; do [[ $c == *= ]] || header=0; done
printf '%s\n' 'USER %MEM PID COMMAND' 'root 1.2 1 systemd' 'root 0.5 2 kthreadd' 'root 10.6 310 dockerd' \
  'alu 15.0 1200 node' 'alu 6.7 1300 bash' 'daemon 0.1 400 atd' |
  awk -v cols="${cols[*]}" -v header=$header '
    NR == 1 { for (i = 1; i <= NF; i++) pos[tolower($i)] = i; if (header) next }
    { line = ""; n = split(cols, c, " ")
      for (i = 1; i <= n; i++) { k = c[i]; sub(/=.*/, "", k); k = (k == "comm" || k == "cmd") ? "command" : k
        line = line (i > 1 ? " " : "") (NR == 1 ? toupper(k) : $pos[k]) }
      print line }'
PS
  cat > "$bin/who" <<WHO
#!/bin/bash
cat "$CHECK_WORKDIR/who.txt"
WHO
  chmod +x "$bin/ps" "$bin/who"
  export PATH="$bin:$PATH"
  cd "$CHECK_WORKDIR" || return
}

@test "empieza por la cabecera de la tabla" {
  run_script
  assert_success
  assert_line --index 0 "USUARIO      PROCESOS   %MEM CONECTADO"
}

@test "muestra una fila por usuario, de más a menos procesos" {
  run_script
  [[ ${lines[1]} == root* && ${lines[2]} == alu* && ${lines[3]} == daemon* ]] ||
    fail "Se esperaban root, alu y daemon, en ese orden, y ha salido:"$'\n'"$output"
  ((${#lines[@]} == 4)) || fail "Se esperaban 4 líneas (la cabecera y 3 usuarios) y han salido ${#lines[@]}"
}

@test "cuenta los procesos y suma la memoria de cada usuario" {
  run_script
  assert_line --index 1 "root                3   12.3 no" ||
    fail "Se esperaba «root                3   12.3 no» y ha salido «${lines[1]}»: con la configuración en español, awk lee 10.6 como 10; antepón LC_ALL=C a awk"
  assert_line --index 3 "daemon              1    0.1 no"
}

@test "marca como conectados a los usuarios que salen en who" {
  run_script
  assert_line --index 2 "alu                 2   21.7 sí" ||
    fail "Se esperaba «alu                 2   21.7 sí» y ha salido «${lines[2]}»: alu sale en who.txt; si la memoria no es 21.7, antepón LC_ALL=C a awk"
}

@test "un usuario conectado sin procesos no aparece" {
  run_script
  refute_line --partial "luis"
}
