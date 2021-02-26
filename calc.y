%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<math.h>

    extern int yylex();
    extern FILE *yyin,*yyout;

    FILE* debug;

    // extern double power(double a,double b);
    int yyerror(char* msg);

    // unordered_map<string,float> symbolTable;
    float symbolTable[256];
    float result;
%}

%union{
    float f;
    char c;
    // int 
}

%token LET DISP LT LE GT GE EQ NE IF
%token <f> NUM
%token <c> ID
%type <f> S E T F G Q R

%%

C   :   S ';'
    |   C S ';'
    ;

S   :   DISP E    {fprintf(debug,"14\n");printf("%f\n",$2);}
    |   IF E '{' C     {fprintf(debug,"13\n");fprintf(debug,"%c = %f\n",$2,$4);symbolTable[$2]=$4;}
    |   LET ID '=' E    {fprintf(debug,"13\n");fprintf(debug,"%c = %f\n",$2,$4);symbolTable[$2]=$4;}
    |   E           {fprintf(debug,"12\n");result = $$;}
    ;

E   :   E LT Q     {fprintf(debug,"11\n");$$ = $1<$3;}
    |   E GT Q     {fprintf(debug,"10\n");$$ = $1>$3;}
    |   E LE Q     {fprintf(debug,"10\n");$$ = $1<=$3;}
    |   E GE Q     {fprintf(debug,"10\n");$$ = $1>=$3;}
    |   Q          {fprintf(debug,"9\n");$$ = $1;}
    ;

Q   :   Q EQ R     {fprintf(debug,"11\n");$$ = $1==$3;}
    |   Q NE R     {fprintf(debug,"10\n");$$ = $1!=$3;}
    |   R          {fprintf(debug,"9\n");$$ = $1;}
    ;

R   :   R '+' T     {fprintf(debug,"11\n");$$ = $1+$3;}
    |   R '-' T     {fprintf(debug,"10\n");$$ = $1-$3;}
    |   T           {fprintf(debug,"9\n");$$ = $1;}
    ;

T   :   T '*' F     {fprintf(debug,"7\n");$$ = $1*$3;}
    |   T '/' F     {fprintf(debug,"6\n");$$ = $1/$3;}
    |   F           {fprintf(debug,"5\n");$$ = $1;}
    ; 

F   :   G '@' F     {fprintf(debug,"4\n");$$ = pow($1,$3);}
    |   G           {fprintf(debug,"3\n");$$ = $1;}
    ;

G   :   '(' E ')'   {fprintf(debug,"2\n");$$ = $2;}
    |   ID          {fprintf(debug,"8\n");$$ = symbolTable[$1];}
    |   NUM         {fprintf(debug,"1\n");$$ = $1;}
    ;

%%

int yyerror(char* msg){
    perror(msg);
    exit(1);
}

// float power(float a,float b){
//     return pow(a,b);
// }

int main(){
    extern int yydebug;
    yydebug = 1;
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    debug = fopen("debug.txt","w");

    yyparse();

    printf("\n");
    // printf("%f",result);
    // printPost(T);
    return 0;
}