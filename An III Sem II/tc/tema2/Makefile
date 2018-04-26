CC=gcc
CFLAGS=-lfl

grammar.tab.c grammar.tab.h: grammar.y
	bison -d grammar.y

lex.yy.c: scanner.l grammar.tab.h
	flex scanner.l

main.out: lex.yy.c grammar.tab.c grammar.tab.h
	$(CC) grammar.tab.c lex.yy.c $(CFLAGS) -o main.out
	./main.out > main.txt

all: main.out

clean: 
	rm -rf main.out lex.yy.c grammar.tab.h grammar.tab.c main.txt
