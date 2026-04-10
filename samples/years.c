int countYears() {
    int res = 0;
    for(int year=7;year>0;year--)
    if((year%2==0)&&(year%4!=0)) res++;
    return res;
}
