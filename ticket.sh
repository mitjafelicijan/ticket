#!/bin/sh

# Inspired by https://joearms.github.io/published/2014-06-25-minimal-viable-program.html.

if [ -z "$TICKETS" ]; then
	TICKETS="$HOME/tickets"
fi

ticket() {
	mkdir -p $TICKETS
	case "$1" in
		"new")
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
		"open")
			grep --color=never -l 'status: open' $TICKETS/* | while read file; do
				head -n 5 "$file" | tail -n 1
			done
			;;
		"closed")
			grep --color=never -l 'status: closed' $TICKETS/* | while read file; do
				head -n 5 "$file" | tail -n 1
			done
			;;
		*)
			echo "Usage: ticket [option]"
			echo "  new        creates a new ticket"
			echo "  open       lists open tickets"
			echo "  closed     lists closed tickets"
			;;
	esac
}

