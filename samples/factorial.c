volatile int number = 5;   // prevent constant propagation
volatile int sink;         // prevent result elimination

__attribute__((noinline))
int factorial(int n)
{
    int i, fact;
    fact = 1;
    for (i = 1; i <= n; i++)
    {
        fact = fact * i;
    }
    return fact;
}

int main()
{
    int result = factorial(number);
    sink = result;   // force the computation to stay
    return 0;
}