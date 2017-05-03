#include <stdio.h>

int zuuu(void);

int tuuu(void)
{
 	printf ("zzzzzz");
	return (0);
}

int dooo(void)
{
	printf("nene");
	return (0);
}

int main ( void)
{
	int a, b;
	a = 1;
	b = 2;
	dooo();
	printf ("jaja");
	if (a == b) 
	{
		dooo();
		zuuu();
	}
	return (0);
}

