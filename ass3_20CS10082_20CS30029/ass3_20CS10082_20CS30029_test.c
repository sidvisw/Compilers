/* Test C Program to check all lexical rules in the code */

extern int globl;
auto x = 3;
typedef const unsigned int cui;
short bit = 1;
typedef const signed int csi;
inline int addOne (int x) {return x++;};
enum directions {NORTH = 1, SOUTH, EAST, WEST};

struct ass3_20CS30029_test
{
    /* data */
    int marks;
    char comments;
};

typedef struct ass3_20CS30029_test ass3_20CS30029_test;

_Complex a = 1 + 2.0i;
_Bool check = 0;

union ass3_20CS30029_test_union
{
    /* data */
    int marks;
    char comments;
};

static int staticVar = 1;

void my_function(int* x, int* y, int* restrict z) {
   *x += *z;
   *y += *z;
   return;
}

int main()
{
    unsigned int sizeInt = sizeof(int);
    int var = 2;
    int temp;
    switch (var)
    {
    case 1:
        temp = 0;
        break;
    
    default:
        temp = 1;
        break;
    }

    while (temp)
    {
        /* code */
        temp = 0;
    }

    register int regVar = 1;

    do
    {
        /* code */
        temp = 0;
    } while (temp);

    if(temp) {
        temp = 0;
    } else {
        temp = 1;
    }

    for(int i=0; i<10; i++){
        if(i==0) continue;
        else break;
    }

    int int_const = 0;
    int int_const2 = 24301;
    double pi = 314e-2;
    float f = .321e+1;
    double ld = -1.2e-3;

    enum directions dir = NORTH;
    char c = 'a';
    char newLine = '\n';
    char newLine = '\\';

    char str[] = "Hello World";
    char empty[] = "";

    float e = 2.71;

    // goto label;

    volatile int volVar = 1;

    int _ab1029200 = 1;
    int _0000ax20 = 1;
    int M_123_ba00 = 1;

    ass3_20CS30029_test* test;
    test->comments = 'a';
    test->marks = 1;

    int test1, test2;
    test1++;
    test2--;
    test1 = test1 & test2;
    test1 = test1 | test2;
    test1 = test1 ^ test2;
    test1 = test1 >> test2;
    test1 = test1 << test2;
    test1 = test1 && test2;
    test1 = test1 == test2;
    test1 = test1 != test2;
    test1 = test1 <= test2;
    test1 = test1 >= test2;
    test1 = test1 < test2;
    test1 = test1 > test2;
    test1 = test1 ? test2 : test1 < test2;
    test1 *= test2;
    test1 /= test2;
    test1 %= test2;
    test1 += test2;
    test1 -= test2;
    test1 <<= test2;
    test1 >>= test2;
    test1 &= test2;
    test1 ^= test2;
    test1 |= test2;
    test1 = 1, test2 = 2;
    
    
}



