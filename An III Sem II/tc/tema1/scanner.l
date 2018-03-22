%option yylineno

%{
#include <stdio.h>

void to_s(char *token_name, char *token_info, int line_numer);
%}

WHITESPACE [ \t\n]+
DIGIT [0-9]
ALPHA [a-zA-Z]
STRING \"[^\n]+\"
NAME ({ALPHA}|{DIGIT}|[_])+
LINE_COMMENT [/][/](.*)
MULTILINE_COMMENT ([/][\*])(((.*)\n(.*))*)([\*][/])

%%
"#include".* {to_s(yytext, "include", yylineno);}
"main" {to_s(yytext, "main", yylineno);}
"return" {to_s(yytext, "return", yylineno);}
"struct" {to_s(yytext, "struct", yylineno);}
"unsigned" {to_s(yytext, "unsigned", yylineno);}
"short" {to_s(yytext, "short", yylineno);}
"int" {to_s(yytext, "int", yylineno);}
"long" {to_s(yytext, "long", yylineno);}
"char" {to_s(yytext, "char", yylineno);}
"float" {to_s(yytext, "float", yylineno);}
"bool" {to_s(yytext, "bool", yylineno);}
"const" {to_s(yytext, "const", yylineno);}
"break" {to_s(yytext, "break", yylineno);}
"continue" {to_s(yytext, "continue", yylineno);}
"for" {to_s(yytext, "for", yylineno);}
"while" {to_s(yytext, "while", yylineno);}
"do" {to_s(yytext, "do", yylineno);}
"if" {to_s(yytext, "if", yylineno);}
"else" {to_s(yytext, "else", yylineno);}
"true" {to_s(yytext, "true", yylineno);}
"false" {to_s(yytext, "false", yylineno);}

";" {to_s(yytext, "semicolon", yylineno);}
":" {to_s(yytext, "colon", yylineno);}
"(" {to_s(yytext, "open paranthesis", yylineno);}
")" {to_s(yytext, "closed paranthesis", yylineno);}
"[" {to_s(yytext, "open square paranthesis", yylineno);}
"]" {to_s(yytext, "closed square paranthesis", yylineno);}
"{" {to_s(yytext, "open bracket", yylineno);}
"}" {to_s(yytext, "closed bracket", yylineno);}
"=" {to_s(yytext, "equal", yylineno);}
">" {to_s(yytext, "greater than", yylineno);}
"<" {to_s(yytext, "less than", yylineno);}
"," {to_s(yytext, "comma", yylineno);}
"." {to_s(yytext, "point", yylineno);}
"+" {to_s(yytext, "plus", yylineno);}
"-" {to_s(yytext, "minus", yylineno);}
"/" {to_s(yytext, "slash", yylineno);}
"*" {to_s(yytext, "star", yylineno);}
"%" {to_s(yytext, "percent", yylineno);}
"&" {to_s(yytext, "ampersand", yylineno);}
"|" {to_s(yytext, "bar", yylineno);}
"!" {to_s(yytext, "exclamation mark", yylineno);}
"?" {to_s(yytext, "question mark", yylineno);}
"^" {to_s(yytext, "caret", yylineno);}
"~" {to_s(yytext, "tilda", yylineno);}
{DIGIT}+ {to_s(yytext, "int number", yylineno);}
{DIGIT}+"."{DIGIT}* {to_s(yytext, "float number", yylineno);}

{WHITESPACE} /* sare peste spatii */
{NAME} {to_s(yytext, "name", yylineno);}
{STRING} {to_s(yytext, "string", yylineno);}
{LINE_COMMENT} {to_s(yytext, "comment", yylineno);}
{MULTILINE_COMMENT} {to_s(yytext, "comment", yylineno);}

. {to_s(yytext, "undefined character", yylineno);} /* token necunoscut */
%%

void to_s(char *token_name, char *token_info, int line_numer) {
  printf("Line %d: token -%s- | info -%s-.\n", line_numer, token_name, token_info);
}

int main(int argc, char **argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
  }

  yylex();
  return 0;
}
