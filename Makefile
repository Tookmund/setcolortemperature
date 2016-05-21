CFLAGS += -Wall
sct: sct.c
	$(CC) sct.c $(CFLAGS) -lX11 -lXrandr -o sct
clean:
	rm sct
