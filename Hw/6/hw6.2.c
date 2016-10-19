#include <stdio.h>

int main(){
	int trial = 345;	
	
	char bob = '0';
	switch(trial){
		case 252:
			bob = 'a';
			break;
		case 982:
			bob = '1';
			break;
		case 154:
			bob = 'b';
			break;
		case 345:
			bob = '3';
			break;
		case 764:
			bob = 'c';
			break;
		case 159:
			bob = '5';
			break;
		case 100:
			bob = 'd';
			break;
		case 903:
			bob = '7';
			break;
		default:
			bob = 'X';
			break;
	}

	printf("Output: %c\n",bob);
}
