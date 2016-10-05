#####################################################################
# ECEn 425 Lab 3 Makefile

#add in the yaku.h, yakk.h, yakc.c, yaks.s

lab4b.bin:	lab4bfinal.s
		nasm lab4bfinal.s -o lab4b.bin -l lab4b.lst

lab4bfinal.s:	clib.s myisr.s myinth.s lab4b_app.s
		cat clib.s myisr.s myinth.s lab4b_app.s > lab4bfinal.s

myinth.s:	myinth.c
		cpp myinth.c myinth.i
		c86 -g myinth.i myinth.s

lab4b_app.s:	lab4b_app.c
		cpp lab4b_app.c lab4b_app.i
		c86 -g lab4b_app.i lab4b_app.s

clean:
		rm lab4b.bin lab4.lst lab4bfinal.s myinth.s myinth.i \
		lab4b_app.s lab4b_app.i
