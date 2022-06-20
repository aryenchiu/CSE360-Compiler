%{
#include<stdio.h>
unsigned charCount = 1,lineCount = 1;
%}
reserved program|begin|end|writeln
space [ ]
eol \n
symbol [.;\(\)]
/* You should write your own regular expression. */


%%
{reserved} {
	printf("Line: %d, 1st char: %d, \"%s\" is a \"reserved word\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{space} {
	charCount++;
}
{eol} {
	lineCount++; 
	charCount = 1;
}
{symbol} {
/* You shold write your own code */
}

%%

int main()
{
	yylex(); 	
	return 0;
}
