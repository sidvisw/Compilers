a.out: main.o libmyl.a
	gcc main.o -L. -lmyl

main.o: main.c myl.h
	gcc -Wall -c main.c

libmyl.a: ass2_20CS10082.o
	ar -rcs libmyl.a ass2_20CS10082.o

ass2_20CS10082.o: ass2_20CS10082.c myl.h
	gcc -Wall -c ass2_20CS10082.c

clean:
	rm main.o ass2_20CS10082.o

distclean:
	rm a.out main.o libmyl.a ass2_20CS10082.o