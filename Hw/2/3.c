#include <stdio.h>

int my_function(int a, char poop);
void test_scanf();
void test_printf();

int main(){
	int a = 123;
	char poop = 's';
	int w = 543;
//	my_function(a, poop, w);
//	my_function(poop,a);

	test_printf();
	test_scanf();
}

int my_function(int a, char poop){
	printf("int a; %d char poop: %s\n", a, poop);
}

void test_scanf(){
	printf("Alright, we are going to fail scanf. Type a number\n");
	int i = 0;
	scanf("%d", i);
	printf("This is what happened to i: %d\n", i);
}

void test_printf(){
	int i=1;
	int j=2;
	int k=3;
	printf("we are going to try to print 2 numbers, but give scanf 3\n");
	printf("i=%d, j=%d\n", i, j, k);
	printf("apparently printf ignores extra parameters\n");

	printf("\nNow we will try printing 2 numbers, but only give scanf 1\n");
	printf("i=%d, j=%d\n", i);
}
