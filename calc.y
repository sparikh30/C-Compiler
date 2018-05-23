%{
#include <stdio.h>
#include<stdlib.h>
#include <string.h>
extern int countlevel;
extern int line;
int yyerror(char *s);
%}

%token TOK_SEMICOLON 
%token TOK_ADD
%token TOK_SUB
%token TOK_MUL
%token TOK_DIV
%token TOK_FLOATNUM
%token TOK_PRINTLN
%token TOK_MAIN
%token TOK_LEFTCUR
%token TOK_RIGHTCUR
%token TOK_LEFTBRACE
%token TOK_RIGHTBRACE
%token TOK_IDENTIFIER
%token TOK_FLOAT
%token TOK_EQUALTO
%token TOK_NONID

%union{
        float float_val;
        struct identifier id;
        char nonid[10];
}

%code requires {
        struct identifier
        {
                char name[100];
                float val;
                int level;;
        };
}

%code {
        struct identifier idarray[10000];
        int stack=0;
		int nest=0;
		int block[100];
		
		/*for(int a=0;a<100;a++)
		{
			block[a]=999;
		}
		*/
		
        struct identifier* retrieve(struct identifier id)
        {
                int k;
                for(k=stack;k>=0;k--){
                        if(!strcmp(id.name,idarray[k].name) && idarray[k].level==countlevel){
                                return &idarray[k];
                        }
                }
                return NULL;
        }


	 struct identifier* retrieve2(struct identifier id)
        {
                int k;
                for(k=stack;k>=0;k--){
                        if(!strcmp(id.name,idarray[k].name)){
                                return &idarray[k];
                        }
                }
                return NULL;
        }
}


%type <float_val> TOK_FLOATNUM
%type <id> TOK_IDENTIFIER
%type <id> expr
%type <nonid> TOK_NONID

%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV


%%

start: TOK_MAIN TOK_LEFTBRACE TOK_RIGHTBRACE TOK_LEFTCUR stmts TOK_RIGHTCUR
;

stmts : 
		| stmt TOK_SEMICOLON stmts

;
stmt : 
	| TOK_LEFTCUR stmts TOK_RIGHTCUR		{
											int x=0;
											while((countlevel)!=idarray[stack].level){
												//	printf("Stack: %d",stack);
												stack--;
											}	
										//	printf("hello\n");int k;
										/*	for(k=stack;k>=0;k--){
												printf("\nname: %s\t level: %d\t val:%f \t k:%d",idarray[k].name,idarray[k].level,idarray[k].val,k);	
											}
										*/			
									}
									
	| TOK_PRINTLN TOK_IDENTIFIER	{
										struct identifier *id = retrieve2($2);
										if(id)
										{
            			                    fprintf(stdout,"%.1f\n",id->val);
            		                    }
            				            else{
            			                    fprintf(stderr,"parsing error");
            			                    return -1;
            		                    }			
									}
									
	| TOK_FLOAT TOK_IDENTIFIER		{
						    struct identifier *id=retrieve($2);
                    				    struct identifier destid;
                   				    if(id)
 			 	                    {
             			                   	fprintf(stderr,"%s already defined.\n",id->name);
                    			            	return -1;
          					    }
        					           // stack++;
                					    strcpy(idarray[stack].name,$2.name);
                                                            idarray[stack++].level=countlevel;
						//	printf("name: %s \t level: %d val:%f \t stack:%d\n",idarray[stack-1].name,idarray[stack-1].level,idarray[stack-1].val,stack);							
									}	
	| TOK_FLOAT TOK_NONID			{
										printf("Lexical analysis error : %s",$2);
										return -1;
	
						}
	| TOK_IDENTIFIER TOK_EQUALTO expr	{
                 					       struct identifier *id=retrieve2($1);
             					           if(!id)
         					               {
                        			      	  fprintf(stderr,"%s parsing error.\n",$1.name);
                        			      	  return -1;
                     					   }
                           				   else
                            		          id->val = $3.val;
						                }
	
;

expr: 
	| TOK_IDENTIFIER		  {	struct identifier *id=retrieve2($1);
		                        if(!id)
                        		{	
                                	fprintf(stderr,"%s not defined.\n",$1.name);
                                    return -1;
		                        }
        		                $$ = *id;
        		              }
	| TOK_FLOATNUM			  {		$$.val = $1;	  	  }	 
	| expr TOK_ADD expr		  {		$$.val = $1.val + $3.val;	  }
	| expr TOK_SUB expr		  {		$$.val = $1.val - $3.val;	  }
	| expr TOK_MUL expr		  {		$$.val = $1.val * $3.val;	  }
	| expr TOK_DIV expr		  {		$$.val = $1.val / $3.val; 	  }
	
;


%%

int yyerror(char *s)
{
	printf("syntax error at line %d  \n",line);
	return 0;
}

int main()
{
   yyparse();
   return 0;
}

