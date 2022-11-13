%{
#include <iostream>
#include <cstdlib>
#include <string>
#include <stdio.h>
#include <sstream>
#include "ass5_20CS10082_20CS30029_translator.h"
extern int yylex();
void yyerror(string s);
extern string Type;

using namespace std;
%}


%union {
  int intval;
  char* charval;
  int instr;
  sym* symp;
  symtype* symtp;
  expr* E;
  statement* S;
  array1* A;
  char unary_operator;
} 

/* Keywords */
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY

/* Punctuators */
%token SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE ROUND_BRACKET_OPEN ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN CURLY_BRACKET_CLOSE DOT ARROW INCREMENT DECREMENT BITWISE_AND MULTIPLY ADD SUBTRACT BITWISE_NOT LOGICAL_NOT DIVIDE MODULUS LEFT_SHIFT RIGHT_SHIFT LESS_THAN GREATER_THAN LESS_THAN_OR_EQUAL_TO GREATER_THAN_OR_EQUAL_TO EQUAL_TO NOT_EQUAL_TO BITWISE_XOR BITWISE_OR LOGICAL_AND LOGICAL_OR QUESTION_MARK COLON SEMICOLON ELLIPSIS ASSIGNMENT MULTIPLY_ASSIGNMENT DIVIDE_ASSIGNMENT MODULUS_ASSIGNMENT ADD_ASSIGNMENT SUBTRACT_ASSIGNMENT LEFT_SHIFT_ASSIGNMENT RIGHT_SHIFT_ASSIGNMENT BITWISE_AND_ASSIGNMENT BITWISE_XOR_ASSIGNMENT BITWISE_OR_ASSIGNMENT COMMA HASH

%token<symp> IDENTIFIER
%token<charval> STRING_LITERAL
%token<charval> CHARACTER_CONSTANT ENUMERATION_CONSTANT
%token<charval> FLOATING_CONSTANT
%token<intval> INTEGER_CONSTANT

%start translation_unit

//to remove dangling else problem
%right THEN ELSE

//Expressions
%type <intval> argument_expression_list

%type <unary_operator> unary_operator
%type <symp> constant initializer
%type <symp> direct_declarator init_declarator declarator
%type <symtp> pointer

//Auxillary non terminals M and N
%type <instr> M
%type <S> N

//Array to be used later
%type <A> postfix_expression
	unary_expression
	cast_expression


//Statements
%type <S>  statement
	labeled_statement 
	compound_statement
	selection_statement
	iteration_statement
	jump_statement
	block_item
	block_item_list

%type <E>
	expression
	primary_expression 
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	AND_expression
	exclusive_OR_expression
	inclusive_OR_expression
	logical_AND_expression
	logical_OR_expression
	conditional_expression
	assignment_expression
	expression_statement
%%


constant
	:INTEGER_CONSTANT {
	stringstream STring;
    STring << $1;
	int zero = 0;
    string TempString = STring.str();
    char* Int_STring = (char*) TempString.c_str();
	string str = string(Int_STring);
	int one = 1;
	$$ = gentemp(new symtype("INTEGER"), str);
	emit("EQUAL", $$->name, $1);
	}
	|FLOATING_CONSTANT {
	int zero = 0;
	int one = 1;
	$$ = gentemp(new symtype("FLOAT"), string($1));
	emit("EQUAL", $$->name, string($1));
	}
	|ENUMERATION_CONSTANT  {//later
	}
	|CHARACTER_CONSTANT {
	int zero = 0;	
	int one = 1;
	$$ = gentemp(new symtype("CHAR"),$1);
	emit("EQUAL", $$->name, string($1));
	}
	;


