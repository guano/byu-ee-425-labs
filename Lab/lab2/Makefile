######################################################################
# Sample EE425 Makefile

lab2.bin:	lab2final.s
		nasm lab2final.s -o lab2.bin -l lab2.lst  # Step 4, Assemble

lab2final.s:	clib.s lab2.s
		cat clib.s lab2.s > lab2final.s        # Step 3, Concatenate

lab2.s:	lab2.c
		cpp lab2.c lab2.i      # Step 1, Preprocess
		c86 -g lab2.i lab2.s   # Step 2, Compile

clean:	
		rm lab2.bin lab2.lst lab2final.s lab2.s lab2.i

