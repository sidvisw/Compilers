// third test file for the assignment 5
// Group Members: 20CS10082, 20CS30029
// things checked in this file:
// 1. Global variable declaration
// 2. nested blocks inside functions
// 3. declaration of same variables inside and outside nested blocks
// 4. temp, t named variables declarations

int glbInt = 1;

int main(){
    int a, b;
    {
        int a=1, b=2;
        int c = a + b;
    }
    int c;
    int t = a*b/c;
    float temp = 1.2;
    return 0;
}
