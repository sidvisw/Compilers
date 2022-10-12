// Including "myl.h" to gat the function prototypes
#include "myl.h"
// Defining the Write Mode to the constant variable '1'
#define __NR_write 1
// Defining the Read Mode to the constant variable '0'
#define __NR_read 0
// Defining the File to which the data is to be written to the constant variable '1'
#define STDOUT_FILENO 1
// Defining the File to which the data is to be read from the constant variable '0'
#define STDIN_FILENO 0
// Defining the buffer size to which the data is to be read from the constant variable '20'
#define BUFF_SIZE 20

// Funxtion to write the string data to the STDOUT
// Parameter: The string data to be written to the STDOUT
// Return: The number of characters written to the STDOUT
int printStr(char *str)
{
	int len; // Variable to store the length of the string
	// Calculating the length of the string
	for (len = 0; str[len] != '\0'; len++)
		;
	int ret; // Variable to store the return value of the system call
	// Writing the string to the STDOUT
	__asm__ __volatile__(
		"syscall"
		: "=a"(ret)
		: "0"(__NR_write), "D"(STDOUT_FILENO), "S"(str), "d"(len)
		: "rcx", "r11", "memory", "cc");
	return len; // Returning the length of the string
}

// Function to read the Int data from the STDIN
// Parameter: The pointer to the Int data to be read from the STDIN
// Return: OK if the data is read successfully else ERR
int readInt(int *n)
{
	char buff[BUFF_SIZE]; // Variable to store the Int as a string
	int ret;			  // Variable to store the return value of the system call
	// Reading the Int from the STDIN
	__asm__ __volatile__(
		"syscall"
		: "=a"(ret)
		: "0"(__NR_read), "D"(STDIN_FILENO), "S"(buff), "d"(BUFF_SIZE)
		: "rcx", "r11", "memory", "cc");
	int len; // Variable to iterate through the string
	// Loop until all the prefixed spaces are removed
	for (len = 0; len < BUFF_SIZE && len < ret - 1 && buff[len] == ' '; len++)
		;
	// IF the BUFF_SIZE is exhausted OR we have reached the end of the string return ERR
	if (len == BUFF_SIZE || len == ret - 1)
		return ERR;
	int is_negative = 0; // Boolean variable to check if the integer is negative or not
	// Check if the string is negative or not
	if (buff[len] == '-')
	{
		is_negative = 1;
		len++;
	}
	else if (buff[len] == '+')
		len++;
	int num = 0; // Variable to store the Int
	// Loop until all the digits are read or we encounter a <space> or a '.'
	for (; len < BUFF_SIZE && len < ret - 1 && buff[len] != ' ' && buff[len] != '.'; len++)
	{
		// If the digit does not fall in the range of 0 to 9 return ERR
		if (buff[len] < '0' || buff[len] > '9')
			return ERR;
		num = num * 10 + (buff[len] - '0');
	}
	// If the BUFF_SIZE is exhausted then return ERR
	if (len == BUFF_SIZE)
		return ERR;
	// If the string is negative then negate the Int
	if (is_negative)
		*n = -num;
	else
		*n = num;
	return OK; // Return OK for success
}

// Function to print the Int data to the STDOUT
// Parameter: The Int data to be printed to the STDOUT
// Return: OK if the data is printed successfully else ERR
int printInt(int n)
{
	char buff[BUFF_SIZE]; // Variable to store the Int as a string
	int len = 0;		  // Variable to iterate through the string
	int is_negative = 0;  // Boolean variable to check if the string is negative or not
	// If the number is negative then append the '-' to the string
	if (n < 0)
	{
		is_negative = 1;
		buff[len++] = '-';
		n = -n;
	}
	// Store the contents of the number to the string in reverse order digit by digit
	while (n && len < BUFF_SIZE)
	{
		buff[len++] = n % 10 + '0';
		n /= 10;
	}
	// If the BUFF_SIZE is exhausted then return ERR
	if (len == BUFF_SIZE)
		return ERR;
	// Append the '\0' to the string to terminate the string
	buff[len] = '\0';
	// Reverse the string following as offset of 1 if the integer is negative
	for (int i = is_negative; i < len / 2 + is_negative; i++)
	{
		// Swap the beginning and the end characters
		char temp = buff[i];
		buff[i] = buff[len - i - 1 + is_negative];
		buff[len - i - 1 + is_negative] = temp;
	}
	// I the number wad 0 then the string must be empty so append the '0' to the string
	if (len == 0)
	{
		buff[0] = '0';
		buff[1] = '\0';
		len = 1;
	}
	// Call the printStr function to print the string to the STDOUT
	if (printStr(buff))
		return OK;
	return ERR; // Return ERR for failure
}

