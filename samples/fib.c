volatile unsigned int input = 10;   // acts like argv input
volatile unsigned int sink;        // prevent optimization

__attribute__((noinline))
unsigned int fib(unsigned int n) {
    unsigned int fib0 = 0, fib1 = 1;
    unsigned int result = 0;

    if (n == 0) {
        result = 0;
    } else if (n == 1) {
        result = 1;
    } else {
        int i;
        for (i = 0; i < n - 1; ++i) {
            if (i % 2 == 0) {
                fib0 += fib1;
                result = fib0;
            } else {
                fib1 += fib0;
                result = fib1;
            }
        }
    }

    return result;
}

int main() {
    unsigned int result = fib(input);
    sink = result;   // keep computation alive
    return 0;
}
