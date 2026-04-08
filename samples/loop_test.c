int loop_test(int n) {
    int sum = 0;
    for(int i = 0; i < n; i++) {
        sum ^= i; // XOR is great for bit-level analysis
    }
    return sum;
}
