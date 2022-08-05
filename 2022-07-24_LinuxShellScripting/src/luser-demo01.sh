#!/bin/bash

# Hello from the main OS.
echo "Hello"

WORD='script'

echo "$WORD"

echo '$WORD'

echo "This is a shell $WORD"

echo "This is a shell ${WORD}"

echo "${WORD}ing is fun!"

echo "$WORDing is fun!"

ENDING='ed'

echo "This is ${WORD}${ENDING}."

ENDING='ing'

echo "${WORD}${ENDING} is fun!"

ENDING='s'
echo "You ar going to write many ${WORD}${ENDING} in this class!"
