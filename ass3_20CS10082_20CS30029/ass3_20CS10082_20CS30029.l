/* DECLARATIONS */
%{
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
%}

/* Defining Start Condtion States */
%x MULTI_LINE_COMMENT
%x SINGLE_LINE_COMMENT

/* Regular Expression Definitions */
KEYWORD	"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"

IDENTIFIER_NONDIGIT [a-zA-Z_]

DIGIT [0-9]

IDENTIFIER	{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

NONZERO_DIGIT [1-9]

INTEGER_CONSTANT	{NONZERO_DIGIT}{DIGIT}*|0

DIGIT_SEQUENCE	{DIGIT}+

FRACTINAL_CONSTANT	({DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}\.)

SIGN	[+-]

EXPONENT_PART	[eE]{SIGN}?{DIGIT_SEQUENCE}

FLOATING_CONSTANT	({FRACTINAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})

ENUMERATION_CONSTANT	{IDENTIFIER}

ESCAPE_SEQUENCE	\\[\'\"?\\abfnrtv]

C_CHAR	[^\'\\\n]|{ESCAPE_SEQUENCE}

C_CHAR_SEQUENCE	{C_CHAR}+

CHARACTER_CONSTANT	\'{C_CHAR_SEQUENCE}\'

CONSTANT	{INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{ENUMERATION_CONSTANT}|{CHARACTER_CONSTANT}

S_CHAR	[^\"\\\n]|{ESCAPE_SEQUENCE}

S_CHAR_SEQUENCE	{S_CHAR}+

STRING_LITERAL	\"{S_CHAR_SEQUENCE}?\"

PUNCTUATOR	"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

WHITESPACE	[ \t\n]

/* Defining the return values according to the token scanned */
%%
{KEYWORD}	{return KEYWORD;}

{IDENTIFIER}	{return IDENTIFIER;}

{PUNCTUATOR}	{return PUNCTUATOR;}

{INTEGER_CONSTANT}	{return INTEGER_CONSTANT;}

{FLOATING_CONSTANT}	{return FLOATING_CONSTANT;}

{CHARACTER_CONSTANT}	{return CHARACTER_CONSTANT;}

{STRING_LITERAL}	{return STRING_LITERAL;}

{WHITESPACE}	/*White-space Rule*/;

"/*"	{BEGIN(MULTI_LINE_COMMENT); return MULTI_LINE_COMMENT_START;}
<MULTI_LINE_COMMENT>.|\n	/*Do nothing*/;
<MULTI_LINE_COMMENT>"*/"	{BEGIN(INITIAL); return MULTI_LINE_COMMENT_END;}

"//"	{BEGIN(SINGLE_LINE_COMMENT); return SINGLE_LINE_COMMENT_START;}
<SINGLE_LINE_COMMENT>.	/*Do nothing*/;
<SINGLE_LINE_COMMENT>\n	{BEGIN(INITIAL); return SINGLE_LINE_COMMENT_END;}
%%