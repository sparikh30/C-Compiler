%{
#include <stdio.h>
#include "calc.tab.h"
int countlevel=0;
int line=0;
%}

%option yylineno

digit	([0-9])
ID      [a-z][a-zA-Z0-9]*
NonID	[0-9A-Z][0-9a-zA-Z]*

%%

"print"       { return(TOK_PRINTLN);}

"float" {return TOK_FLOAT; }

"main"	{ 	return(TOK_MAIN); }

"("		{	return(TOK_LEFTBRACE);}

")"		{	return(TOK_RIGHTBRACE);}

"{"		{countlevel++; return (TOK_LEFTCUR);	}

"}"		{ 
			countlevel--;
			return (TOK_RIGHTCUR);
		  	
		 }

"=" { 	return TOK_EQUALTO;	}


";"	{	return(TOK_SEMICOLON);	}

"+"	{	return(TOK_ADD);	}
"-"	{	return(TOK_SUB);	}
"*"	{	return(TOK_MUL);	}
"/"	{	return(TOK_DIV);	}

[ \n]	{line++;}
[ \t]	{}

{digit}+\.{digit}+  {
	sscanf(yytext, "%f", &(yylval.float_val));
	return TOK_FLOATNUM;
	}
	
{ID}+ 	{
		strcpy(yylval.id.name,yytext);
		yylval.id.val=0.0;
                yylval.id.level=countlevel;
		return TOK_IDENTIFIER;
        }
        
{NonID}	{
		 strcpy(yylval.nonid,yytext);	
		 return TOK_NONID;}
        
. { printf("Invalid character '%c', ignored\n",	yytext[0]);	}

%%
