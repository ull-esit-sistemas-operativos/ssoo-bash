# shellcheck shell=bash disable=SC2034
# English messages for `check` (default). printf format strings.
MSG_usage='Usage: check [options] [DIR | SCRIPT]

Lint a Bash script with shellcheck and, when DIR is an exercise
(contains a .exercise file), run its bats tests.

Options:
  --lint-only           only run shellcheck
  --tests-only          only run the tests
  --tap                 machine-readable TAP output
  -v, --verbose         show details of passing checks too
  --tests PATH          tests (.bats file or directory), overrides .exercise
  --fixtures DIR        sample files copied before running the tests
  --script FILE         script under test, relative to DIR
  --severity LEVEL      shellcheck severity: error|warning|info|style
  --notes LEVEL         also show, without failing, findings down to LEVEL
  --exclude CODES       skip these shellcheck checks (SC2012,SC2034)
  --timeout SECS        time limit per test
  --install-shellcheck  download shellcheck if it is not installed
  --shellcheck-path     print the path of the shellcheck used
  -h, --help            show this help
'
MSG_bad_option='unknown option: %s (see check --help)'
MSG_too_many_args='too many arguments (see check --help)'
MSG_not_found='not found: %s'
MSG_bad_timeout='invalid timeout: %s'
MSG_bad_severity='invalid severity: %s'
MSG_no_tests='no tests configured for this directory'
MSG_exercise_title='Checking exercise: %s'
MSG_lint_heading='Style and common errors (shellcheck)'
MSG_lint_name='shellcheck %s'
MSG_lint_notes='Notes (they do not fail the exercise):'
MSG_shellcheck_missing='shellcheck is not installed (install it with: check --install-shellcheck)'
MSG_install_unsupported='there is no shellcheck build for %s: install it with your package manager'
MSG_install_downloading='Downloading shellcheck %s…'
MSG_install_no_downloader='curl or wget is needed to download shellcheck'
MSG_install_download_failed='could not download %s'
MSG_install_bad_checksum='%s does not match its checksum'
MSG_no_scripts='no .sh scripts found'
MSG_tests_heading='Tests'
MSG_skipped='(skipped)'
MSG_timeout_name='time limit exceeded'
MSG_test_timeout='did not finish within %s s. Does your script wait for input or loop forever?'
MSG_timeout_detail='The tests took more than %s seconds. Does your script wait for input or loop forever?'
MSG_tests_error='the tests could not be run'
MSG_tests_incomplete='only %s of %s tests finished'
MSG_nothing_checked='Nothing to check.'
MSG_summary_ok='All checks passed: %s/%s ✔'
MSG_summary_fail='%s/%s checks passed'

# Translations of bats-assert failure text, applied to test details.
# MSG_TR: "-- <phrase> --" headers. MSG_TR_LABEL: "<label> :" prefixes.
MSG_tr_lines='%s (%s lines):'
declare -gA MSG_TR=()
declare -gA MSG_TR_LABEL=()
