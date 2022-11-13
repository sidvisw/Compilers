// first test file for the assignment 5
// Group Members: 20CS10082, 20CS30029
// things checked in this file:
// 1. Function calls
// 2. Function declarations
// 3. Array declarations
// 4. Conditional statements
// 5. Variable declarations

int my_funct(int a, int b);

int main()
{
    int array[10];
    array[0] = 10;
    int a = 10;
    int b = 20;
    array[(a + b) / 10] = 20;
    int c;
    c = my_funct(a, b);
    if (c && a)
        a = 1;
    else
        a = 0;
    return 0;
}

int my_funct(int a, int b)
{
    int c;
    c = a + b;
    return c;
}


