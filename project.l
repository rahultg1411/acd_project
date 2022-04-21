%{
#include "y.tab.h"
%}

%%

"print"           {return print;}
"exit"            {return exit_cmd;}
[a-zA-Z]          {yylval.id = yytext[0]; return identifier;}
[0-9]*\.?[0-9]*   {yylval.num = atof(yytext); return number;}
[ \t\n]           ;   /* ignore any whitespace */ 
[-+*/=;]          {return yytext[0];}

%%

int yywrap(void) {
  return 1;
}