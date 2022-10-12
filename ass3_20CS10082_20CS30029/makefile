ass3_20CS10082_20CS30029_output.txt: a.out ass3_20CS10082_20CS30029_test.c
	./a.out ass3_20CS10082_20CS30029_test.c ass3_20CS10082_20CS30029_output.txt

a.out: ass3_20CS10082_20CS30029.o lex.yy.o
	gcc ass3_20CS10082_20CS30029.o lex.yy.o -lfl

ass3_20CS10082_20CS30029.o: ass3_20CS10082_20CS30029.c
	gcc -Wall -c ass3_20CS10082_20CS30029.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c:
	flex ass3_20CS10082_20CS30029.l

clean:
	rm ass3_20CS10082_20CS30029.o lex.yy.o lex.yy.c

distclean:
	rm ass3_20CS10082_20CS30029_output.txt a.out ass3_20CS10082_20CS30029.o lex.yy.o lex.yy.c
