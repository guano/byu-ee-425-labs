#####################################################################
# ECEn 425 Lab 3 Makefile

lab3.bin:	lab3final.s
		nasm lab3final.s -o lab3.bin -l lab3.lst

lab3final.s:	clib.s isr.s interrupt_handler.s primes.s
		cat clib.s isr.s interrupt_handler.s primes.s > lab3final.s

interrupt_handler.s:	interrupt_handler.c
		cpp interrupt_handler.c interrupt_handler.i
		c86 -g interrupt_handler.i interrupt_handler.s

primes.s:	primes.c
		cpp primes.c primes.i
		c86 -g primes.i primes.s

clean:
		rm lab3.bin lab3.lst lab3final.s interrupt_handler.s interrupt_handler.i \
		primes.s primes.i
