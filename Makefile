# find . -name "???-????.pdf" | sed 's/.pdf/.pdf.json/' | xargs make -j 5
%.pdf.json: %.pdf
	curl -XPOST -s --connect-timeout 600 -T $< http://pdfi-server:8001/readFile?type=paper -o $@
	# pdfi paper $< >$@

# find . -name "???-????.pdf.json" | sed 's/.pdf.json/.pdf.linked.json/' | xargs make -s -j 2
%.pdf.linked.json: %.pdf.json
	academia link $< -o $@

# find . -name "???-????.bib" | sed 's/.bib/.bib.json/' | xargs make -j 2
%.bib.json: %.bib
	tex-cli bib-json $< >$@

# miscellaneous cleanup tasks
# find . -name '*.pdf.json' -mtime +7 -delete
# find . -name '*.json' -size 0 -delete
# ag -G '.pdf.json' '502 Bad Gateway' -l | xargs -n 10 rm
# find . -name "???-????.pdf.json" | xargs json-check | xargs rm
