#include <stdio.h>
#include "trib.h"
#include <limits.h>

int main(void){
	printf("Please enter the number of terms of the Tribonacci sequence that you want");
	int num;
	scanf("%d", &num);
	for (int i = 1; i <= num; i++){
		int j = tribcalc(i);
		if(j < INT_MAX && j > -1){		
		printf("%d\n", j);
		}else{
			break;
		}
	}
}
	
