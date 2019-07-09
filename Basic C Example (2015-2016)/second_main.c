#include <stdio.h>
#include "trib.h"
#include <stdbool.h>
#include <limits.h>

int first, second, third;
bool run = true;

int main(void){
	while(run){
		printf(" \nWelcome to the Tribonnaci sequence generator");
		printf(" \nToo quit the program then enter 3 0s as your three intial values.");
		printf("\n");
		printf("\n");
		printf("\nPlease enter the three terms that you want to begin the Tribonnaci sequence \n");

		scanf( "%d", &first); 
		scanf( "%d", &second);
		scanf( "%d", &third);
		//assert(first != 0 && second != 0 && third != 0);

		if(first == 0 && second == 0 && third == 0){
			run = false;

		}else{

			printf("Please enter the number of terms of the Tribonacci sequence that you want \n");
			int num;
			scanf("%d", &num);
			for (int i = 1; i <= num; i++){
				int j = tribcalc(i);
				if (j < INT_MAX && j > -1){		
					printf("%d\n", j);
				}else{
					break;
				}
			}	
		}
	}

	printf("Thank you for using the Tribonnaci generator \n");

}

