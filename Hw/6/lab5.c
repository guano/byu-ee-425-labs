#include <stdio.h>

int main(int argc, char *argv[]){
	if(argc != 2){
		printf("Failed to include the argument!\n");
		return;
	}
	
	printf("argument: %c\n", *argv[1]);
	
	char bob = '0';
	int temp = (int) *argv[1];
	switch(*argv[1]){
		case 48:
			bob = 'a';
			break;
		case 49:
			bob = '1';
			break;
		case 50:
			bob = 'b';
			break;
		case 51:
			bob = '3';
			break;
		case 52:
			bob = 'c';
			break;
		case 53:
			bob = '5';
			break;
		case 54:
			bob = 'd';
			break;
		case 55:
			bob = '7';
			break;
		case 56:
			bob = 'e';
			break;
		case 57:
			bob = '9';
			break;
		default:
			bob = 'X';
			break;
	}

	printf("Output: %c\n",bob);
}
