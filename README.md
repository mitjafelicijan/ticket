# Minimal ticketing system

Inspired by https://joearms.github.io/published/2014-06-25-minimal-viable-program.html.

> [!NOTE]
> This is a fun little experiment how a system like this would work. This could
> be used with placing tickets in Git repository and share it with others and
> have a centralized way of handling tickets.

## Installation

Copy `ticket.sh` to your local system and source it in your `.profile` or
`.bashrc`. This will expose `ticket` function as a command in your shell.

Location of tickets is stored in `$TICKETS` path. If this variable is not set
in your `.bashrc` or provided while using `ticket` the system will create a
tickets folder `$HOME/tickets`.

## Usage

```sh
# Without any parameters help is displayed
$ ticket -h
Usage: ticket [option]
 -n, -new          creates a new ticket
 -o, -open         lists open tickets
 -c, -closed       lists closed tickets
 -h, -help         shows this help

# Creates new ticket and opens the ticket in your default editor
# defined in $EDITOR.
$ ticket -n

# Displays the list of closed tickets.
$ ticket -c

# Displays the list of open tickets.
$ ticket -o

# Open a ticket in your $EDITOR where ID is listed with `ticket -o`
# or `ticket -c`.
ticket ypRMnfGZuw
```
