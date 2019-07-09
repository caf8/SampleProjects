#include "trib.h"

int first = 0, second = 0, third = 1, next;


int tribcalc(int num){

	if(num == 1 || num == 2){
		return 0;
	}else if(num == 3){
		return 1;
	}else{
		next = first + second + third;
		first = second;
		second = third;
		third = next;
	}
return next;
}
		
		

