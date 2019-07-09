
OPTIONS1 = -std=c99 -Wall -Wextra -c
OPTIONS2 = -std=c99 -Wall -Wextra

all: print_trib stage1 stage2 stage3 

cleanall: 
	-rm *.o stage1 stage2 stage3

recursive_trib: recursive_trib.c trib.h
	gcc recursive_trib.c $(OPTIONS1)

print_trib: print_trib.c trib.h
	gcc print_trib.c $(OPTIONS1)

iterative_trib: iterative_trib.c trib.h
	gcc iterative_trib.c $(OPTIONS1)

second_main: second_main.c trib.h
	gcc second_main.c $(OPTIONS1)

personalised_trib: personalised_trib.c trib.h
	gcc personalised_trib.c $(OPTIONS1)

stage1: print_trib.o recursive_trib
	gcc print_trib.c recursive_trib.c -o stage1 $(OPTIONS2)

stage2: print_trib.o iterative_trib
	gcc print_trib.c iterative_trib.c -o stage2 $(OPTIONS2)

stage3: second_main personalised_trib.o
	gcc second_main.c personalised_trib.c -o stage3 $(OPTIONS2)


