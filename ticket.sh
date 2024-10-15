#!/bin/bin/env bash

ticket() {
	if [ -z "$TICKETS" ]; then
		TICKETS="$HOME/tickets"
	fi

	mkdir -p $TICKETS

	if [ -z "$1" ]; then
		echo "`ticket -h`"
		return 0
	fi

	case $1 in
		-n|-new)
			new_id=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 10 | head -n 1)
			echo "id: ${new_id}" > $TICKETS/$new_id
			echo "responsible: `whoami`@`hostname`" >> $TICKETS/$new_id
			echo "created: `date`" >> $TICKETS/$new_id
			echo "status: open" >> $TICKETS/$new_id
			echo "title: ?" >> $TICKETS/$new_id
			echo "----" >> $TICKETS/$new_id
			echo "Describe your problem here" >> $TICKETS/$new_id
			$EDITOR $TICKETS/$new_id
			;;
		-o|-open)
			grep --color=never -l 'status: open' $TICKETS/* | while read file; do
				id=$(head -n 1 "$file" | tail -n 1 | awk '{ print $2 }')
				title=$(head -n 5 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				printf "%s\t%s\n" "$id" "$title"
			done
			;;
		-c|-closed)
			grep --color=never -l 'status: closed' $TICKETS/* | while read file; do
				id=$(head -n 1 "$file" | tail -n 1 | awk '{ print $2 }')
				title=$(head -n 5 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				printf "%s\t%s\n" "$id" "$title"
			done
			;;
		-h|-help)
			echo "Usage: ticket [option]"
			echo " -n, -new          creates a new ticket"
			echo " -o, -open         lists open tickets"
			echo " -c, -closed       lists closed tickets"
			echo " -h, -help         shows this help"
			;;
		*)
			if [ -e "$TICKETS/$1" ] && [ -f "$TICKETS/$1" ]; then
				$EDITOR "$TICKETS/$1"
			else
				echo "Ticket not found: $TICKETS/$1"
			fi
			;;
	esac
}

