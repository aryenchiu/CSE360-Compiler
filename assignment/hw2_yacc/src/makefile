all:	clean y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -ly -lfl -o parser

y.tab.c:
	bison -y -d parser.y

lex.yy.c:
	flex scanner.l

clean:
	rm -f parser lex.yy.c y.tab.c y.tab.h
