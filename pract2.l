%{
#include <stdio.h>
#define DENTERO 1
#define AIDENTIFICADOR 2
#define VCADENA 3
#define IRESERVADA 4
#define DESPACIO 5
#define COMENTARIO 6
#define OPERADOR 7
#define ERROR 0
%}
letra [a-zA-Z]
digito [0-9]
operador [().+*-/~<:;{}]|<-|<=
espacio [ \n\v\r\t\f]
reservada class|if|then|else|while|do|od|case|of|new|isvoid|not|true|false
%x comentario1
%x comentario2
%%
{reservada}                                                 {ECHO;fwrite("  4\n",1,4,yyout);}
{digito}{digito}*                                           {ECHO;fwrite("  1\n",1,4,yyout);}
({digito}|{letra}|"_")({digito}|{letra}|"_")*               {ECHO;fwrite("  2\n",1,4,yyout);}
\"(.[^\0\\"])*\"                                            {ECHO;fwrite("  3\n",1,4,yyout);}
{espacio}{espacio}*                                         {ECHO;fwrite("  5\n",1,4,yyout);}
"/*"                                                        {ECHO;BEGIN(comentario1);}
<comentario1>[^*\n]*                                        ECHO;
<comentario1>"*"+[^*/\n]*                                   ECHO;
<comentario1>"*"+"/"                                        {ECHO;fwrite("  6\n",1,4,yyout);BEGIN(INITIAL);}
"//"(.)*                                                    {ECHO;fwrite("  6\n",1,4,yyout);}
{operador}                                                  {ECHO;fwrite("  7\n",1,4,yyout);}
.                                                           {ECHO;fwrite("  0 NO SE QUE SIMBOLO ES ESTO.\n",1,31,yyout);}
%%
int yywrap(){
    return 0;
}
int main(int argc, char *argv[]){
    yyin = fopen(argv[1],"r");
    yyout = fopen(argv[2],"w+");
    yylex();
    fclose(yyin);
    fclose(yyout);
    return 0;
}

//creo que es todo
