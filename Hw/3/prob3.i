# 1 "prob3.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "prob3.c"

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
