CC = dmd
SRC = source
DESTDIR = /usr/bin

CCFLAGS = -release


kv: $(SRC)/kv.d
	$(CC) -of=kv $(SRC)/kv.d

debug: $(SRC)/kv.d
	$(CC) -of=kv $(SRC)/kv.d -g
test: kv
	sh $(SRC)/test.sh

clean:
	rm *.o kv

install: kv
	cp kv $(DESTDIR)/kv
