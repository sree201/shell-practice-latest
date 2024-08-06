#!/bin/bash

COURSE="Devops from current script"

echo "Before calling other script, course: $COURSE"
echo "Process ID fo current shell script: $$"

./other_script.sh

echo "After calling other script, course: $COURSE"
