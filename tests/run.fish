#!/usr/bin/env fish
#
# fzf-brew test suite
#
# Self-contained test runner with no external dependencies.
# Uses stub scripts in tests/bin/ to mock brew and fzf commands.
#
# Usage:
#   fish tests/run.fish
#
# Test approach:
#   - Stubs capture arguments and log invocations to tmp files
#   - Tests assert on logged commands and fzf arguments
#   - No real brew/fzf operations performed

set -g __failures 0

# Assertion helpers
# Using TAP-style output: "ok - <description>" or "not ok - <description>"

function __assert_equal --argument-names expected actual msg
    if test "$expected" != "$actual"
        echo "not ok - $msg"
        echo "  expected: $expected"
        echo "  actual:   $actual"
        set -g __failures (math $__failures + 1)
        return 1
    end

    echo "ok - $msg"
end

function __assert_contains --argument-names haystack needle msg
    if not string match -q "*$needle*" -- $haystack
        echo "not ok - $msg"
        echo "  missing: $needle"
        echo "  in:      $haystack"
        set -g __failures (math $__failures + 1)
        return 1
    end

    echo "ok - $msg"
end

function __read_file --argument-names path
    if test -f "$path"
        cat "$path"
    end
end

# Setup: Add test stubs and functions to path
set -l root (cd (dirname (status -f))/..; pwd)
set -l test_root (dirname (status -f))
set -gx PATH "$test_root/bin" $PATH
set -gx fish_function_path "$root/functions" $fish_function_path

# Reset stubs between tests
# Creates tmp dir and clears log files
function __reset_stubs
    set -l tmpdir "$test_root/tmp"
    mkdir -p $tmpdir

    # Log files for assertions
    set -gx BREW_STUB_LOG "$tmpdir/brew.log"
    set -gx FZF_STUB_ARGS_PATH "$tmpdir/fzf.args"

    # Control stub behavior
    set -gx FZF_STUB_OUTPUT ""  # What fzf should output (selections)
    set -gx FZF_STUB_EXIT 0     # Exit code (0=success, 130=user cancelled)

    rm -f $BREW_STUB_LOG $FZF_STUB_ARGS_PATH
end

# Helper: Get fzf args as single string for assertions
function __fzf_args
    set -l args (__read_file $FZF_STUB_ARGS_PATH)
    string join -- ' ' $args
end

# Helper: Get brew invocations as single string for assertions
function __brew_log
    set -l log (__read_file $BREW_STUB_LOG)
    string join -- ' ' $log
end

# Test 1: Formula installation with multi-select
# Simulates user selecting "fzf" and "ripgrep" in fzf
__reset_stubs
set -gx FZF_STUB_OUTPUT "fzf\nripgrep"
fbi
__assert_contains (__brew_log) "brew install fzf ripgrep" "fbi installs selected formulae"
__assert_contains (__fzf_args) "--preview" "fzf uses preview"
__assert_contains (__fzf_args) "HOMEBREW_COLOR=true" "preview uses colored brew info"
__assert_contains (__fzf_args) "brew info {}" "preview command is correct"
__assert_contains (__fzf_args) "--bind" "fzf binds ctrl-space"
__assert_contains (__fzf_args) "brew home {}" "ctrl-space opens homepage with brew home"

# Test 2: Cask uninstall
# Simulates user selecting "iterm2" to uninstall
__reset_stubs
set -gx FZF_STUB_OUTPUT "iterm2"
fcui
__assert_contains (__brew_log) "brew uninstall --cask iterm2" "fcui uninstalls selected cask"

# Test 3: Query pre-fill
# Simulates `fbi rip` - fzf should start with "rip" as initial query
__reset_stubs
set -gx FZF_STUB_OUTPUT "fzf"
fbi rip
__assert_contains (__fzf_args) "--query rip" "query pre-fills fzf"

# Test 4: User cancellation
# Exit 130 = fzf cancelled (Ctrl-C or Esc)
# Should not run brew install
__reset_stubs
set -gx FZF_STUB_EXIT 130
fbi
set -l brew_log (__brew_log)
if string match -q "*brew install*" -- $brew_log
    __assert_equal "" "brew install found" "no selection does not run brew install"
else
    echo "ok - no selection does not run brew install"
end

# Summary
if test $__failures -gt 0
    exit 1
end

exit 0
