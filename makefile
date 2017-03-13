all:	prog
prog:
	flex calc.l
	bison -dv calc.y
	gcc -o calc calc.tab.c lex.yy.c -lfl

run:
	./calc < in.txt 
clean:
	rm -f calc *~
	rm -f calc.tab.h *~
	rm -f calc.tab.c *~
	rm -f lex.yy.c *~
