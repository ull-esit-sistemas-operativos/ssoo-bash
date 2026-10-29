# shellcheck shell=bash
# Helpers for exercise tests run by `check`.
#
# Load with:  bats_load_library check_helpers
#
# Environment provided by `check`:
#   CHECK_WORKDIR  sandbox copy of the student's workdir (+ fixtures); tests run here
#   CHECK_SCRIPT   absolute path of the script under test (may be empty)

bats_require_minimum_version 1.5.0

bats_load_library bats-support
bats_load_library bats-assert
bats_load_library bats-file

# _check_msg KEY [ARGS...]: failure messages shown to students.
_check_msg() {
  local key="$1"
  shift
  local -A en=(
    [no_script]="CHECK_SCRIPT is not set: configure 'script' for this exercise"
    [not_executable]="%s is not executable (fix it with: chmod +x %s)"
    [no_shebang]="the first line must be a shebang such as '#!/usr/bin/env %s' (found: '%s')"
    [should_use]="the script should use: %s"
    [should_not_use]="the script should not use: %s"
    [no_message]="expected the message '%s', on the standard output or error; got:\n%s"
  )
  local -A es=(
    [no_script]="CHECK_SCRIPT no está definido: configura 'script' en este ejercicio"
    [not_executable]="%s no tiene permiso de ejecución (arréglalo con: chmod +x %s)"
    [no_shebang]="la primera línea debe ser un shebang como '#!/usr/bin/env %s' (encontrado: '%s')"
    [should_use]="el script debería usar: %s"
    [should_not_use]="el script no debería usar: %s"
    [no_message]="se esperaba el mensaje «%s», por la salida estándar o la de error; ha salido:\n%s"
  )
  local fmt
  if [[ ${CHECK_LANG:-en} == es ]]; then fmt="${es[$key]}"; else fmt="${en[$key]}"; fi
  # shellcheck disable=SC2059
  printf "$fmt" "$@"
}

_check_require_script() {
  if [[ -z ${CHECK_SCRIPT:-} ]]; then
    fail "$(_check_msg no_script)"
  fi
}

# run_script [ARGS...]: run the script under test with bash, from the sandbox.
# Sets $status, $output and $stderr (stdout and stderr are kept separate).
run_script() {
  _check_require_script
  cd "$CHECK_WORKDIR" || return
  run --separate-stderr bash "$CHECK_SCRIPT" "$@"
}

# run_script_with_input TEXT [ARGS...]: like run_script, with TEXT on stdin.
run_script_with_input() {
  _check_require_script
  local input="$1"
  shift
  cd "$CHECK_WORKDIR" || return
  # shellcheck disable=SC2016
  run --separate-stderr bash -c 'printf "%s" "$1" | bash "$2" "${@:3}"' _ "$input" "$CHECK_SCRIPT" "$@"
}

# run_script_direct [ARGS...]: execute the script itself (needs +x and a shebang).
run_script_direct() {
  _check_require_script
  cd "$CHECK_WORKDIR" || return
  run --separate-stderr "$CHECK_SCRIPT" "$@"
}

# assert_script_executable: the script under test has execute permission.
assert_script_executable() {
  _check_require_script
  [[ -x $CHECK_SCRIPT ]] ||
    fail "$(_check_msg not_executable "$(basename "$CHECK_SCRIPT")" "$(basename "$CHECK_SCRIPT")")"
}

# assert_shebang [INTERPRETER]: the first line is a shebang for INTERPRETER (default bash).
assert_shebang() {
  _check_require_script
  local interp="${1:-bash}" first
  IFS= read -r first < "$CHECK_SCRIPT" || true
  [[ $first =~ ^#!\ ?(/usr/bin/env\ +$interp|/(usr/)?bin/$interp)([[:space:]]|$) ]] ||
    fail "$(_check_msg no_shebang "$interp" "$first")"
}

# assert_script_uses REGEX [MESSAGE]: the script source matches REGEX (grep -E).
assert_script_uses() {
  _check_require_script
  grep -Eq -- "$1" "$CHECK_SCRIPT" || fail "${2:-$(_check_msg should_use "$1")}"
}

# refute_script_uses REGEX [MESSAGE]: the script source does not match REGEX.
refute_script_uses() {
  _check_require_script
  ! grep -Eq -- "$1" "$CHECK_SCRIPT" || fail "${2:-$(_check_msg should_not_use "$1")}"
}

# assert_message TEXT: stdout or stderr contains TEXT. For the weeks before stderr is taught,
# when a script may print its errors with a plain echo.
assert_message() {
  [[ ${output:-}$'\n'${stderr:-} == *"$1"* ]] ||
    fail "$(_check_msg no_message "$1" "${output:-}${stderr:+$'\n'$stderr}")"
}
