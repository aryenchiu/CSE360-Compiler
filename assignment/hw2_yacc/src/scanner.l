%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
int lineNum = 1;
char msg[256];
char tok[80];
unsigned int charCount = 0;
int flag = 0;
int DEBUG;
int lhs_type;

%}
Digit 		[0-9]+
space 		[ \t]
absolute 	?i:absolute
and 		?i:and
begin 		?i:begin
break 		?i:break
boolean 	?i:boolean
case 		?i:case
const 		?i:const
continue 	?i:continue
char 		?i:char
do 		?i:do
else 		?i:else
end 		?i:end
for 		?i:for
function 	?i:function
if 		?i:if
mod 		?i:mod
nil 		?i:nil
not 		?i:not
object 		?i:object
of 		?i:of
or 		?i:or
program 	?i:program
then 		?i:then
to 		?i:to
var 		?i:var
while 		?i:while
array 		?i:array
integer 	?i:integer
double 		?i:double
write 		?i:write
writeln 	?i:writeln
r_string 	?i:string
r_real 		?i:real
float 		?i:float
read 		?i:read
relop		>|<|>=|<=|<>|=
id		[A-Za-z_$]+[0-9a-zA-Z_$]*
string 		\'([^\']|\'\')*\'
real		(([1-9][0-9]*(\.([0-9]*[1-9]|0))?)|0\.[0-9]*[1-9]|0)([eE][+-][0-9]+)?
comment 	\(\*([^\*]|[\*]+[^\*\)])*[\*]+\)

%%
{program}   {charCount += yyleng; strcat(msg, yytext); return PROGRAM;}
{var}	    {charCount += yyleng; strcat(msg, yytext); return VAR;}
{begin}	    {charCount += yyleng; strcat(msg, yytext); return R_BEGIN;}
{end}	    {charCount += yyleng; strcat(msg, yytext); return END;}
{integer}   {charCount += yyleng; strcat(msg, yytext); return INTEGER;}
{r_string}  {charCount += yyleng; strcat(msg, yytext); return R_STRING;}
{r_real}    {charCount += yyleng; strcat(msg, yytext); return R_REAL;}
{boolean}   {charCount += yyleng; strcat(msg, yytext); return BOOLEAN;}
{array}	    {charCount += yyleng; strcat(msg, yytext); return ARRAY;}
{of}	    {charCount += yyleng; strcat(msg, yytext); return OF;}
{or}	    {charCount += yyleng; strcat(msg, yytext); return OR;}
{read}	    {charCount += yyleng; strcat(msg, yytext); return READ;}
{writeln}   {charCount += yyleng; strcat(msg, yytext); return WRITELN;}
{write}	    {charCount += yyleng; strcat(msg, yytext); return WRITE;}
{mod}	    {charCount += yyleng; strcat(msg, yytext); return MOD;}
{Digit}	    {charCount += yyleng; strcat(msg, yytext); return NUMBER;}
{real}	    {charCount += yyleng; strcat(msg, yytext); return REAL;}
{to}	    {charCount += yyleng; strcat(msg, yytext); return TO;}
{for}	    {charCount += yyleng; strcat(msg, yytext); return FOR;}
{do}	    {charCount += yyleng; strcat(msg, yytext); return DO;}
{if}	    {charCount += yyleng; strcat(msg, yytext); return IF;}
{then}	    {charCount += yyleng; strcat(msg, yytext); return THEN;}
\+          {charCount += yyleng; strcat(msg, yytext); return PLUS;}
\-          {charCount += yyleng; strcat(msg, yytext); return MINUS;}
\*          {charCount += yyleng; strcat(msg, yytext); return MUL;}
\/          {charCount += yyleng; strcat(msg, yytext); return DIV;}
\(	    {charCount += yyleng; strcat(msg, yytext); return LP;}
\)	    {charCount += yyleng; strcat(msg, yytext); return RP;}
\[	    {charCount += yyleng; strcat(msg, yytext); return LS;}
\]	    {charCount += yyleng; strcat(msg, yytext); return RS;}
\;	    {charCount += yyleng; strcat(msg, yytext); return SEMICOLON;}
\.	    {charCount += yyleng; strcat(msg, yytext); return PERIOD;}
\,	    {charCount += yyleng; strcat(msg, yytext); return COMMA;}
\:	    {charCount += yyleng; strcat(msg, yytext); return COLON;}
\:\=	    {charCount += yyleng; strcat(msg, yytext); return ASSIGN;}
{relop}	    {charCount += yyleng; strcat(msg, yytext); return RELOP;}
{id}	    {charCount += yyleng; strcat(msg, yytext); memset(tok, 0, 80); strcpy(tok, yytext); return ID;}
{space}     {charCount += yyleng; strcat(msg, yytext);}
\n {
	/* ignore empty line, using flag to indicate whether the line is empty */
	for ( int i = 0; i < strlen(msg); i++ ) {
		if ( msg[i] != ' ' ) {
			flag = 0;
			break;
		}	
		else {
			flag = 1;		
		}
	}
	/* use DEBUG to indicate there's an error, hence suppress the stdout. */
	if ( !flag && !DEBUG && strlen(msg) != 0 ) {
		printf("line %d: %s\n", lineNum, msg);
	} else {
		DEBUG = 0;
		flag = 0;
	}
	charCount = 0;
	lineNum++;
	memset(msg, 0, 256);
	lhs_type = 0;
}

{string}    {charCount += yyleng; strcat(msg, yytext); return STRING;}
{comment}   {
	flag = 1;
	charCount += yyleng;
	for ( int i = 0; yytext[i] != '\0'; i++ )
		if( yytext[i] == '\n' )
			lineNum++;
}

%%

int yywrap(){
    return 1;
}

