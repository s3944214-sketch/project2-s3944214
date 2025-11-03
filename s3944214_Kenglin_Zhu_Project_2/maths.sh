#!/bin/bash
# Student Number: s3944214
# Student Name  : Kenglin Zhu
# Script        : maths.sh
# Purpose: CLI calculator with validation & loop

set -u  # use of unset variables is an error (debugging helper)
# function: check numeric (integer or decimal)
is_number() { [[ "$1" =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]; }

# function: check integer only
is_integer() { [[ "$1" =~ ^[+-]?[0-9]+$ ]]; }

while true; do
  echo "===== Simple Calculator ====="
  echo "1) Add"
  echo "2) Subtract"
  echo "3) Multiply"
  echo "4) Divide"
  echo "5) Modulo"
  echo "6) Exit"
  read -p "Select option (1-6): " op

  # selection construct validates the menu choice
  case "$op" in
    6) echo "Bye."; break ;;
    1|2|3|4|5) ;;
    *) echo "Invalid option. Choose 1-6."; continue ;;
  esac

  read -p "Enter first number: " n1
  read -p "Enter second number: " n2

  # validate numeric inputs
  if ! is_number "$n1" || ! is_number "$n2"; then
    echo "Error: both inputs must be numeric."; continue
  fi

  # divide/modulo specific checks
  if [[ "$op" == "4" || "$op" == "5" ]] && [[ "$n2" == "0" || "$n2" == "0.0" ]]; then
    echo "Error: division/modulo by zero is not allowed."; continue
  fi
  if [[ "$op" == "5" ]] && { ! is_integer "$n1" || ! is_integer "$n2"; }; then
    echo "Error: modulo requires integer inputs."; continue
  fi

  # compute (bc handles decimal; modulo uses bash arithmetic)
  case "$op" in
    1) result=$(echo "scale=6; $n1 + $n2" | bc);   symbol="+" ;;
    2) result=$(echo "scale=6; $n1 - $n2" | bc);   symbol="-" ;;
    3) result=$(echo "scale=6; $n1 * $n2" | bc);   symbol="*" ;;
    4) result=$(echo "scale=6; $n1 / $n2" | bc);   symbol="/" ;;
    5) result=$(( n1 % n2 ));                      symbol="%" ;;  # integer modulo
  esac

  # print nicely aligned output
  printf "Result: %s %s %s = %s\n" "$n1" "$symbol" "$n2" "$result"
  echo
done

# debugging tips:
# 1) enable bash trace with:  set -x
# 2) print variables when needed: echo "op=$op n1=$n1 n2=$n2"
# 3) run shellcheck (if available) to detect syntax issues
