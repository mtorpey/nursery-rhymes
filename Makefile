SCORES := $(wildcard Scores/*.mscx)
PDFS := $(patsubst Scores/%.mscx, Output/%.pdf, $(SCORES))
SVGS := $(patsubst Scores/%.mscx, Output/%.svg, $(SCORES))
MIDS := $(patsubst Scores/%.mscx, Output/%.mid, $(SCORES))

all: $(PDFS) $(SVGS) $(MIDS)

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
