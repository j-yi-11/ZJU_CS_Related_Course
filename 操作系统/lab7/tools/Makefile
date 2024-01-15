all: mksfs

mksfs: mksfs.c
	gcc $< -o $@
	
clean:
	$(shell test -f mksfs && rm mksfs)