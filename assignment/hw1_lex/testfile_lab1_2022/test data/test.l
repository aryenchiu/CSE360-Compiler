%{
#include<stdio.h>
#include<string.h>
unsigned charCount = 1,lineCount = 1;
%}
reserved [aA][bB][sS][oO][lL][uU][tT][eE]|[aA][Nn][Dd]|[Bb][Ee][Gg][Ii][Nn]|[Bb][Rr][Ee][Aa][Kk]|[Cc][Aa][Ss][Ee]|[Cc][Oo][Nn][Ss][Tt]|[Cc][Oo][Nn][Tt][Ii][Nn][Uu][Ee]|[Dd][Oo]|[Ee][Ll][Ss][Ee]|[Ee][Nn][Dd]|[Ff][Oo][Rr]|[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]|[Ii][Ff]|[Mm][Oo][Dd]|[nN][Ii][Ll]|[Nn][Oo][Tt]|[Oo][Bb][Jj][Ee][Cc][Tt]|[Oo][Ff]|[Oo][Rr]|[Pp][Rr][Oo][Gg][Rr][Aa][Mm]|[Tt][Hh][Ee][Nn]|[Tt][Oo]|[Vv][Aa][Rr]|[wW][Hh][Ii][Ll][Ee]|[Aa][Rr][Rr][Aa][Yy]|[Ii][Nn][Tt][Ee][Gg][Ee][Rr]|[Dd][Oo][Uu][Bb][Ll][Ee]|[Ww][Rr][Ii][Tt][Ee]|[Ww][Rr][Ii][Tt][Ee][Ll][Nn]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Ff][Ll][Oo][Aa][Tt]|[Rr][Ee][Aa][Dd]
space [ ]
comma [,]
eol \n
symbol [;:><=/\.\[\]\+\*\\\(\)\-]|:=|==|<=|>=
string \'([^\']|\'\')*\'
not_string \'[^;\n]*|\'.*\'|[^ =]*\'
real ([-+]?([1-9][0-9]*(\.([0-9]*[1-9]|0))?)|[-+]?0\.[0-9]*[1-9]|0)([eE][+-][0-9]+)?
not_real [-+]?(([0-9]+(\.[0-9]*)?)|\.[0-9]*)([eE][+-][0-9]+)?
not_comment \(\*(.|{eol})*(\*\))+(.|{eol})*\*\)
comment \(\*(.|{eol})*\*\)
id [a-zA-Z_][^;,:\" \n\r\(\)]*
not_id [^ \n\r\ta-zA-Z_\(\),:]([a-zA-Z0-9_]|[^a-zA-Z0-9_;,:\" \n\r\(\)])*

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
{comma} {
	charCount++;
}
{symbol} {
	printf("Line: %d, 1st char: %d, \"%s\" is a \"symbol\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{string} {
	if (yyleng <= 30) {
		int i = 1;
		// handle escape character '
		while ( i < yyleng-1 ) {
			if ( yytext[i] == '\'' && yytext[i+1] == '\'' ) {
				int j = i;
				while ( j != yyleng-1 ) {
					yytext[j] = yytext[j+1];
					j++;
				}
				yytext[j] = '\0';
			}
			i++;
		}
		printf("Line: %d, 1st char: %d, \"%s\" is a \"string\".\n", lineCount, charCount, yytext);
		charCount += yyleng;
	} else {
		printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"string\".\n", lineCount, charCount, yytext);
		charCount += yyleng;
	}
}
{not_string} {
	printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"string\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{real} {
	printf("Line: %d, 1st char: %d, \"%s\" is a \"real number\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{not_real} {
	printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"real number\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{not_comment} {
	printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"comment\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
	int j=0;
	while ( j < yyleng ) {
		if ( yytext[j] == '\n' )
			lineCount++;
		j++;
	}
}
{comment} {
	printf("Line: %d, 1st char: %d, \"%s\" is a \"comment\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
	int i=0;
	while ( i < yyleng ) {
		if ( yytext[i] == '\n' )
			lineCount++;
		i++;
	}
}

{id} {
	int i=0;
	int flag = 0;
	// check if there is any invalid character in an id
	while ( i < yyleng ) {
		if ( !((yytext[i] >= '0' && yytext[i] <= '9') || (yytext[i] >= 'a' && yytext[i] <= 'z') || (yytext[i] >= 'A' && yytext[i] <= 'Z') || yytext[i] == '_') ) {
			flag = 1;
			break;
		}
		i++;
	}
	if ( yyleng <= 15 ) {
		if ( flag ) {
			printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"ID\".\n", lineCount, charCount, yytext);
		} else {
			printf("Line: %d, 1st char: %d, \"%s\" is an \"ID\".\n", lineCount, charCount, yytext);
		}
	} else {
		printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"ID\".\n", lineCount, charCount, yytext);
	}
	charCount += yyleng;
}
{not_id} {
	int i=0;
	int count=0;
	while ( i < yyleng ) {
		if ( (yytext[i] >= '0' && yytext[i] <= '9') || yytext[i] == '+' || yytext[i] == '-' || yytext[i] == '*' || yytext[i] == '/' || yytext[i] == '.' ) count++;
		i++;
	}
	if ( count == yyleng ) {
		i=0;
		while ( i < yyleng ) {
			char str[yyleng];
			memset(str, '\0', yyleng);
			if ( yytext[i] == '+' || yytext[i] == '-' ) {
				if ( yytext[i-1] >= '0' && yytext[i-1] <= '9' ){
					printf("Line: %d, 1st char: %d, \"%c\" is a \"symbol\".\n", lineCount, charCount, yytext[i]);
					charCount += 1;
				}
				i++;
			} else if ( yytext[i] == '*' || yytext[i] == '/'  ) {
				printf("Line: %d, 1st char: %d, \"%c\" is a \"symbol\".\n", lineCount, charCount, yytext[i]);
				charCount += 1;
				i++;
			} else {
				if ( (yytext[i-1] == '+' || yytext[i-1] == '-') && !(yytext[i-2] >= '0' && yytext[i-2] <= '9') ) {
					int j = i;
					str[0] = yytext[i-1];
					while ( yytext[i] >= '0' && yytext[i] <= '9' || yytext[i] == '.' ) {
						str[i-j+1] = yytext[i];
						i++;
					}
					printf("Line: %d, 1st char: %d, \"%s\" is a \"real number\".\n", lineCount, charCount, str);
					charCount += (i-j+1);
				} else {
					int j = i;
					while ( yytext[i] >= '0' && yytext[i] <= '9' || yytext[i] == '.' ) {
						str[i-j] = yytext[i];
						i++;
					}
					printf("Line: %d, 1st char: %d, \"%s\" is a \"real number\".\n", lineCount, charCount, str);
					charCount += (i-j);
				}
				
			}
		}
	} else {
		printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"ID\".\n", lineCount, charCount, yytext);
		charCount += yyleng;
	}
	
}



%%

int main()
{
	yylex(); 	
	return 0;
}
