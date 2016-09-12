#include <stdio.h>

int main(){
	printf("Should not be leap year: %d\n", IsLeapYear(1991));
	printf("Should not be leap year: %d\n", IsLeapYear(1900));
	printf("Should be leap year: %d\n", IsLeapYear(2000));
	printf("Should be leap year: %d\n", IsLeapYear(2004));
	printf("Should not be leap year: %d\n", IsLeapYear(2015));
	
	int e = 10;
	int w = 3;
	float result;
	result = e/w;
	printf("result is: %f\n", result);


	//t1 and t2 are 32bit ints
	//t1 has a value
	int t1 = 0x11223344;
	int t2 = 0;

	t2 = (t1 << 8) & 0xff000000
		| ((~t1)>>8)& 0x00ff0000
		| (t1 << 8) & 0x0000ff00
		| (t1 >> 8) & 0x000000ff;

	printf("t1 is %#x, t2 is %#x\n", t1, t2);
	

	int x = 0;
	int y = 1;
	int z = 2;

	printf("x: %d, y: %d, z: %d\n", x, y, z);
	printf("x + y * z:%d\n",x+y*z);
	printf("x == 0 && y != 4:%d\n",x == 0 && y != 4);
	printf("y < x < z:%d\n",y < x < z);
	printf("y+-z:%d\n",y+-z);
	printf("!z||y:%d\n",!z||y);
	printf("y ? x : z:%d\n",y ? x : z);
	printf("x - y < z:%d\n",x - y < z);
	printf("x = 0 || z <= y:%d\n",x = 0 || z <= y);
			//(Give value of expression and final value of x)
	printf("z & 3 == 2:%d\n",z & 3 == 2);

}


int IsLeapYear(int year){
	return ((year%4==0)&&(year%100!=0))||(year%400==0);// ? 1 : 0;	
}
