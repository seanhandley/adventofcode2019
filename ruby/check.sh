#!/usr/bin/env sh

function test {
  pushd "day_$1" > /dev/null
  FILE="output$1.$2.txt"
  EXPECTED=$(cat $FILE)
  CMD="./advent$1.$2.rb"
  ACTUAL=$(cat input.txt | $CMD)

  if [[ $EXPECTED == $ACTUAL ]]
  then echo "DAY $1.$2 OK"
  else echo "DAY $1.$2 FAIL"; echo "EXPECTED: \n'$EXPECTED'"; echo "ACTUAL: \n'$ACTUAL'"
  fi

  popd > /dev/null
}

test 1 1
test 1 2
test 2 1
test 2 2
test 3 1
test 3 2
test 4 1
test 4 2
test 5 1
test 5 2
test 6 1
test 6 2
test 7 1
test 7 2
test 8 1
test 8 2
test 9 1
test 9 2
# test 10 1
# test 10 2
test 11 1
test 11 2

