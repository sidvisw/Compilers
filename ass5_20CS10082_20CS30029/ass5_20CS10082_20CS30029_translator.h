#ifndef TRANSLATOR_20CS10082_20CS30029
#define TRANSLATOR_20CS10082_20CS30029

extern  char* yytext;
extern  int yyparse();

// bits/stdc++.h is included to use list and vector
#include <bits/stdc++.h>

using namespace std;

// Values taken as given in the question, may change dependening on the mach
#define CHAR_SIZE_BYTES 		1
#define INT_SIZE_BYTES  		4
#define FLOAT_SIZE_BYTES		8
#define POINTER_SIZE_BYTES		4

// Classes declarations
class symtype;						// Class for symbol type
class sym;							// Class for an entry in symbol table
class symtable;						// Class for the symbol table
class quad;							// Class for an entry in quad array
class quadArray;					// Class for maintaining QuadArray

// External variables declaration to be exported to the translator.cxx file
extern symtable* currTable;			// Pointer pointing towards current symbol table
extern sym* currSymbol;				// Pointer pointing to the symbol that was just read by the parser
extern symtable* globalTable;		// Pointer pointing towards global symbol table
extern quadArray qArr;				// Quadaray object to store three address codes

//	================== Class definitions ==================

// Class for symbol type
class symtype {
public:
	symtype(string name, symtype* ptr = NULL, int width = 1); 					// Constructor for the class
	string type;																// Type will denote the type of the symbol (eg int, float)
	symtype* ptr;																// Pointer to the type of the symbol (eg int, float)
	int width;																	// Width of the array (if the symbol is an array)
};

// Class for an element in symbol table
class sym {
public:
	string name;																// Symbol name (eg a, b, c)
	symtype *type;																// Pointer to the type of the symbol
	string initial_value;														// Initial value of the symbol
	int size;																	// Size of the symbol in bytes
	int offset;																	// Offset of the symbol from the base pointer
	symtable* nested;															// Pointer to the nested symbol table (if the symbol is a function or new block)

	sym (string name, string t="INTEGER", symtype* ptr = NULL, int width = 0); 	// Constructor for the class
	sym* update(symtype * t); 													// Function to update fields of the symbol
	sym* link_to_symbolTable(symtable* t);
};

// Class for the symbol table
class symtable {
public:
	string name;											// Symbol table name (eg global, function name, block name)
	int count;												// Number of temporary symbols in the symbol table
	list<sym> currTable; 									// List of symbols in the symbol table
	symtable* parent;										// Pointer to the parent symbol table

	symtable (string name="NULL");							// Constructor for the class
	sym* lookup (string name);								// Function to lookup a symbol in the symbol table
	void print();					            			// Function to print the symbol table
	void update();						        			// Function to update the offset of symbol table
};

// Class for an entry in quad array
class quad {
public:
	string operator1;					// Operator of the quad
	string answer;						// Answer of the quad
	string argument1;					// First argument of the quad
	string argument2;					// Second argument of the quad

	void print ();						// Function to print the quad

	// Constructors with default operation
	quad (string res, string argA, string operation = "EQUAL", string argB = "");		// Constructor for the class for string arguments	
	quad (string res, int argA, string operation = "EQUAL", string argB = "");			// Constructor for the class for int arguments		
	quad (string res, float argA, string operation = "EQUAL", string argB = "");		// Constructor for the class for float arguments		
};

// Class for maintaining QuadArray
class quadArray {
public:
	vector <quad> qArray;		                // Vector of quads
	void print ();								// Print the quadArray
};

//	============== Non terminal attributes ==============

// Struct for attributes of statements
struct statement {
	list<int> nextlist;							// List of next quads to be executed
};

// Struct for attributes of arrays
struct array1 {
	string cat;									// Category of the array (eg simple, pointer, array)
	sym* loc;									// Pointer to the symbol table entry of the array
	sym* array1;								// Pointer to the symbol table entry of the array
	symtype* type;								// Pointer to the type of the array
};

// Struct for attributes of expressions
struct expr {
	string type; 								// Type of the expression (eg int, bool, statement)
	sym* loc;									// Pointer to the symbol table entry (Valid for non-bool type)
	
	// Valid for bool type
	list<int> truelist;							// Truelist valid for boolean
	list<int> falselist;						// Falselist valid for boolean expressions

	// Valid for statement expression
	list<int> nextlist;							// Nextlist valid for statement expression
};


//	================= Global Function Declarations =================

void emit(string op, string answer, string argA="", string argB = "");    	// Function to emit a quad
void emit(string op, string answer, int argA, string argB = "");		  	// Function to emit a quad with int argument
void emit(string op, string answer, float argA, string argB = "");        	// Function to emit a quad with float argument

sym* gentemp (symtype* t, string init = "");								// Function to generate a temporary symbol
void changeTable (symtable* newtable);               						// Function to change the current symbol table
int nextinstr();															// Function to return the next quad address

sym* conv (sym*, string);													// Generates TAC for type conversion
bool typecheck(sym* &s1, sym* &s2);											// Type checking function for two symbols
bool typecheck(symtype* t1, symtype* t2);									// Type checking function for two symbol types

void backpatch (list <int> lst, int i);										// Function to backpatch a list of quads
list<int> makelist (int i);							        				// Function to make a list of a single quad address
list<int> merge (list<int> &lst1, list <int> &lst2);						// Function to merge two lists of quad addresses into one

expr* convertInt2Bool (expr*);												// Function to convert int to bool
expr* convertBool2Int (expr*);												// Function to convert bool to int

int size_type (symtype*);													// Function to return the size of a type
string print_type(symtype*);												// Function to print the type of a symbol

#endif