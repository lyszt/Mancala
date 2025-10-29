.PHONY: build

build: 
	echo "Criando o arquivo de envio para o professor."
	rm -rf build
	mkdir build
	cp ./mancala.asm ./build/joaoluisalmeidasantos_20240002508.asm
	cp ./mancala.asm ./build/mancala.s
	
	sed -i 's/\.end_macro/\.endm/g' ./build/mancala.s
	
	riscv64-unknown-elf-gcc -nostdlib -o ./build/mancala ./build/mancala.s
	rm ./build/mancala.s