int main() {
    unsigned int a = 0x12345678;
    unsigned int b = 0x87654321;
    
    // Complex bitwise operations to give BEC something to analyze
    unsigned int c = (a & b) ^ (a | b);
    unsigned int d = (c << 5) | (c >> 3);
    
    return d;
}
