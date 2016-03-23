CC = gcc
CFLAGS = -fPIC 
LINK = -shared -soname
EXECS = delivermsg1 delivermsg2 clean-o

all:	$(EXECS)


delivermsg1:	message1.c
	$(CC) $(CFLAGS) -c $<
	ld $(LINK) libmessage.so.1 -o libmessage.so.1 message1.o
	ln -s libmessage.so.1 libmessage.so
	$(CC) -o $@ delivermsg.c -L. -lmessage -Wl,-rpath . 
	rm -f libmessage.so

delivermsg2:	message2.c
	$(CC) $(CFLAGS) -c $<
	ld $(LINK) libmessage.so.2 -o libmessage.so.2 message2.o
	ln -s libmessage.so.2 libmessage.so
	$(CC) -o $@ delivermsg.c -L. -lmessage -Wl,-rpath . 

clean-o:
	rm -f *.o

clean:
	rm -f $(EXECS) libmessage.so* 
