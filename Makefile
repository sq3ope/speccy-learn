helloworld.tap: helloworld.asm
	pasmo --name HelloWorld --tapbas helloworld.asm helloworld.tap

clean:
	rm *.tap

