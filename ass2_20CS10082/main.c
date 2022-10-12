// Including "myl.h" to gat the function prototypes
#include "myl.h"
// Driver function
int main()
{
	// Character array to store the string data of giving prompt to the user
	char mssg[] = "Enter your choice: \n\t1. Integer\n\t2. Floating Point\n\t3. Exit\nEnter your choice: ";
	int input; // Variable to store the input from the user
	do
	{
		printStr(mssg);	   // Printing the prompt to the user
		readInt(&input);   // Reading the input choice from the user
		int int_input;	   // Variable to store the integer input from the user
		float float_input; // Variable to store the floating point input from the user
		// Switch case to perform the corresponding operation based on the input from the user
		switch (input)
		{
		// Case 1: Integer
		case 1:
			printStr("Enter an integer: ");
			// Reading the integer input from the user
			if(!readInt(&int_input)){
				printStr("Invalid input for int\n");
				break;
			}
			printStr("You entered: ");
			printInt(int_input); // Printing the integer input to the user
			printStr("\n");
			break;
		// Case 2: Floating Point
		case 2:
			printStr("Enter a floating point: ");
			// Reading the floating point input from the user
			if(!readFlt(&float_input)){
				printStr("Invalid input for float\n");
				break;
			}
			printStr("You entered: ");
			printFlt(float_input); // Printing the floating point input to the user
			printStr("\n");
			break;
		// Case 3: Exit
		case 3:
			printStr("Exiting...\n");
			break;
		// Default: Invalid input
		default:
			printStr("Invalid choice...\n");
		}
	} while (input != 3);
	return 0;
}