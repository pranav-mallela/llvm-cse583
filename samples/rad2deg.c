volatile int g_deg = 45;
volatile int g_rad_scaled = 3141; 

volatile int sink1;
volatile int sink2;

#define PI_SCALED 3141
#define SCALE 1000

__attribute__((noinline))
int rad2deg_int(int rad_scaled)
{
    return (180 * rad_scaled) / PI_SCALED;
}

__attribute__((noinline))
int deg2rad_int(int deg)
{
    return (PI_SCALED * deg) / 180;
}

int main(void)
{
    int r1 = deg2rad_int(g_deg);
    int r2 = rad2deg_int(g_rad_scaled);

    sink1 = r1;
    sink2 = r2;
    return 0;
}