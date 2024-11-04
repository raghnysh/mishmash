.PHONY: all
all: lpegexam.fnl notes.synctex.orig.gz

notes.synctex.orig.gz: notes.pdf
	cp notes.synctex.gz notes.synctex.orig.gz && gunzip -c notes.synctex.orig.gz | sed 's@notes\.ltx@notes.tex@' | gzip > notes.synctex.gz

.PHONY: force
notes.pdf: notes.ltx force
	latexmk -pdf -file-line-error -halt-on-error -interaction=nonstopmode -synctex=1 notes.ltx

notes.ltx: notes.tex
	noweave -delay -index notes.tex > notes.ltx

lpegexam.fnl: notes.tex
	notangle -Rlpegexam.fnl notes.tex > lpegexam.fnl
	fennel lpegexam.fnl

.PHONY: clean
clean:
	if test -e notes.ltx; then latexmk -C -pdf -bibtex -e '$$clean_ext="run.xml synctex.gz synctex.orig.gz"' notes.ltx; ${RM} notes.ltx; fi
	${RM} lpegexam.fnl

.PHONY: upload
upload:
	rclone copyto notes.pdf 'gdrive-raghnysh:$(notdir ${CURDIR}).pdf'
