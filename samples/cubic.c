volatile int g_a = 1;
volatile int g_b = -10;
volatile int g_c = 31;
volatile int g_d = -30;

volatile int sink_solutions;
volatile int sink_x0;
volatile int sink_x1;
volatile int sink_x2;

__attribute__((noinline))
void SolveCubicInt(int a, int b, int c, int d, int *solutions, int *x)
{
    int count = 0;
    int r;

    for (r = -20; r <= 20; r++) {
        int val = a * r * r * r + b * r * r + c * r + d;
        if (val == 0) {
            if (count < 3) {
                x[count] = r;
            }
            count++;
        }
    }

    *solutions = count;
    while (count < 3) {
        x[count] = 0;
        count++;
    }
}

int main(void)
{
    int x[3];
    int solutions;

    SolveCubicInt(g_a, g_b, g_c, g_d, &solutions, x);

    sink_solutions = solutions;
    sink_x0 = x[0];
    sink_x1 = x[1];
    sink_x2 = x[2];

    return 0;
}