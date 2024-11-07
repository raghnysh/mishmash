.PHONY: all clean upload

all: lua pdf

clean:
	if test -e notes.ltx; then latexmk -C -pdf -bibtex -e '$$clean_ext="run.xml synctex.gz synctex.orig.gz"' notes.ltx; ${RM} notes.ltx; fi
	${RM} lpegexam.lua

upload:
	rclone copyto notes.pdf 'gdrive-raghnysh:$(notdir ${CURDIR}).pdf'


.PHONY: lua pdf

lua: lpegexam.lua
	lua lpegexam.lua

pdf: notes.synctex.orig.gz

lpegexam.lua: notes.tex
	notangle -Rlpegexam.lua notes.tex > lpegexam.lua

notes.synctex.orig.gz: notes.pdf
	cp notes.synctex.gz notes.synctex.orig.gz && gunzip -c notes.synctex.orig.gz | sed 's@notes\.ltx@notes.tex@' | gzip > notes.synctex.gz

notes.pdf: notes.ltx force
	latexmk -pdf -file-line-error -halt-on-error -interaction=nonstopmode -synctex=1 notes.ltx

notes.ltx: notes.tex
	noweave -delay -index notes.tex > notes.ltx

.PHONY: force
