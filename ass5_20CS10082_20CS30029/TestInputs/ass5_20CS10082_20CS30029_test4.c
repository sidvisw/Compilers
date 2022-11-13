// fourth test case for the assignment 5
// Group Members: 20CS10082, 20CS30029
// things checked in this file:
// 1. Function calls
// 2. Pointer assignments and declarations
// 3. char and char pointer declarations
// 4. type conversions
// 5. loop arithmatics

void swap(int *a, int *b);

int testFile = 4;
char testChar = 'theFourthTestFile';

void main()
{
    int a = 10, b = 20;
    swap(&a, &b);

    int i;
    for (i = 0; i < 10; i++)
    {
        int j = 0;
        while (j < 10)
        {
            j++;
            {
                if (i == 0)
                    j = 0;
                else
                {
                    j = 1;
                }
            }
        }
    }

    float f = 1.2;
    a = f;

    char *temp;
    char name[20] = "swap";
    temp = name;

    char letter = 'a';

    int b = 10 + a;
    int val = 150;
    char c = val;

    return;
}

void swap(int *a, int *b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;

    return;
}