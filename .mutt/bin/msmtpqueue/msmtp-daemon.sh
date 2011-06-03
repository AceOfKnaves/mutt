#!/bin/sh

script=$HOME/.mutt/bin/msmtpqueue/msmtp-runqueue.sh

while sleep 30; do
	$script &> /dev/null
done &
