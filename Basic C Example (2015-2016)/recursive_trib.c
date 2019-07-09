#include "trib.h"



int tribcalc(int num){
	switch(num){
		case 1: return 0;
		case 2: return 0;
		case 3: return 1;
		default: return tribcalc(num-1) + tribcalc(num-2) + tribcalc(num-3);
	}
}
