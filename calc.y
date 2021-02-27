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
    int lineno=1;
%}

%union{
    float f;
    char c;
    // int 
}

%token LET DISP LT LE GT GE EQ NE
%token <f> NUM
%token <c> ID
%type <f> S E T F G P Q R

%%

C   :   S ';'       
    |   C S ';'     
    ;

S   :   DISP E      {printf("%f\n",$2);}
    |   LET ID '=' E    {fprintf(debug,"%c = %f\n",$2,$4);symbolTable[$2]=$4;}
    |   E           {result = $$;}
    |               {}
    ;

E   :   P '?' P ':' P {$$ = $1 ? $3 : $5;}
    |   P           {$$ = $1;}
    ;

P   :   P LT Q      {$$ = $1<$3;}
    |   P GT Q      {$$ = $1>$3;}
    |   P LE Q      {$$ = $1<=$3;}
    |   P GE Q      {$$ = $1>=$3;}
    |   Q           {$$ = $1;}
    ;

Q   :   Q EQ R      {$$ = $1==$3;}
    |   Q NE R      {$$ = $1!=$3;}
    |   R           {$$ = $1;}
    ;

R   :   R '+' T     {$$ = $1+$3;}
    |   R '-' T     {$$ = $1-$3;}
    |   T           {$$ = $1;}
    ;

T   :   T '*' F     {$$ = $1*$3;}
    |   T '/' F     {
                        if($3==0){
                            printf("At line no %d, Divide By zero error!!!",lineno);
                            exit(0);
                        }
                        $$ = $1/$3;
                    }
    |   F           {$$ = $1;}
    ; 

F   :   G '@' F     {fprintf(debug,"4\n");$$ = pow($1,$3);}
    |   G           {fprintf(debug,"3\n");$$ = $1;}
    ;

G   :   '(' E ')'   {$$ = $2;}
    |   ID          {$$ = symbolTable[$1];}
    |   NUM         {$$ = $1;}
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