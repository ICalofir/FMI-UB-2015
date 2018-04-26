%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);
%}

%token INCLUDE MAIN RETURN
%token OR_OP AND_OP RIGHT_OP LEFT_OP LE_OP GE_OP EQ_OP NE_OP
%token INT LONG CHAR FLOAT CONST STRING
%token BREAK CONTINUE FOR WHILE DO IF ELSE
%token INT_NR FLOAT_NR VAR LINE_COMMENT MULTILINE_COMMENT
%token ERR
%start syntax

%%
syntax
  : external_declarations
  ;

external_declarations
  : include main
  | declaration main
  | include declaration main
  | main
  ;

include
  : INCLUDE include
  | INCLUDE
  ;

declaration
  : declaration_specifiers init_declarator_list ';'
  | declaration declaration_specifiers init_declarator_list ';'
  ;

declaration_specifiers
  : type_specifier declaration_specifiers
  | type_specifier
  | type_qualifier declaration_specifiers
  | type_qualifier
  ;

type_specifier
  : INT
  | CHAR
  | LONG
  | FLOAT
  ;

type_qualifier
  : CONST
  ;

init_declarator_list
  : init_declarator
  | init_declarator_list ',' init_declarator
  ;

init_declarator
  : declarator '=' initializer
  | declarator
  ;

declarator
  : direct_declarator
  | pointer direct_declarator
  ;

pointer
  : '*'
  ;

direct_declarator
  : VAR
  ;

initializer
  : STRING
  | FLOAT_NR
  | INT_NR
  ;

main
  : INT MAIN '(' ')' compound_statement_main
  ;

compound_statement_main
  : '{' RETURN ';' '}'
  | '{' block_item_list RETURN ';' '}'
  ;

compound_statement
  : '{' '}'
  | '{' block_item_list '}'
  ;

block_item_list
  : block_item
  | block_item_list block_item
  ;

block_item
  : declaration
  | statement
  ;

statement
  : compound_statement
  | expression_statement
  | selection_statement
  | iteration_statement
  ;

selection_statement
  : IF '(' expression ')' statement ELSE statement
  | IF '(' expression ')' statement
  ;

iteration_statement
  : WHILE '(' expression ')' statement
  | DO statement WHILE '(' expression ')' ';'
  | FOR '(' expression_statement expression_statement expression ')' statement
  ;

expression_statement
  : ';'
  | expression ';'
  ;

expression
  : assignment_expression
  | expression ',' assignment_expression
  ;

assignment_expression
  : conditional_expression
  | primary_expression assignment_operator assignment_expression
  ;

assignment_operator
  : '='
  ;

conditional_expression
  : logical_or_expression
  ;

logical_or_expression
  : logical_and_expression
  | logical_or_expression OR_OP logical_and_expression
  ;

logical_and_expression
  : inclusive_or_expression
  | logical_and_expression AND_OP inclusive_or_expression
  ;

inclusive_or_expression
  : exclusive_or_expression
  | inclusive_or_expression '|' exclusive_or_expression
  ;

exclusive_or_expression
  : and_expression
  | exclusive_or_expression '^' and_expression
  ;

and_expression
  : equality_expression
  | and_expression '&' equality_expression
  ;

multiplicative_expression
  : primary_expression
  | multiplicative_expression '*' primary_expression
  | multiplicative_expression '/' primary_expression
  | multiplicative_expression '%' primary_expression
  ;

additive_expression
  : multiplicative_expression
  | additive_expression '+' multiplicative_expression
  | additive_expression '-' multiplicative_expression
  ;

shift_expression
  : additive_expression
  | shift_expression LEFT_OP additive_expression
  | shift_expression RIGHT_OP additive_expression
  ;

relational_expression
  : shift_expression
  | relational_expression '<' shift_expression
  | relational_expression '>' shift_expression
  | relational_expression LE_OP shift_expression
  | relational_expression GE_OP shift_expression
  ;

equality_expression
  : relational_expression
  | equality_expression EQ_OP relational_expression
  | equality_expression NE_OP relational_expression
  ;

primary_expression
  : VAR
  | STRING
  | FLOAT_NR
  | INT_NR
  | '(' expression ')'
  ;
%%

int main(int argc, char **argv) {
  // open a file handle to a particular file:
  FILE *myfile = fopen("main.c", "r");
  if (!myfile) {
    return -1;
  }
  yyin = myfile;

  // parse through the input until there is no more:
  do {
    yyparse();
  } while (!feof(yyin));

  printf("Done!\n");
}

void yyerror(const char *s) {
  printf("EEK, parse error!  Message: %s\n", s);
  exit(-1);
}
