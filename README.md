# kv 1 2017-05-09 GNU

## NAME
kv \- a simple flat file key value store.

## SYNOPSIS
kv [*OPTION*]... [*FILE*]...

## DESCRIPTION
*kv* provides an interface for storing, retrieving and deleting key-value pairs stored in json encoded flat files.
Its usage is aimed towards shell scripts and command line driven environments.

## OPTIONS

#### -d, --delete
delete a key in the database

#### -f, --format
specify a format string; %k and %v are placeholders for key and value respectively

#### -h, --help
displays a short-help text and exits

#### -l, --list
list couples of key and values

#### -k, --key
display value of this key or update the key if --value is specified

#### -v, --value
update or set a key in the database

#### -V, --version
displays the program version, copyright and license information and exists.

## EXAMPLE
Record a new key-value pair.
```
$ kv -k kv_location -v /home/user/.local/bin/ /home/user/.cache/kv.db
```

Get the value of a record
```
$ kv -k kv_location /home/user/.cache/kv.db
```

List all records and print them with a custom format
```
$ kv -l -f "%k -- %v" /home/user/.cache/kv.db
```

## COPYRIGHT
Copyright (C) 2017 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later (http://gnu.org/licenses/gpl.html).
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

## AUTHOR
Written by Francesco Mecca (me@francescomecca.eu).
