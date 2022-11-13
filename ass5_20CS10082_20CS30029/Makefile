a.out: lex.yy.o y.tab.o ass5_20CS10082_20CS30029_translator.o
	g++ lex.yy.o y.tab.o ass5_20CS10082_20CS30029_translator.o -ll

ass5_20CS10082_20CS30029_translator.o: ass5_20CS10082_20CS30029_translator.cxx ass5_20CS10082_20CS30029_translator.h
	g++ -c ass5_20CS10082_20CS30029_translator.h
	g++ -c ass5_20CS10082_20CS30029_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass5_20CS10082_20CS30029.l y.tab.c ass5_20CS10082_20CS30029_translator.h
	flex ass5_20CS10082_20CS30029.l

y.tab.c: ass5_20CS10082_20CS30029.y
	yacc -dtv ass5_20CS10082_20CS30029.y
	
clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass5_20CS10082_20CS30029_translator.o y.output a.out ass5_20CS10082_20CS30029_translator.h.gch

run: a.out
	./a.out < TestInputs/ass5_20CS10082_20CS30029_test1.c > TestOutputs/ass5_20CS10082_20CS30029_quads1.out
	./a.out < TestInputs/ass5_20CS10082_20CS30029_test2.c > TestOutputs/ass5_20CS10082_20CS30029_quads2.out
	./a.out < TestInputs/ass5_20CS10082_20CS30029_test3.c > TestOutputs/ass5_20CS10082_20CS30029_quads3.out
	./a.out < TestInputs/ass5_20CS10082_20CS30029_test4.c > TestOutputs/ass5_20CS10082_20CS30029_quads4.out
	./a.out < TestInputs/ass5_20CS10082_20CS30029_test5.c > TestOutputs/ass5_20CS10082_20CS30029_quads5.out

