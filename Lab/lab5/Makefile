#####################################################################
# ECEn 425 Lab 4d Makefile

lab5.bin:	lab5final.s
		nasm lab5final.s -o lab5.bin -l lab5.lst

lab5final.s:	clib.s myisr.s myinth.s yaks.s lab5app.s yakc.s
		cat clib.s myisr.s myinth.s yakc.s yaks.s lab5app.s > lab5final.s

myinth.s:	myinth.c
		cpp myinth.c myinth.i
		c86 myinth.i myinth.s

lab5app.s:	lab5app.c yakk.h clib.h
		cpp lab5app.c lab5app.i
		c86 lab5app.i lab5app.s

yakc.s:		yakc.c yakk.h
		cpp yakc.c yakc.i
		c86 yakc.i yakc.s

clean:
		rm lab5.bin lab5.lst lab5final.s myinth.s myinth.i \
		yakc.s yakc.i lab5app.s lab5app.i