// Function to read the floating point data from the STDIN
// Parameter: The pointer to the floating point data to be read from the STDIN
// Return: OK if the data is read successfully else ERR
int readFlt(float *f)
{
	char buff[BUFF_SIZE]; // Variable to store the floating point as a string
	int ret;			  // Variable to store the return value of the system call
	// Reading the floating point from the STDIN
	__asm__ __volatile__(
		"syscall"
		: "=a"(ret)
		: "0"(__NR_read), "D"(STDIN_FILENO), "S"(buff), "d"(BUFF_SIZE)
		: "rcx", "r11", "memory", "cc");
	int len; // Variable to iterate through the string
	// Loop until all the prefixed spaces are removed
	for (len = 0; len < BUFF_SIZE && len < ret - 1 && buff[len] == ' '; len++)
		;
	// IF the BUFF_SIZE is exhausted OR we have reached the end of the string return ERR
	if (len == BUFF_SIZE || len == ret - 1)
		return ERR;
	int is_negative = 0; // Boolean variable to check if the floating point value is negative or not
	// Check if the string is negative or not
	if (buff[len] == '-')
	{
		is_negative = 1;
		len++;
	}
	else if (buff[len] == '+')
		len++;
	float num = 0; // Variable to store the floating point value
	// Loop until all the digits are read or we encounter a <space> or a '.'
	for (; len < BUFF_SIZE && len < ret - 1 && buff[len] != ' ' && buff[len] != '.'; len++)
	{
		// If the digit does not fall in the range of 0 to 9 return ERR
		if (buff[len] < '0' || buff[len] > '9')
			return ERR;
		num = num * 10 + (buff[len] - '0');
	}
	// If we have encountered a <space> then we read only till the <space> and return
	if (len < BUFF_SIZE && len < ret - 1 && buff[len] == ' ')
	{
		// If the number is negative then negate the floating point value
		if (is_negative)
			*f = -num;
		else
			*f = num;
		return OK; // Return OK for success
	}
	// Else if we encounter a '.' we go on to read the decimal part of the floating point value
	len++;
	float placeVal = 10; // Variable to store the power of the place in the decimal part
	// Loop until all the digits are read or we encounter a <space>
	for (; len < BUFF_SIZE && len < ret - 1 && buff[len] != ' '; len++)
	{
		// If the digit does not fall in the range of 0 to 9 return ERR
		if (buff[len] < '0' || buff[len] > '9')
			return ERR;
		// Add the decimal part along with its place value power to the floating point value
		num += (buff[len] - '0') / placeVal;
		// Increment accordingly the power of the place value
		placeVal *= 10;
	}
	// If the BUFF_SIZE is exhausted then return ERR
	if (len == BUFF_SIZE)
		return ERR;
	// If the floating point value is negative then negate the floating point value
	if (is_negative)
		*f = -num;
	else
		*f = num;
	return OK; // Return OK for success
}

// Function to print the floating point data to the STDOUT
// Parameter: The floating point data to be printed to the STDOUT
// Return: OK if the data is printed successfully else ERR
int printFlt(float f)
{
	char buff[BUFF_SIZE]; // Variable to store the floating point as a string
	int len = 0;		  // Variable to iterate through the string
	int is_negative = 0;  // Boolean variable to check if the string is negative or not
	// If the floating point value is negative then append the '-' to the string
	if (f < 0)
	{
		is_negative = 1;
		buff[len++] = '-';
		f = -f;
	}
	int whole = (int)f;		   // Store the whole integral part of the floating point value
	float decimal = f - whole; // Store the decimal part of the floating point value
	// If integral part is 0 then append the '0' to the string
	if (!whole)
	{
		buff[len++] = '0';
	}
	// Else store the integral part to the string in reverse order digit by digit
	while (whole && len < BUFF_SIZE)
	{
		buff[len++] = whole % 10 + '0';
		whole /= 10;
	}
	// If the BUFF_SIZE is exhausted then return ERR
	if (len == BUFF_SIZE)
		return ERR;
	// Reverse the string following as offset of 1 if the integer is negative
	for (int i = is_negative; i < len / 2 + is_negative; i++)
	{
		char temp = buff[i];
		buff[i] = buff[len - i - 1 + is_negative];
		buff[len - i - 1 + is_negative] = temp;
	}
	buff[len++] = '.';	// Append a '.' to the string for now appending the decimal part
	int _PRECISION = 6; // Variable to store the precision of the floating point value - 6
	// Loop until the required precision is reached or the BUFF_SIZE is exhausted
	while (_PRECISION-- && len < BUFF_SIZE)
	{
		decimal *= 10;					  // Multiply the decimal part by 10 to get the integral part as the next digit
		buff[len++] = (int)decimal + '0'; // Append the digit to the string
		decimal -= (int)decimal;		  // Subtract the integral part from the decimal part to get the next digit
	}
	// If the BUFF_SIZE is exhausted then return ERR
	if (len == BUFF_SIZE)
		return ERR;
	buff[len] = '\0'; // Append a '\0' to the string to mark the end of the string
	// Call the printStr function to print the string to the STDOUT
	if (printStr(buff))
		return OK;
	return ERR; // Return ERR for failure
}