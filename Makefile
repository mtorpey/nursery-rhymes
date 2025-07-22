SCORES := $(wildcard Scores/*.mscx)
PDFS := $(patsubst Scores/%.mscx, Output/%.pdf, $(SCORES))
SVGS := $(patsubst Scores/%.mscx, Output/%.svg, $(SCORES))
MIDS := $(patsubst Scores/%.mscx, Output/%.mid, $(SCORES))

all: website $(PDFS)

website: Output/index.html Output/style.css $(SVGS) $(MIDS)

Output/index.html: Resources/template.html $(SCORES) | Output/
	./generate_webpage $< Scores Output $@

Output/style.css: Resources/style.css | Output/
	cp $< $@

Output/%.svg: Scores/%.mscx | Output/
	tmpdir=$$(mktemp -d); \
	musescore --export-to $$tmpdir/out.svg $< 2> /dev/null; \
	mv $$tmpdir/out-1.svg $@

Output/%.pdf: Scores/%.mscx | Output/
	musescore --export-to $@ $<

Output/%.mid: Scores/%.mscx | Output/
	musescore --export-to $@ $<

Output/:
	mkdir -p $@

clean:
	rm -rf Output/