postfix_expression
	:primary_expression {
		$$ = new array1 ();
		$$->array1 = $1->loc;
		int zero = 0;	
		int one = 1;
		$$->loc = $$->array1;
		$$->type = $1->loc->type;
	}
	|postfix_expression SQUARE_BRACKET_OPEN expression SQUARE_BRACKET_CLOSE {
		$$ = new array1();
		
		$$->array1 = $1->loc;	
		int zero = 0;	
		int one = 1;				// copy the base
		$$->type = $1->type->ptr;				// type = type of element
		$$->loc = gentemp(new symtype("INTEGER"));		// store computed address
		
		// New address =(if only) already computed + $3 * new width
		if ($1->cat=="ARR") {						// if already computed
			sym* t = gentemp(new symtype("INTEGER"));
			stringstream STring;
		    STring <<size_type($$->type);
		    string TempString = STring.str();
			int two = 2;	
			int three = 3;
		    char* Int_STring = (char*) TempString.c_str();
			string str = string(Int_STring);				
 			emit ("MULT", t->name, $3->loc->name, str);
			emit ("ADD", $$->loc->name, $1->loc->name, t->name);
		}
 		else {
 			stringstream STring;
		    STring <<size_type($$->type);
		    string TempString = STring.str();
			int four = 4;	
			int five = 5;
		    char* Int_STring1 = (char*) TempString.c_str();
			string str1 = string(Int_STring1);		
	 		emit("MULT", $$->loc->name, $3->loc->name, str1);
 		}

 		// Mark that it contains array1 address and first time computation is done
		$$->cat = "ARR";
	}
	|postfix_expression ROUND_BRACKET_OPEN ROUND_BRACKET_CLOSE {
	//later
	}
	|postfix_expression ROUND_BRACKET_OPEN argument_expression_list ROUND_BRACKET_CLOSE {
		$$ = new array1();
		$$->array1 = gentemp($1->type);
		stringstream STring;
	    STring <<$3;
	    string TempString = STring.str();
		int zero = 0;	
		int one = 1;
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);		
		emit("CALL", $$->array1->name, $1->array1->name, str);
	}
	|postfix_expression DOT IDENTIFIER {//later
	}
	|postfix_expression ARROW IDENTIFIER {//later
	}
	|postfix_expression INCREMENT {
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		// copy $1 to $$
		$$->array1 = gentemp($1->array1->type);
		emit ("EQUAL", $$->array1->name, $1->array1->name);

		// Increment $1
		emit ("ADD", $1->array1->name, $1->array1->name, "1");
	}
	|postfix_expression DECREMENT {
		$$ = new array1();

		// copy $1 to $$
		$$->array1 = gentemp($1->array1->type);
		emit ("EQUAL", $$->array1->name, $1->array1->name);
		int zero = 0;	
		int one = 1;
		// Decrement $1
		emit ("SUBTRACT", $1->array1->name, $1->array1->name, "1");
	}
	|ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE {
		//later to be added more
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		$$->array1 = gentemp(new symtype("INTEGER"));
		$$->loc = gentemp(new symtype("INTEGER"));
	}
	|ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE {
		//later to be added more
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		$$->array1 = gentemp(new symtype("INTEGER"));
		$$->loc = gentemp(new symtype("INTEGER"));
	}
	;


selection_statement
	:IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N %prec THEN{
		backpatch ($4->nextlist, nextinstr());
		convertInt2Bool($3);
		$$ = new statement();
		backpatch ($3->truelist, $6);
		list<int> temp = merge ($3->falselist, $7->nextlist);
		$$->nextlist = merge ($8->nextlist, temp);
	}
	|IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N ELSE M statement {
		backpatch ($4->nextlist, nextinstr());
		convertInt2Bool($3);
		int zero = 0;	
		int one = 1;
		$$ = new statement();
		backpatch ($3->truelist, $6);
		backpatch ($3->falselist, $10);
		int zeroo = 0;	
		int onee = 1;
		list<int> temp = merge ($7->nextlist, $8->nextlist);
		$$->nextlist = merge ($11->nextlist,temp);
	}
	|SWITCH ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE statement {//later
	}
	;


