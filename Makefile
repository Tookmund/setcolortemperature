BIN = $(DESTDIR)/usr/bin
MAN = $(DESTDIR)/usr/share/man/man1
CFLAGS += -Wall -std=c99
LDFLAGS += -lX11 -lXrandr

sct: sct.c
	$(CC) sct.c $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o sct

install: sct sctd.sh
	mkdir -p $(BIN)
	cp sct $(BIN)/sct
	cp sctd.sh $(BIN)/sctd

install.man: sct.1 sctd.1
	mkdir -p $(MAN)
	cp sct.1 $(MAN)/sct.1
	cp sctd.1 $(MAN)/sctd.1

uninstall:
	rm  -f $(BIN)/sct
	rm  -f $(BIN)/sctd
	rm  -f $(MAN)/sct.1
	rm  -f $(MAN)/sctd.1

clean:
	rm -f sct
