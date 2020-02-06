VERSION = 0.1.0

PREFIX  = /usr/local
BINDIR  = ${PREFIX}/bin

CFLAGS  = -Wextra -Wall -Os
LDFLAGS = -s -static
CC      = cc

all: minit

minit: config.h
	${CC} ${LDFLAGS} ${CFLAGS} -o $@ minit.c

config.h:
	cp config.def.h config.h

clean:
	rm -f minit minit-${VERSION}.tar.gz

dist:
	mkdir minit-${VERSION}
	cp minit.c Makefile LICENSE README.md config.def.h \
		minit-${VERSION}
	tar cf minit-${VERSION}.tar minit-${VERSION}
	gzip minit-${VERSION}.tar
	rm -rf minit-${VERSION}

install: all
	install -Dm755 minit ${DESTDIR}${BINDIR}/minit

uninstall:
	rm -f ${DESTDIR}${BINDIR}/minit

.PHONY: all clean dist install uninstall
