// fifth test case for the assignment 5
// Group Members: 20CS10082, 20CS30029
// things checked in this file:
// 1. All expressions
// 2. All declarations
// 3. All statements

float a = 1.2;
int b = 10;
char c = 'a';
int i, arr[10];
int abc = 6, *p, cba;

int myFunct1(int a, int b)
{
    int c;
    {
        int c;
        c = 0;
    }
    c = a + b;
    return c;
}

float myFunct2(float a, float b)
{
    float c;
    c = -(a + b);
    return c;
}

int main()
{
    int i;
    for (i = 0; i < 10; i++)
    {
        if (i == 5)
            a = a + 1;
        else
            a = a - 1;
    }

    do
    {
        b = b - 1;
        a = a + 1;
    } while (b > 10 || a < 10);

    if (1)
    {
        int a = 10;
        int b = 20;
        int c = a + b;
    }
    else
    {
        if (0)
        {
            int a = 10;
            int b = 20;
            int c = a + b;
        }
        else
            ;
    }
}