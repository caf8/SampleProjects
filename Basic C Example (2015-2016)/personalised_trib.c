#include "trib.h"

int tribcalc(int num){

extern int first, second, third;
int next;


	if(num == 1){
		return first;
	}else if(num == 2){
		return second;
	}else if(num == 3){
		return third;
	}else{
		next = first + second + third;
		first = second;
		second = third;
		third = next;
	}
return next;
}
