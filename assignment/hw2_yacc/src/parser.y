%define parse.error verbose
%define parse.trace
%{
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
    extern int lineNum;
    extern unsigned int charCount;
    extern int DEBUG;
    extern int flag;
    extern char tok[80];
    char * yytext;
    int yylex();
    //int yydebug = 1;
    void yyerror(const char *);
    extern char msg[256];

    // symbol table
    typedef struct symbol_table {
        int type;
        char * name;
    } symbol_table;

    symbol_table sym[1000];
    void insert_name (char *x);
    void insert_type (int x);
    int lookup (char *x);
    void idctype (int x);
    void chktype (int type);
    int top = 0;
    int cnt = 0;
    int res = 0;
    extern int lhs_type;
    char typetable[5][10] = {"empty", "integer", "string", "boolean", "real"};

%}
%union{
    int Int;
}
%start prog
%type <Int> NUMBER
%token ID STRING 
%token PROGRAM VAR R_BEGIN END INTEGER ARRAY OF READ WRITE WRITELN R_STRING TO FOR DO IF THEN BOOLEAN R_REAL
%token PLUS MINUS MUL DIV MOD OR
%token SEMICOLON COLON COMMA PERIOD ASSIGN NEWLINE
%token LP RP LS RS RELOP 
%token NUMBER REAL 

%%
/* start symbol */
prog: PROGRAM ID SEMICOLON VAR dec_list SEMICOLON R_BEGIN stmt_list SEMICOLON END PERIOD;

/* declaration */
dec_list: dec
	| dec_list SEMICOLON dec
	| error
	;

dec: id_list_dec COLON type
   ;

type: standtype | arraytype;

standtype: INTEGER  {insert_type(1); } 
	 | R_STRING {insert_type(2); } 
	 | BOOLEAN  {insert_type(3); } 
	 | R_REAL   {insert_type(4); } 
	 ;

arraytype: ARRAY LS NUMBER PERIOD PERIOD NUMBER RS OF standtype;

/* id_list for declaration */
id_list_dec: varid_dec
	| id_list_dec COMMA varid_dec
	;

id_str_list: varid_str
	| id_str_list COMMA varid_str
	;

stmt_list: stmt 
	 | stmt_list SEMICOLON stmt
	 | error
	 ;

stmt: assign | read | write | for | ifstmt ;

assign: varid { res = lookup(tok); idctype(res); } ASSIGN simpexp
      | error simpexp        // to check assign error, RHS should be simpexp
      ;

ifstmt: IF LP exp RP THEN body;

exp: simpexp 
	| simpexp RELOP simpexp
	| error
	;

simpexp: term
	| sign term
	| simpexp adding_operator term
	;

sign: PLUS | MINUS;

adding_operator: PLUS | MINUS | OR;

term: factor
    | term multiplying_operator factor 								
    ;

multiplying_operator: MUL | DIV | MOD;

factor: id_str_list		
      | NUMBER { chktype(1); }
      | REAL
      | LP simpexp RP	
      ;

read: READ LP exp RP;
write: WRITE LP exp RP
     | WRITELN
     ;

for: FOR index_exp DO body;

index_exp: varid ASSIGN simpexp TO exp;

varid: ID 
     | ID LS simpexp RS
     ;
/* varid for declaration, typically at lhs */
varid_dec: ID { insert_name(tok); }
     | ID LS simpexp RS
     ;
/* varid with string, typically at rhs */
varid_str: ID { res = lookup(tok); chktype(sym[res].type); }
     | ID LS simpexp RS
     | STRING { chktype(2); }
     ;

body: stmt
    | R_BEGIN stmt_list SEMICOLON END
    ;
%%

int main(){
    yyparse();
    if ( !DEBUG && strlen(msg) != 0 )
    	printf("line %d: %s\n", lineNum, msg);
    return 0;
}

void yyerror(const char *str) {
    fprintf(stderr, "Line %d: at char %d, %s.\n", lineNum, charCount, str);
    DEBUG=1;
}


void insert_name (char *x) {
    char * tmp = malloc(sizeof(char)*(strlen(x)+1));
    strcpy(tmp, x);
    sym[top++].name = tmp;
}

void insert_type (int x) {
    for ( int i = cnt; i < top; i++ ) {
	sym[i].type = x;
    }
    cnt = top;
}

int lookup (char *x) {
    for ( int i = 0; i < top; i++ ) {
	// variable exist
	if ( !strcmp(sym[i].name, x) ) {
	    return i;
	}
    }
    // variable not defined error
    printf("Line %d: at char %d, \"%s\" is not defined.\n", lineNum, charCount, x);

    DEBUG = 1;
    return -1;
}

void idctype (int x) {
    lhs_type = sym[x].type;
}

void chktype (int type) {
    if ( lhs_type && type ) {
	if ( lhs_type != type ) {
	    printf("Line %d: at char %d, Wrong type expression between \"%s\" and \"%s\".\n", lineNum, charCount, typetable[lhs_type], typetable[type]);
	    DEBUG = 1;
        }
    } 
}
