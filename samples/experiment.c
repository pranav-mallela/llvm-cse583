// experiment.c
int experiment(int volatile_input) {
    // Volatile prevents the compiler from optimizing these into constants
    int a = volatile_input << 2;
    int b = a ^ 0x55555555; 
    return b & 0xF0F0F0F0;
}

int experiment1(int volatile_input) {
    // Volatile prevents the compiler from optimizing these into constants
    int a = volatile_input >> 2;
    int b = a ^ 0x1; 
    return b & 0x1;
}
