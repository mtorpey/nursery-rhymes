LISTED_ITEMS := \
Playtime_Rhymes \
Scores/Boys_and_Girls,_Come_Out_to_Play.mscx \
Scores/Georgie_Porgie.mscx \
Bedtime_Rhymes \
Scores/Come_to_the_Window.mscx \
Scores/Star_Light,_Star_Bright.mscx \
Scores/God_Bless_the_Moon.mscx \
Scores/The_Man_in_the_Moon.mscx \
Scores/How_Many_Miles_to_Babylon.mscx \
Scores/Bossy-cow,_Bossy-cow.mscx \
Scores/Golden_Slumbers.mscx \
Scores/Rockabye,_Baby.mscx \
Scores/Wee_Willie_Winkie.mscx \
Scores/Diddle,_Diddle,_Dumpling.mscx \
Scores/To_Bed,_to_Bed.mscx \
Scores/A_Glass_of_Milk.mscx

SCORES := $(wildcard Scores/*.mscx)
UNLISTED_ITEMS := $(filter-out $(LISTED_ITEMS),$(SCORES))
ITEMS := $(LISTED_ITEMS) Other_Nursery_Rhymes $(UNLISTED_ITEMS)

PDFS := $(patsubst Scores/%.mscx, Output/%.pdf, $(SCORES))
SVGS := $(patsubst Scores/%.mscx, Output/%.svg, $(SCORES))
MIDS := $(patsubst Scores/%.mscx, Output/%.mid, $(SCORES))

all: website $(PDFS)

website: Output/index.html Output/style.css Output/html-midi-player.js | $(SVGS) $(MIDS)

Output/index.html: Resources/template.html generate_webpage $(SCORES) $(SVGS) $(MIDS)
	./generate_webpage $< "$(ITEMS)" Output $@

Output/style.css: Resources/style.css | Output/
	cp $< $@

Output/html-midi-player.js: Resources/html-midi-player.js | Output/
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
