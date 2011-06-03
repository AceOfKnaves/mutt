#!/bin/bash

if [[ $TERM =~ 256 ]]; then
	echo ~/.mutt/themes/themes.256
else
	echo ~/.mutt/themes/themes.default
fi
