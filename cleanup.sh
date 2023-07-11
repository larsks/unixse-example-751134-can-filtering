#!/bin/bash

for pidfile in  pid/*.pid; do
	kill $(cat $pidfile)
done
