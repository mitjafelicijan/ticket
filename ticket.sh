#!/bin/bin/env bash

ticket() {
	if [ "$(uname -s)" != "Linux" ]; then
		printf "Currently only Linux is supported.\n"
		return 1
	fi

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
			ticket_id=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 10 | head -n 1)
			ticket_file=$TICKETS/$ticket_id
			printf "id: %s\n" $ticket_id > $ticket_file
			printf "responsible: %s\n" `whoami`@`hostname` >> $ticket_file
			printf "created: %s\n" "`date`" >> $ticket_file
			printf "status: open\n" >> $ticket_file
			printf "title: ?\n" >> $ticket_file
			printf "====\n" >> $ticket_file
			printf "Describe your problem here\n" >> $ticket_file
			$EDITOR $ticket_file
			;;
		-o|-open)
			printf "%-12s %-21s %s\n" "Ticket ID" "Created at" "Title"
			printf "%0.s-" {1..80}
			printf "\n"
			grep --color=never -l 'status: open' $TICKETS/* | while read file; do
				id=$(head -n 1 "$file" | tail -n 1 | awk '{ print $2 }')
				title=$(head -n 5 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate=$(head -n 3 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate_fmt=$(date -d "$cdate" "+%Y-%m-%d %H:%M:%S")
				printf "%-12s %-20s %.43s...\n" "$id" "$cdate_fmt" "$title"
			done
			;;
		-c|-closed)
			printf "%-12s %-21s %s\n" "Ticket ID" "Created at" "Title"
			printf "%0.s-" {1..80}
			printf "\n"
			grep --color=never -l 'status: closed' $TICKETS/* | while read file; do
				id=$(head -n 1 "$file" | tail -n 1 | awk '{ print $2 }')
				title=$(head -n 5 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate=$(head -n 3 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate_fmt=$(date -d "$cdate" "+%Y-%m-%d %H:%M:%S")
				printf "%-12s %-20s %.43s...\n" "$id" "$cdate_fmt" "$title"
			done
			;;
		-h|-help)
			printf "Usage: ticket [option]\n"
			printf "  -n, -new          creates a new ticket\n"
			printf "  -o, -open         lists open tickets\n"
			printf "  -c, -closed       lists closed tickets\n"
			printf "  -h, -help         shows this help\n"
			;;
		*)
			if [ -e "$TICKETS/$1" ] && [ -f "$TICKETS/$1" ]; then
				$EDITOR "$TICKETS/$1"
			else
				printf "Ticket not found: $TICKETS/$1\n"
			fi
			;;
	esac
}

