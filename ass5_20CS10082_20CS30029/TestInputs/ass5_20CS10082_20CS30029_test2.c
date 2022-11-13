// second test file for the assignment 5
// Group Members: 20CS10082, 20CS30029
// things checked in this file:
// 1. Function calls
// 2. Function declarations
// 3. Array declarations
// 4. Conditional statements
// 5. While loop


void func(int f, float d)
{
    int i = 0;
    for(i = 0; i < 10; i++)
    {
        if(i == 5)
            d = d + 1;
        else
            d = d - 1;
    }

    while (f > 10 || d < 10)
    {
        f = f - 1;
        d = d + 1;
    }
}

void main()
{
    float d = 2.3;
    int i, w[10];
    int a = 4, *p, b;
    char c;
    func(a, d);
}