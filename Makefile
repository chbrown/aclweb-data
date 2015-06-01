%.pdf.json: %.pdf
	pdfi json -f $< >$@
