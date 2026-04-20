// experiment.c
int experiment(int volatile_input) {
    // Volatile prevents the compiler from optimizing these into constants
    int a = volatile_input >> 2;
    int b = a ^ 0x1; 
    return b & 0x1;
}

int main() {
    int input = 12; // Example input
    int result = experiment(input);
    return 0;
}
