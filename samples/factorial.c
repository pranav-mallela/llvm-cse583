int factorial(int n)
{
  int i,fact;
  fact = 1;
  for(i=1;i<=n;i++)
  {
    fact = fact * i;
  }
  return fact;
}

int main()
{
  int number = 5; // Example input
  int result = factorial(number);
  return 0;
}