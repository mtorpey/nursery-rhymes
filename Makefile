LISTED_ITEMS := \
Nursery_Rhymes \
Scores/Little_Boy_Blue.mscx \
Scores/Little_Bo-Peep.mscx \
Scores/Mary_Had_a_Little_Lamb.mscx \
Scores/I_Saw_a_Ship_A-Sailing.mscx \
Scores/Little_Jack_Horner.mscx \
Animal_Rhymes \
Scores/Hickety,_Pickety,_My_Black_Hen.mscx \
Scores/Cackle,_Cackle,_Mother_Goose.mscx \
Scores/Pussy-cat,_Pussy-cat.mscx \
Scores/Six_Little_Mice.mscx \
Scores/A_Cat_Came_Fiddling.mscx \
Scores/Three_Young_Rats.mscx \
Scores/There_Was_an_Owl.mscx \
Scores/Goosey,_Goosey,_Gander.mscx \
Scores/Higglety,_Pigglety,_Pop.mscx \
Playtime_Rhymes \
Scores/Boys_and_Girls,_Come_Out_to_Play.mscx \
Scores/Georgie_Porgie.mscx \
Scores/Dance_to_Your_Daddy.mscx \
Scores/I_Love_Little_Pussy.mscx \
Scores/Rain,_Rain,_Go_Away.mscx \
Scores/Gypsies_in_the_Wood.mscx \
Scores/Ride_a_Cock_Horse.mscx \
Scores/Tom,_Tom,_the_Pipers_Son_Learned_to_Play.mscx \
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
ITEMS := $(LISTED_ITEMS) Other_Songs $(UNLISTED_ITEMS)

PDFS := $(patsubst Scores/%.mscx, Output/%.pdf, $(SCORES))
SVGS := $(patsubst Scores/%.mscx, Output/%.svg, $(SCORES))
MIDS := $(patsubst Scores/%.mscx, Output/%.mid, $(SCORES))

all: website $(PDFS) Output/nursery-rhymes-book.pdf Output/nursery-rhymes.pdf

deploy: all
	rsync -r --delete -e ssh Output/ root@myoung.uk:/var/www/html/nursery-rhymes/

Output/nursery-rhymes-book.pdf: Output/nursery-rhymes.pdf
	pdfbook2 --paper=a4paper --short-edge --no-crop $<

Output/nursery-rhymes.pdf: Output/index.html Output/style.css $(SVGS)
	chromium --headless --print-to-pdf=$@ $<

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

debug:
	@echo $(UNLISTED_ITEMS)
