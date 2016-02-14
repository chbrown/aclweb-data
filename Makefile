BIN := node_modules/.bin

# make:
#   -s --silent --quiet => prevents commands from being echoed
#   -j --jobs N => number of jobs to run simultaneously (if N is omitted, runs them all simultaneously)

all:

$(BIN)/pdfi $(BIN)/academia $(BIN)/tex-node:
	npm install

%.pdf.json: %.pdf $(BIN)/pdfi
	$(BIN)/pdfi paper $< >$@

%.pdf.linked.json: %.pdf.json $(BIN)/academia
	$(BIN)/academia link $< -o $@

%.bib.json: %.bib $(BIN)/tex-node
	$(BIN)/tex-node bib-json $< >$@

%/index.html:
	mkdir -p $(@D)
	curl -s https://aclweb.org/anthology/$*/ > $@

%/index.html.json: %/index.html $(BIN)/acl
	$(BIN)/acl parse-anthology-index --url $*/ <$< >$@

%.pdf:
	mkdir -p $(@D)
	curl -s https://aclweb.org/anthology/$@ > $@
