BIN = $(DESTDIR)/usr/bin
MAN = $(DESTDIR)/usr/share/man/man1
CFLAGS += -Wall -std=c99
LDFLAGS += -lX11 -lXrandr

sct: sct.c
	$(CC) sct.c $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o sct

install: sct
	mkdir -p $(BIN)
	cp sct $(BIN)/sct

install.man: sct.1
	mkdir -p $(MAN)
	cp sct.1 $(MAN)/sct.1
uninstall:
	rm  -f $(BIN)/sct
	rm  -f $(MAN)/sct.1

clean:
	rm -f sct
