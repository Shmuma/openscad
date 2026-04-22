# path to the openscad binary
OSCAD := "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
SHELL := /bin/bash
SCRIPT := Panov10x5.scad
OUT := stl-Panov10x5

LANGS := en ru de fr sv


.PHONY: langs $(LANGS)
all: $(OUT)/pieces.stl $(OUT)/two_colors/frame.stl langs

$(OUT)/pieces.stl: $(SCRIPT)
	$(OSCAD) -o $@ -D generate=\"pieces\" $<

$(OUT)/two_colors/frame.stl: $(SCRIPT)
	$(OSCAD) -o $@ -D generate=\"2col_frame\" $<

langs: $(LANGS)
	for lang in $^; do \
		$(OSCAD) -o $(OUT)/simple/simple-base-$$lang.stl -D generate=\"simple_base\" -D text_lang=\"$$lang\" $(SCRIPT) ; \
		$(OSCAD) -o $(OUT)/two_colors/text-$$lang.stl -D generate=\"2col_text\" -D text_lang=\"$$lang\" $(SCRIPT) ; \
		$(OSCAD) -o $(OUT)/two_colors/plate-$$lang.stl -D generate=\"2col_plate\" -D text_lang=\"$$lang\" $(SCRIPT) ; \
	done
