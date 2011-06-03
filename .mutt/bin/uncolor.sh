#!/bin/bash

rm uncolor
  for FILE in colors.*; do
	cat $FILE | sed 's/^ *color/uncolor/' >> uncolor
done
