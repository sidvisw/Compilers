#include<stdio.h>

#define KEYWORD 258
#define IDENTIFIER 259
#define INTEGER_CONSTANT 260
#define FLOATING_CONSTANT 261
#define ENUMERATION_CONSTANT 262
#define CHARACTER_CONSTANT 263
#define STRING_LITERAL 264
#define PUNCTUATOR 265
#define MULTI_LINE_COMMENT_START 266
#define MULTI_LINE_COMMENT_END 267
#define SINGLE_LINE_COMMENT_START 268
#define SINGLE_LINE_COMMENT_END 269

extern int yylex();
extern char* yytext;
extern FILE* yyin;

int main(int argv, char ** argc){
    if(argv>1){
        if(!(yyin=fopen(argc[1],"r"))){
            printf("Error opening the file %s\n", argc[1]);
            return -1;
        }
    }

    FILE *fout;
    if(argv>2){
        fout = fopen(argc[2], "w");
        if(fout == NULL){
            printf("Error opening the file %s\n", argc[2]);
            return -1;
        }
    }
    int token;
    while((token=yylex())){
        switch (token)
        {
        case KEYWORD:
            printf("<KEYWORD, %s>\n", yytext);
            fprintf(fout,"<KEYWORD, %s>\n", yytext);
            break;
        
        case IDENTIFIER:
            printf("<ID, %s>\n", yytext);
            fprintf(fout, "<ID, %s>\n", yytext);
            break;
        
        case INTEGER_CONSTANT:
            printf("<INTEGER CONSTANT, %s>\n", yytext);
            fprintf(fout, "<INTEGER CONSTANT, %s>\n", yytext);
            break;
        
        case FLOATING_CONSTANT:
            printf("<FLOATING CONSTANT, %s>\n", yytext);
            fprintf(fout, "<FLOATING CONSTANT, %s>\n", yytext);
            break;
        
        case ENUMERATION_CONSTANT:
            printf("<ENUMERATION CONSTANT, %s>\n", yytext);
            fprintf(fout, "<ENUMERATION CONSTANT, %s>\n", yytext);
            break;
        
        case CHARACTER_CONSTANT:
            printf("<CHARACTER CONSTANT, %s>\n", yytext);
            fprintf(fout, "<CHARACTER CONSTANT, %s>\n", yytext);
            break;
        
        case STRING_LITERAL:
            printf("<STRING LITERAL, %s>\n", yytext);
            fprintf(fout, "<STRING LITERAL, %s>\n", yytext);
            break;
        
        case PUNCTUATOR:
            printf("<PUNCTUATION, %s>\n", yytext);
            fprintf(fout, "<PUNCTUATION, %s>\n", yytext);
            break;
        
        case MULTI_LINE_COMMENT_START:
            printf("<MULTI LINE COMMENT START, %s>\n", yytext);
            fprintf(fout, "<MULTI LINE COMMENT START, %s>\n", yytext);
            break;
        
        case MULTI_LINE_COMMENT_END:
            printf("<MULTI LINE COMMENT END, %s>\n", yytext);
            fprintf(fout, "<MULTI LINE COMMENT END, %s>\n", yytext);
            break;
        
        case SINGLE_LINE_COMMENT_START:
            printf("<SIGNLE LINE COMMENT START, %s>\n", yytext);
            fprintf(fout, "<SIGNLE LINE COMMENT START, %s>\n", yytext);
            break;
        
        case SINGLE_LINE_COMMENT_END:
            printf("<SINGLE LINE COMMENT END, \\n>\n");
            fprintf(fout, "<SINGLE LINE COMMENT END, \\n>\n");
            break;

        default:
            printf("<SYNTAX ERROR, %s>\n", yytext);
            fprintf(fout, "<SYNTAX ERROR, %s>\n", yytext);
        }
    }
    return 0;
}