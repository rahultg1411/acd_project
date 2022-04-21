%{

#include <stdio.h>   
#include <stdlib.h>   // printf() fprintf()
#include <ctype.h>      // isupper() islower()
int yylex();
double symbol_table[52];

double getSymbolValue(char symbol);
void setSymbolValue(char symbol, double value);
void yyerror(char* s);

%}

%union {double num; char id;}
%start line
%token print
%token exit_cmd
%token <num> number
%token <id> identifier
%type <num> line expr term
%type <id> assignment


%%


line        :   assignment ';'            {;}
            |   exit_cmd ';'              {exit(EXIT_SUCCESS);}
            |   print expr ';'            {printf(">> %f\n", $2);}
            |   line assignment ';'       {;}
            |   line print expr ';'       {printf(">> %f\n", $3);}
            |   line exit_cmd ';'         {exit(EXIT_SUCCESS);}
            ;

assignment  :   identifier '=' expr       {setSymbolValue($1, $3);}
            ;

expr        :   term                      {$$ = $1;}
            |   expr '+' term             {$$ = $1 + $3;}
            |   expr '-' term             {$$ = $1 - $3;}
            |   expr '*' term             {$$ = $1 * $3;}
            |   expr '/' term             {$$ = $1 / $3;}
            ;

term        :   number                    {$$ = $1;}
            |   identifier                {$$ = getSymbolValue($1);}
            ;


%%


int getSymbolIndex(char symbol)
{
  int idx = -1;
  
  if(islower(symbol))
    idx = symbol - 'a' + 26;
  else if(isupper(symbol))
    idx = symbol - 'A';
  
  return idx;
}

double getSymbolValue(char symbol)
{
  int symbol_idx = getSymbolIndex(symbol);
  return symbol_table[symbol_idx];
}

void setSymbolValue(char symbol, double value)
{
  int symbol_idx = getSymbolIndex(symbol);
  symbol_table[symbol_idx] = value;
}

int main(void)
{
  int i;
  for(i=0; i<52; ++i)
    symbol_table[i] = 0.0;
  
  return yyparse();
}

void yyerror(char* s)
{
  fprintf(stderr, "%s\n", s);
}