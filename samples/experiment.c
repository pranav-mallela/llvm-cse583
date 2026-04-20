// experiment.c
// int experiment(int volatile_input) {
//     // Volatile prevents the compiler from optimizing these into constants
//     int a = volatile_input >> 2;
//     int b = a ^ 0x1; 
//     return b & 0x1;
// }

// int main() {
//     volatile int input = 12;
//     int result = experiment(input);
//     return 0;
// }

volatile int x = 12;
volatile int sink;

int experiment(int input) {
    int a = input >> 2;
    int b = a ^ 1;
    return b & 1;
}

int main() {
    sink = experiment(x);
    return 0;
}
