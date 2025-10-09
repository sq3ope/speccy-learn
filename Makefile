hellosprites.tap: hellosprites.asm
	pasmo --name hellosprites --tapbas hellosprites.asm hellosprites.tap

clean:
	rm *.tap
