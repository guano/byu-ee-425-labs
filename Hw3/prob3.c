
void MyFunction(int argWord, char argByte);

int main(){
	MyFunction(123, 'a');
	return 0;
}



void MyFunction(int argWord, char argByte){
	int localWord = argWord;
	char localByte = argByte;

	localWord++;
	localByte += 2;
}
