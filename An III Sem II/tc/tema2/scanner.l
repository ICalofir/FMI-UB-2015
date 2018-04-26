%{
#include <stdio.h>
#include "grammar.tab.h"
%}

WHITESPACE [ \t\n]+
DIGIT [0-9]
ALPHA [a-zA-Z]
STRING \"[^\n]+\"
NAME ({ALPHA}|{DIGIT}|[_])+
LINE_COMMENT [/][/](.*)
MULTILINE_COMMENT ([/][\*])(((.*)\n(.*))*)([\*][/])

%%
"#include"[ <].*[>] {return INCLUDE;}
"main" {return MAIN;}
"return 0" {return RETURN;}
"int" {return INT;}
"long" {return LONG;}
"char" {return CHAR;}
"float" {return FLOAT;}
"const" {return CONST;}
"break" {return BREAK;}
"continue" {return CONTINUE;}
"for" {return FOR;}
"while" {return WHILE;}
"do" {return DO;}
"if" {return IF;}
"else" {return ELSE;}

";" {return ';';}
":" {return ':';}
"(" {return '(';}
")" {return ')';}
"[" {return '[';}
"]" {return ']';}
"{" {return '{';}
"}" {return '}';}
"=" {return '=';}
">" {return '>';}
"<" {return '<';}
"," {return ',';}
"." {return '.';}
"+" {return '+';}
"-" {return '-';}
"/" {return '/';}
"*" {return '*';}
"%" {return '%';}
"&" {return '&';}
"|" {return '|';}
"!" {return '!';}
"?" {return '?';}
"^" {return '^';}
"~" {return '~';}
"||" {return OR_OP;}
"&&" {return AND_OP;}
">>" {return RIGHT_OP;}
"<<"  {return LEFT_OP;}
"<=" {return LE_OP;}
">=" {return GE_OP;}
"==" {return EQ_OP;}
"!=" {return NE_OP;}
{DIGIT}+ {return INT_NR;}
{DIGIT}+"."{DIGIT}* {return FLOAT_NR;}

{WHITESPACE} /* sare peste spatii */
{NAME} {return VAR;}
{STRING} {return STRING;}
{LINE_COMMENT} {return LINE_COMMENT;}
{MULTILINE_COMMENT} {return MULTILINE_COMMENT;}

. {return ERR;} /* token necunoscut */
%%
