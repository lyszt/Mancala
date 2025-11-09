.PHONY: build compose

build: compose
	echo "Criando o arquivo de envio para o professor."
	rm -rf build
	mkdir build
	cp ./mancala.asm ./build/joaoluisalmeidasantos_20240002508.asm

	@mkdir -p Relatório
	- latexmk -pdf -outdir=Relatório Relatório/joaoluisalmeidasantos_20240002408.tex || true
	mv Relatório/joaoluisalmeidasantos_20240002408.pdf build/joaoluisalmeidasantos_20240002408.pdf
compose:
	@mkdir -p "Relatório"
	@python3 -m venv .venv || true
	@. .venv/bin/activate && pip install --upgrade pip Pygments || \
		echo "Warning: could not install Pygments into .venv (check python3 and pip)." >&2
	@echo "Building PDF with latexmk (using pygmentize from .venv if available)"
	@cd "Relatório" && PATH="$(abspath .venv/bin):$$PATH" latexmk -pdf \
		-pdflatex="pdflatex -interaction=nonstopmode -shell-escape %O %S" \
		joaoluisalmeidasantos_20240002408.tex || true

