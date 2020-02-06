minit - mini init
=================

A small init daemon inspired by sinit[1]
with basic halting capabilities.

Building and installing
-----------------------

minit can be configured from config.h before
compile time. After editing you can simply build
and install with

    make
    make install

Usage Note
----------

This halting capability adds 2 signals to
the init daemon, SIGUSR2 and SIGQUIT. Keep
in mind that you do not want to send these
signals standalone, as they will power your
computer off, they will not run through your
init scripts or anything. You must send these
signals from the init scripts so your computer
shuts down (or reboots) after you deal with the
delicate parts of your shutdown process.


Controlling minit
-----------------

You can add some basic poweroff/reboot programs
so you don't have to remember which signal to send
with your kill command.

A basic poweroff would be

    #!/bin/sh
    /bin/kill -s USR1 1

A basic reboot would be

    #!/bin/sh
    /bin/kill -s INT 1


On your init script, you can add something like

    case "$1" in
        reboot) /bin/kill -s QUIT 1 ;;
        poweroff) /bin/kill -s USR2 1 ;;
    esac
