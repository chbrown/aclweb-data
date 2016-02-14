## acl-anthology

All the data included in this repository is originally available from the main ACL anthology:

> https://aclweb.org/anthology/


### Downloading original sources

Download all the index listings:

    cat ~/github/acl/conferences.yaml | yaml2json | jq -r '.[] | .volumes | .[]' | xargs -I {} make -j 2 {}/index.html

Parse them:

    find . -name index.html | sed s/.html/.html.json/ | xargs make -j 2

Download all of the PDFs:

    cat ?/???/index.html.json | jq -r .pdf.url | egrep '^.{18}$' | xargs make -j 2


### Transformations

Use `pdfi` to extract each PDF into its `academia.Paper` structure.

    find . -name "???-????.pdf" | sed s/.pdf/.pdf.json/ | xargs make -j 2

Use `academia` to determine links in the `academia.Paper` structure.

    find . -name "???-????.pdf.json" | sed s/.pdf.json/.pdf.linked.json/ | xargs make -j 2

Use `tex-node` to convert each BibTeX file into its `tex.models.BibTeXEntry` representation.

    find . -name "???-????.bib" | sed s/.bib/.bib.json/ | xargs make -j 2

Use remote server to do parsing:

    curl -XPOST -s --connect-timeout 600 -T $< http://pdfi-server:8080/readFile?type=paper -o $@


### Miscellaneous cleanup tasks:

Delete `*.pdf.json` files modified earlier than a week ago:

    find . -name '*.pdf.json' -mtime +7 -delete

Delete all empty `*.json` files:

    find . -name '*.json' -size 0 -delete

Delete all `*.pdf.json` files for which remote server parsing failed:

    ag -G '.pdf.json' '502 Bad Gateway' -l | xargs -n 10 rm

Delete all `*.pdf.json` files with invalid JSON:

    find . -name '*.pdf.json' | xargs json-check | xargs rm


## License information

> Materials published in 2015 and years prior are made available under the CC BY-NC-SA license.

> Third party, non-ACL publications (e.g., COLING, LREC materials) that are made available under agreement through the ACL Anthology will continue to retain their original copyrights from the respective party.

> Starting 1 January 2016, all subsequently published ACL conference and workshop publications will be using the Creative Commons Attribution 4.0 International License (CC BY 4.0) to better meet our members' needs for open access to their publications by the public, as agreed to by the ACL executive board in its summer meeting in Beijing, China (during ACL-IJCNLP 2015).
