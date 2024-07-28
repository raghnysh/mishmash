.PHONY: all
all:
	latexmk -pdf -file-line-error -halt-on-error -interaction=nonstopmode -synctex=1 notes.tex

.PHONY: clean
clean:
	latexmk -C -pdf -bibtex -e '$$clean_ext="run.xml synctex.gz"' notes.tex

.PHONY: upload
upload:
	rclone copyto notes.pdf 'gdrive-raghnysh:$(notdir ${CURDIR}).pdf'
