%{
    #include<stdio.h>
    #include "calc.tab.h"
%}

digit   [0-9]
num     {digit}+
alpha   [A-Za-z]
id      {alpha}({alpha}|{digit})*
white   [\ \t]

%%
LET     {return LET;}
DISP    {return DISP;}
{num}   {yylval.f = atoi(yytext);return NUM;}
{alpha} {yylval.c = yytext[0];return ID;}
[+\-\*/@\(\)=;]   {return yytext[0];}
\<=      {return LE;}
>=      {return GE;}
\<       {return LT;}
>       {return GT;}
==      {return EQ;}
!=      {return NE;}
{white} {}
\n      {}
%%

// int main(){
//     yylex();
// }