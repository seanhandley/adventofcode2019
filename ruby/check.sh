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

for i in {1..11}
do
  for j in {1..2}
  do
    test $i $j
  done
done