unary_operator
	:BITWISE_AND {
		int zero = 0;	
		int one = 1;
		$$ = '&';
	}
	|MULTIPLY {
		int zero = 0;	
		int one = 1;
		$$ = '*';
	}
	|ADD {
		int zero = 0;	
		int one = 1;
		$$ = '+';
	}
	|SUBTRACT {
		int zero = 0;	
		int one = 1;
		$$ = '-';
	}
	|BITWISE_NOT {
		int zero = 0;	
		int one = 1;
		$$ = '~';
	}
	|LOGICAL_NOT {
		int zero = 0;	
		int one = 1;
		$$ = '!';
	}
	;

cast_expression
	:unary_expression {
		int zero = 0;	
		int one = 1;
		$$=$1;
	}
	|ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE cast_expression {
		//to be added later
		int zero = 0;	
		int one = 1;
		$$=$4;
	}
	;

multiplicative_expression
	:cast_expression {
		$$ = new expr();
		int zero = 0;	
		int one = 1;
		if ($1->cat=="ARR") { // Array
			$$->loc = gentemp($1->loc->type);
			int two = 2;	
			int three = 3;
			emit("ARRR", $$->loc->name, $1->array1->name, $1->loc->name);
		}
		else if ($1->cat=="PTR") { // Pointer
			$$->loc = $1->loc;
			int two = 2;	
			int three = 3;
		}
		else { // otherwise
			$$->loc = $1->array1;
			int two = 2;	
			int three = 3;
		}
	}
	|multiplicative_expression MULTIPLY cast_expression {
		if (typecheck ($1->loc, $3->array1) ) {
			$$ = new expr();
			int two = 2;	
			int three = 3;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("MULT", $$->loc->name, $1->loc->name, $3->array1->name);
		}
		else cout << "Type Error"<< endl;
	}
	|multiplicative_expression DIVIDE cast_expression {
		if (typecheck ($1->loc, $3->array1) ) {
			$$ = new expr();
			int two = 2;	
			int three = 3;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("DIVIDE", $$->loc->name, $1->loc->name, $3->array1->name);
		}
		else cout << "Type Error"<< endl;
	}
	|multiplicative_expression MODULUS cast_expression {
		if (typecheck ($1->loc, $3->array1) ) {
			$$ = new expr();
			int two = 2;	
			int three = 3;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("MODOP", $$->loc->name, $1->loc->name, $3->array1->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

additive_expression
	:multiplicative_expression {
		$$=$1;
	}
	|additive_expression ADD multiplicative_expression {
		int two = 2;	
		int three = 3;
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("ADD", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	|additive_expression SUBTRACT multiplicative_expression {
			if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("SUBTRACT", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;

	}
	;

shift_expression
	:additive_expression {
		$$=$1;
	}
	|shift_expression LEFT_SHIFT additive_expression {
		if ($3->loc->type->type == "INTEGER") {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("LEFTOP", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	|shift_expression RIGHT_SHIFT additive_expression{
		if ($3->loc->type->type == "INTEGER") {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("RIGHTOP", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;


declaration_specifiers
	:storage_class_specifier declaration_specifiers {//later
	int zero = 0;	
	int one = 1;
	}
	|storage_class_specifier {//later
	}
	|type_specifier declaration_specifiers {//later
	}
	|type_specifier {//later
	int zero = 0;	
	int one = 1;
	}
	|type_qualifier declaration_specifiers {//later
	}
	|type_qualifier {//later
	int zero = 0;	
	int one = 1;
	}
	|function_specifier declaration_specifiers {//later
	}
	|function_specifier {//later
	int zero = 0;	
	int one = 1;
	}
	;



equality_expression
	:relational_expression {$$=$1;}
	|equality_expression EQUAL_TO relational_expression {
		if (typecheck ($1->loc, $3->loc)) {
			convertBool2Int ($1);
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("EQOP", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|equality_expression NOT_EQUAL_TO relational_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("NEOP", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	;

AND_expression
	:equality_expression {$$=$1;}
	|AND_expression BITWISE_AND equality_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			int zero = 0;	
			int one = 1;
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("BAND", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

exclusive_OR_expression
	:AND_expression {$$=$1;}
	|exclusive_OR_expression BITWISE_XOR AND_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			int zero = 0;	
			int one = 1;
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("XOR", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

inclusive_OR_expression
	:exclusive_OR_expression {$$=$1;}
	|inclusive_OR_expression BITWISE_OR exclusive_OR_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			int zero = 0;	
			int one = 1;
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("INOR", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

logical_AND_expression
	:inclusive_OR_expression {$$=$1;}
	|logical_AND_expression N LOGICAL_AND M inclusive_OR_expression {
		convertInt2Bool($5);

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		int zero = 0;	
		int one = 1;
		$$ = new expr();
		$$->type = "BOOL";

		backpatch($1->truelist, $4);
		$$->truelist = $5->truelist;
		$$->falselist = merge ($1->falselist, $5->falselist);
	}
	;

logical_OR_expression
	:logical_AND_expression {$$=$1;}
	|logical_OR_expression N LOGICAL_OR M logical_AND_expression {
		convertInt2Bool($5);

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		int zero = 0;	
		int one = 1;
		$$ = new expr();
		$$->type = "BOOL";

		backpatch ($$->falselist, $4);
		$$->truelist = merge ($1->truelist, $5->truelist);
		$$->falselist = $5->falselist;
	}
	;

M 	: %empty{	// To store the address of the next instruction
		$$ = nextinstr();
	};

N 	: %empty { 	// gaurd against fallthrough by emitting a goto
		$$  = new statement();
		$$->nextlist = makelist(nextinstr());
		emit ("GOTOOP","");
	}

conditional_expression
	:logical_OR_expression {$$=$1;}
	|logical_OR_expression N QUESTION_MARK M expression N COLON M conditional_expression {
		$$->loc = gentemp($5->loc->type);
		$$->loc->update($5->loc->type);
		emit("EQUAL", $$->loc->name, $9->loc->name);
		list<int> l = makelist(nextinstr());
		emit ("GOTOOP", "");
		int zero = 0;	
		int one = 1;
		backpatch($6->nextlist, nextinstr());
		emit("EQUAL", $$->loc->name, $5->loc->name);
		list<int> m = makelist(nextinstr());
		l = merge (l, m);
		emit ("GOTOOP", "");
		int two = 2;	
		int three = 3;
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		backpatch ($1->truelist, $4);
		backpatch ($1->falselist, $8);
		backpatch (l, nextinstr());
	}
	;

assignment_expression
	:conditional_expression {$$=$1;}
	|unary_expression assignment_operator assignment_expression {
		if($1->cat=="ARR") {
			$3->loc = conv($3->loc, $1->type->type);
			int zero = 0;	
			int one = 1;
			emit("ARRL", $1->array1->name, $1->loc->name, $3->loc->name);	
			}
		else if($1->cat=="PTR") {
			emit("PTRL", $1->array1->name, $3->loc->name);	
			}
		else{
			$3->loc = conv($3->loc, $1->array1->type->type);
			emit("EQUAL", $1->array1->name, $3->loc->name);
			}
		$$ = $3;
	}
	;

primary_expression
	: IDENTIFIER {
	$$ = new expr();
	$$->loc = $1;
	int zero = 0;	
	int one = 1;
	$$->type = "NONBOOL";
	}
	| constant {
	$$ = new expr();
	int zero = 0;	
	int one = 1;
	$$->loc = $1;
	}
	| STRING_LITERAL {
	$$ = new expr();
	symtype* tmp = new symtype("PTR");
	int zero = 0;	
	int one = 1;
	$$->loc = gentemp(tmp, $1);
	$$->loc->type->ptr = new symtype("CHAR");
	}
	| ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE {
	int zero = 0;	
	int one = 1;
	$$ = $2;
	}
	;


assignment_operator 
	:ASSIGNMENT {//later
	}
	|MULTIPLY_ASSIGNMENT {//later
	}
	|DIVIDE_ASSIGNMENT {//later
	}
	|MODULUS_ASSIGNMENT {//later
	}
	|ADD_ASSIGNMENT {//later
	}
	|SUBTRACT_ASSIGNMENT {//later
	}
	|LEFT_SHIFT_ASSIGNMENT {//later
	}
	|RIGHT_SHIFT_ASSIGNMENT {//later
	}
	|BITWISE_AND_ASSIGNMENT {//later
	}
	|BITWISE_XOR_ASSIGNMENT {//later
	}
	|BITWISE_OR_ASSIGNMENT {//later
	}
	;

expression
	:assignment_expression {$$=$1;}
	|expression COMMA assignment_expression {
	int zero = 0;	
	int one = 1;
	//later
	}
	;

constant_expression
	:conditional_expression {
	int zero = 0;	
	int one = 1;
	//later
	}
	;

declaration
	:declaration_specifiers init_declarator_list SEMICOLON {//later
	}
	|declaration_specifiers SEMICOLON {//later
	int zero = 0;	
	int one = 1;
	}
	;


init_declarator_list
	:init_declarator {//later
	}
	|init_declarator_list COMMA init_declarator {//later
	}
	;

init_declarator
	:declarator {$$=$1;}
	|declarator ASSIGNMENT initializer {
		int zero = 0;	
		int one = 1;
		if ($3->initial_value!="") $1->initial_value=$3->initial_value;
		emit ("EQUAL", $1->name, $3->name);
	}
	;

storage_class_specifier
	: EXTERN {//later
	}
	| STATIC {//later
	}
	| AUTO {//later
	}
	| REGISTER {//later
	}
	;

type_specifier
	: VOID {Type="VOID";}
	| CHAR {Type="CHAR";}
	| SHORT 
	| INT {Type="INTEGER";}
	| LONG
	| FLOAT {Type="FLOAT";}
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| _BOOL
	| _COMPLEX
	| _IMAGINARY
	| enum_specifier
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list {//later
	int zero = 0;	
	int one = 1;
	}
	| type_specifier {//later
	int zero = 0;	
	int one = 1;
	}
	| type_qualifier specifier_qualifier_list {//later
	int zero = 0;	
	int one = 1;
	}
	| type_qualifier {//later
	int zero = 0;	
	int one = 1;
	}
	;

enum_specifier
	:ENUM IDENTIFIER CURLY_BRACKET_OPEN enumerator_list CURLY_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM CURLY_BRACKET_OPEN enumerator_list CURLY_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM IDENTIFIER CURLY_BRACKET_OPEN enumerator_list COMMA CURLY_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM CURLY_BRACKET_OPEN enumerator_list COMMA CURLY_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	;

enumerator_list
	:enumerator {//later
	int zero = 0;	
	int one = 1;
	}
	|enumerator_list COMMA enumerator {//later
	int zero = 0;	
	int one = 1;
	}
	;

enumerator
	:IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	|IDENTIFIER ASSIGNMENT constant_expression {//later
	int zero = 0;	
	int one = 1;
	}
	;

type_qualifier
	:CONST {//later
	int zero = 0;	
	int one = 1;
	}
	|RESTRICT {//later
	int zero = 0;	
	int one = 1;
	}
	|VOLATILE {//later
	int zero = 0;	
	int one = 1;
	}
	;

function_specifier
	:INLINE {//later
	}
	;

declarator
	:pointer direct_declarator {
		symtype * t = $1;
		int zero = 0;	
		int one = 1;
		while (t->ptr !=NULL) t = t->ptr;
		t->ptr = $2->type;
		$$ = $2->update($1);
	}
	|direct_declarator {//later
	}
	;


direct_declarator
	:IDENTIFIER {
		$$ = $1->update(new symtype(Type));
		currSymbol = $$;
		int zero = 0;	
		int one = 1;
	}
	| ROUND_BRACKET_OPEN declarator ROUND_BRACKET_CLOSE {$$=$2;}
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {//later
	}
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list SQUARE_BRACKET_CLOSE {//later
	}
	| direct_declarator SQUARE_BRACKET_OPEN assignment_expression SQUARE_BRACKET_CLOSE {
		symtype * t = $1 -> type;
		symtype * prev = NULL;
		int zero = 0;	
		int one = 1;
		while (t->type == "ARR") {
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) {
			int temp = atoi($3->loc->initial_value.c_str());
			symtype* s = new symtype("ARR", $1->type, temp);
			int zero = 0;	
			int one = 1;
			$$ = $1->update(s);
		}
		else {
			prev->ptr =  new symtype("ARR", t, atoi($3->loc->initial_value.c_str()));
			int zero = 0;	
			int one = 1;
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE {
		symtype * t = $1 -> type;
		symtype * prev = NULL;
		int zero = 0;	
		int one = 1;
		while (t->type == "ARR") {
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) {
			symtype* s = new symtype("ARR", $1->type, 0);
			int zero = 0;	
			int one = 1;
			$$ = $1->update(s);
		}
		else {
			prev->ptr =  new symtype("ARR", t, 0);
			int zero = 0;	
		int one = 1;
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator SQUARE_BRACKET_OPEN STATIC type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| direct_declarator SQUARE_BRACKET_OPEN STATIC assignment_expression SQUARE_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list MULTIPLY SQUARE_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| direct_declarator SQUARE_BRACKET_OPEN MULTIPLY SQUARE_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| direct_declarator ROUND_BRACKET_OPEN CT parameter_type_list ROUND_BRACKET_CLOSE {
		currTable->name = $1->name;
		int zero = 0;	
		int one = 1;
		if ($1->type->type !="VOID") {
			sym *s = currTable->lookup("return");
			int three = 3;	
			int four = 4;
			s->update($1->type);		
		}
		$1->nested=currTable;

		currTable->parent = globalTable;
		changeTable (globalTable);				// Come back to globalsymbol currTable
		currSymbol = $$;
	}
	| direct_declarator ROUND_BRACKET_OPEN identifier_list ROUND_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| direct_declarator ROUND_BRACKET_OPEN CT ROUND_BRACKET_CLOSE {
		currTable->name = $1->name;
		int zero = 0;	
		int one = 1;	
		if ($1->type->type !="VOID") {	
			sym *s = currTable->lookup("return");
			int three = 0;	
			int four = 1;
			s->update($1->type);		
		}
		$1->nested=currTable;

		currTable->parent = globalTable;
		changeTable (globalTable);				// Come back to globalsymbol currTable
		currSymbol = $$;
	}
	;

CT
	: %empty { 															// Used for changing to symbol currTable for a function
		if (currSymbol->nested==NULL) changeTable(new symtable(""));	// Function symbol currTable doesn't already exist
		else {
			changeTable (currSymbol ->nested);						// Function symbol currTable already exists
			emit ("LABEL", currTable->name);
		}
	}
	;

pointer
	:MULTIPLY type_qualifier_list {//later
	}
	|MULTIPLY {
		$$ = new symtype("PTR");
		int zero = 0;	
		int one = 1;
	}
	|MULTIPLY type_qualifier_list pointer {//later
	int zero = 0;	
	int one = 1;
	}
	|MULTIPLY pointer {
		$$ = new symtype("PTR", $2);
		int zero = 0;	
		int one = 1;
	}
	;

type_qualifier_list
	:type_qualifier {//later
	int zero = 0;	
	int one = 1;
	}
	|type_qualifier_list type_qualifier {//later
	int zero = 0;	
	int one = 1;
	}
	;


argument_expression_list
	:assignment_expression {
	emit ("PARAM", $1->loc->name);
	int zero = 0;	
	int one = 1;
	$$ = 1;
	}
	|argument_expression_list COMMA assignment_expression {
	emit ("PARAM", $3->loc->name);
	$$ = $1+1;
	}
	;

relational_expression
	:shift_expression {$$=$1;}
	|relational_expression LESS_THAN shift_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("LT", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relational_expression GREATER_THAN shift_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";

			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("GT", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relational_expression LESS_THAN_OR_EQUAL_TO shift_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("LE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relational_expression GREATER_THAN_OR_EQUAL_TO shift_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("GE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	;



unary_expression
	:postfix_expression {
	int zero = 0;	
	int one = 1;	
	$$ = $1;
	}
	|INCREMENT unary_expression {
		// Increment $2
		emit ("ADD", $2->array1->name, $2->array1->name, "1");
		int zero = 0;	
		int one = 1;
		// Use the same value as $2
		$$ = $2;
	}
	|DECREMENT unary_expression {
		// Decrement $2
		emit ("SUBTRACT", $2->array1->name, $2->array1->name, "1");
		int zero = 0;	
		int one = 1;
		// Use the same value as $2
		$$ = $2;
	}
	|unary_operator cast_expression {
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		switch ($1) {
			case '&':
				$$->array1 = gentemp((new symtype("PTR")));
				$$->array1->type->ptr = $2->array1->type; 
				emit ("ADDRESS", $$->array1->name, $2->array1->name);
				break;
			case '*':
				$$->cat = "PTR";
				$$->loc = gentemp ($2->array1->type->ptr);
				emit ("PTRR", $$->loc->name, $2->array1->name);
				$$->array1 = $2->array1;
				break;
			case '+':
				$$ = $2;
				break;
			case '-':
				$$->array1 = gentemp(new symtype($2->array1->type->type));
				emit ("UMINUS", $$->array1->name, $2->array1->name);
				break;
			case '~':
				$$->array1 = gentemp(new symtype($2->array1->type->type));
				emit ("BNOT", $$->array1->name, $2->array1->name);
				break;
			case '!':
				$$->array1 = gentemp(new symtype($2->array1->type->type));
				emit ("LNOT", $$->array1->name, $2->array1->name);
				break;
			default:
				break;
		}
		int two = 2;	
		int three = 3;
	}
	|SIZEOF unary_expression {
	//later
	}
	|SIZEOF ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE {
	//later
	}
	;

parameter_type_list
	:parameter_list {//later
	int zero = 0;	
	int one = 1;
	}
	|parameter_list COMMA ELLIPSIS {//later
	int zero = 0;	
	int one = 1;
	}
	;

parameter_list
	:parameter_declaration {//later
	int zero = 0;	
	int one = 1;
	}
	|parameter_list COMMA parameter_declaration {//later
	int zero = 0;	
	int one = 1;
	}
	;

parameter_declaration
	:declaration_specifiers declarator {//later
	int zero = 0;	
	int one = 1;
	}
	|declaration_specifiers {//later
	int zero = 0;	
	int one = 1;
	}
	;

identifier_list
	:IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	|identifier_list COMMA IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	;

type_name
	:specifier_qualifier_list {//later
	int zero = 0;	
	int one = 1;
	}
	;

initializer
	:assignment_expression {
		$$ = $1->loc;
		int zero = 0;	
		int one = 1;
	}
	|CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	;


initializer_list
	:designation initializer {//later
	int zero = 0;	
	int one = 1;
	}
	|initializer {//later
	int zero = 0;	
	int one = 1;
	}
	|initializer_list COMMA designation initializer {//later
	int zero = 0;	
	int one = 1;
	}
	|initializer_list COMMA initializer {//later
	int zero = 0;	
	int one = 1;
	}
	;

designation
	:designator_list ASSIGNMENT {//later
	int zero = 0;	
	int one = 1;
	}
	;

designator_list
	:designator {//later
	int zero = 0;	
	int one = 1;
	}
	|designator_list designator {//later
	int zero = 0;	
	int one = 1;
	}
	;

designator
	:SQUARE_BRACKET_OPEN constant_expression SQUARE_BRACKET_CLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|DOT IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	;

statement
	:labeled_statement {//later
	}
	|compound_statement {$$=$1;}
	|expression_statement {
		int zero = 0;	
		int one = 1;
		$$ = new statement();
		$$->nextlist = $1->nextlist;
	}
	|selection_statement {$$=$1;}
	|iteration_statement {$$=$1;}
	|jump_statement {$$=$1;}
	;

labeled_statement
	:IDENTIFIER COLON statement {$$ = new statement();}
	|CASE constant_expression COLON statement {$$ = new statement();}
	|DEFAULT COLON statement {$$ = new statement();}
	;

compound_statement
	:CURLY_BRACKET_OPEN block_item_list CURLY_BRACKET_CLOSE {$$=$2;}
	|CURLY_BRACKET_OPEN CURLY_BRACKET_CLOSE {$$ = new statement();}
	;

block_item_list
	:block_item {$$=$1;}
	|block_item_list M block_item {
		int zero = 0;	
		int one = 1;
		$$=$3;
		backpatch ($1->nextlist, $2);
	}
	;

block_item
	:declaration {
		int zero = 0;	
		int one = 1;
		$$ = new statement();
	}
	|statement {$$ = $1;}
	;

expression_statement
	:expression SEMICOLON {$$=$1;}
	|SEMICOLON {$$ = new expr();}
	;


iteration_statement
	:WHILE M ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE M statement {
		$$ = new statement();
		convertInt2Bool($4);
		int zero = 0;	
		int one = 1;
		// M1 to go back to boolean again
		// M2 to go to statement if the boolean is true
		backpatch($7->nextlist, $2);
		backpatch($4->truelist, $6);
		$$->nextlist = $4->falselist;
		int zeroo = 0;	
		int onee = 1;
		// Emit to prevent fallthrough
		stringstream STring;
	    STring << $2;
	    string TempString = STring.str();
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);
		int zerooo = 0;	
		int oneee = 1;
		emit ("GOTOOP", str);
	}
	|DO M statement M WHILE ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE SEMICOLON {
		$$ = new statement();
		convertInt2Bool($7);
		int zero = 0;	
		int one = 1;
		// M1 to go back to statement if expression is true
		// M2 to go to check expression if statement is complete
		backpatch ($7->truelist, $2);
		backpatch ($3->nextlist, $4);

		// Some bug in the next statement
		$$->nextlist = $7->falselist;
	}
	|FOR ROUND_BRACKET_OPEN expression_statement M expression_statement ROUND_BRACKET_CLOSE M statement{
		$$ = new statement();
		convertInt2Bool($5);
		backpatch ($5->truelist, $7);
		backpatch ($8->nextlist, $4);
		stringstream STring;
	    STring << $4;
		int zero = 0;	
		int one = 1;
	    string TempString = STring.str();
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);

		emit ("GOTOOP", str);
		$$->nextlist = $5->falselist;
	}
	|FOR ROUND_BRACKET_OPEN expression_statement M expression_statement M expression N ROUND_BRACKET_CLOSE M statement{
		$$ = new statement();
		int zeroo = 0;	
		int onee = 1;
		convertInt2Bool($5);
		backpatch ($5->truelist, $10);
		backpatch ($8->nextlist, $4);
		backpatch ($11->nextlist, $6);
		stringstream STring;
	    STring << $6;
		int zero = 0;	
		int one = 1;
	    string TempString = STring.str();
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);
		emit ("GOTOOP", str);
		$$->nextlist = $5->falselist;
	}
	;

jump_statement
	:GOTO IDENTIFIER SEMICOLON {$$ = new statement();}
	|CONTINUE SEMICOLON {$$ = new statement();}
	|BREAK SEMICOLON {$$ = new statement();}
	|RETURN expression SEMICOLON {
		$$ = new statement();
		int zero = 0;	
		int one = 1;
		emit("RETURN",$2->loc->name);
	}
	|RETURN SEMICOLON {
		$$ = new statement();
		int zero = 0;	
		int one = 1;
		emit("RETURN","");
	}
	;

translation_unit
	:external_declaration {}
	|translation_unit external_declaration {}
	;

external_declaration
	:function_definition {}
	|declaration {}
	;

function_definition
	:declaration_specifiers declarator declaration_list CT compound_statement {}
	|declaration_specifiers declarator CT compound_statement {
		int zero = 0;	
		int one = 1;
		currTable->parent = globalTable;
		changeTable (globalTable);
	}
	;

declaration_list
	:declaration {//later
	int zero = 0;	
	int one = 1;
	}
	|declaration_list declaration {//later
	}
	;



%%

void yyerror(string s) {
    cout<<s<<endl;
}