BIN = $(DESTDIR)/usr/bin
MAN = $(DESTDIR)/usr/share/man/man1
CFLAGS += -Wall

sct: sct.c
	$(CC) sct.c $(CFLAGS) -lX11 -lXrandr -o sct

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
