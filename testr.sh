#!/bin/bash

WIDTH="$(tput cols)"
PATH="tests/" # path to test files
EXECUTABLE=".algorithm" # our executable name
RESULT="$PATH/RESULT.out"

declare -i ALL=0 # number of test cases
declare -i CORRECT=0 # only correct ones

g++ $SOURCE -o $EXECUTABLE

clear # clear the screen before we do anything

# main loop, we check correctness of every test case in specified folder(PATH)
for CASE in $PATH*.in; do
	EXPECTED="$(basename "$CASE" .in).out" # result expected from algorithm
	TEST_NAME="$(basename "$CASE" .in)"
	ALL=$(( ALL+1 )) # add 1 to counter of all test cases
	TIME="$( TIMEFORMAT='%lU';time ( ./"$EXECUTABLE" < $CASE > $RESULT) 2>&1 1>/dev/null )" # we count time it takes algorithm to produce output
	diff -a -q -i -Z -b -B --strip-trailing-cr -E $EXPECTED $RESULT 2>&1 1>/dev/null # check if it's the same
	if [ $? -ne 0 ]; then
		printf '%s' "TEST"
		printf '\033[1;31m%10s\033[0m%s%s\n' " [FAIL] " $TIME $TEST_NAME
	else
		printf '%s' "TEST"
		printf '\033[0;32m%10s\033[0m%s\n' " [ OK ] " $TIME
		CORRECT=$((CORRECT+1))
	fi
done

PERCENT="$(bc -l <<< $CORRECT/$ALL*100)"
PERCENT=$(cut -c-3 <<< $PERCENT)

echo

if (( ALL > CORRECT))
	then
		printf '\033[0;33m%s\033[0m/\033[0;32m%s\033[0m - \033[0;33m%s%%\033[0m\n' "$CORRECT" "$ALL" "$PERCENT"
	else
		printf '\033[0;32m%s\033[0m/\033[0;32m%s\033[0m - \033[0;32m%s%%\033[0m\n' "$CORRECT" "$ALL" "$PERCENT"
fi

echo

rm $RESULT $EXECUTABLE
