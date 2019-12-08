#!/usr/bin/env sh

function test {
  pushd "day_$1" > /dev/null
  FILE="output$1.1.txt"
  EXPECTED=$(cat $FILE)
  CMD="./advent$1.1.rb"
  ACTUAL=$(cat input.txt | $CMD | tail -1)

  if [[ $EXPECTED == $ACTUAL ]]
  then echo "OK DAY $1.1"
  else echo "FAIL DAY $1.1"
  fi

  FILE="output$1.2.txt"
  EXPECTED=$(cat $FILE)
  CMD="./advent$1.2.rb"
  ACTUAL=$(cat input.txt | $CMD | tail -1)

  if [[ $EXPECTED == $ACTUAL ]]
  then echo "OK DAY $1.2"
  else echo "FAIL DAY $1.2"
  fi

  popd > /dev/null
}

test 1
test 2
test 3
test 4
test 5
test 6
test 7
# test 8 # This outputs ASCII art
