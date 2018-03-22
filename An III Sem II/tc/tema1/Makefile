CC=gcc
CFLAGS=-ll
all: main.out

lex.yy.c: scanner.l
	flex scanner.l

main.out: lex.yy.c main.c
	$(CC) lex.yy.c -o main.out $(CFLAGS)
	./main.out < main.c > main.txt

clean:
	rm -rf main.out lex.yy.c main.txt
