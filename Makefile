VERSION   = 0.1.0

PREFIX    = /usr/local
MANPREFIX = ${PREFIX}/share/man
BINDIR    = ${PREFIX}/bin

CFLAGS    = -Wextra -Wall -Os
LDFLAGS   = -s -static
CC        = cc
groff     = groff -m man

all: minit

minit: config.h
	${CC} ${LDFLAGS} ${CFLAGS} -o $@ minit.c

minit.8.html:
	${groff} -Thtml ./minit.8 > minit.8.html

config.h:
	cp config.def.h config.h

clean:
	rm -f minit minit-${VERSION}.tar.gz minit.8.html

dist:
	mkdir minit-${VERSION}
	cp minit.c Makefile LICENSE README.md config.def.h \
		minit-${VERSION}
	tar cf minit-${VERSION}.tar minit-${VERSION}
	gzip minit-${VERSION}.tar
	rm -rf minit-${VERSION}

htmldoc: minit.8.html

install: all
	install -Dm755 minit ${DESTDIR}${BINDIR}/minit
	install -Dm644 minit.8 ${DESTDIR}${MANPREFIX}/man8/minit.8

uninstall:
	rm -f ${DESTDIR}${BINDIR}/minit
	rm -f ${DESTDIR}${MANPREFIX}/man8/minit.8

.PHONY: all clean dist htmldoc install uninstall
