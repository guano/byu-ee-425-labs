#include <stdio.h>

int main(){
	int array[4];
	int overflow = 0;
	int array_size = 4;
	int index = 0;

	printf("array is empty, overflow is %d\n", overflow);

	for(index = 0; index <= array_size+1; index++){
		array[index] = index;
	}
	printf("we modified the array and not overflow, but overflow is %d\n", overflow);
	printf("overflow: %d, index:%d, array_size:%d\n", overflow, index, array_size);	
}
