# path to the openscad binary
OSCAD := "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
SHELL := /bin/bash
SCRIPT_PANOV := Panov10x5.scad
OUT_PANOV := stl-Panov10x5
SCRIPT_DF := DragonFjord.scad
OUT_DF := stl-DragonFjord
LANGS := en ru de fr sv

.PHONY: all_panov dirs langs $(LANGS)

dirs:
	mkdir -p $(OUT_PANOV)/{simple,two_colors}
	mkdir -p $(OUT_DF)/{simple,two_colors}


all_panov: dirs $(OUT_PANOV)/pieces.stl $(OUT_PANOV)/two_colors/frame.stl langs

$(OUT_PANOV)/pieces.stl: $(SCRIPT_PANOV)
	$(OSCAD) -o $@ -D generate=\"pieces\" $<

$(OUT_PANOV)/two_colors/frame.stl: $(SCRIPT_PANOV)
	$(OSCAD) -o $@ -D generate=\"2col_frame\" $<

langs_panov: $(LANGS)
	for lang in $^; do \
		$(OSCAD) -o $(OUT_PANOV)/simple/simple-base-$$lang.stl -D generate=\"simple_base\" -D text_lang=\"$$lang\" $(SCRIPT_PANOV) ; \
		$(OSCAD) -o $(OUT_PANOV)/two_colors/text-$$lang.stl -D generate=\"2col_text\" -D text_lang=\"$$lang\" $(SCRIPT_PANOV) ; \
		$(OSCAD) -o $(OUT_PANOV)/two_colors/plate-$$lang.stl -D generate=\"2col_plate\" -D text_lang=\"$$lang\" $(SCRIPT_PANOV) ; \
	done


all_df: dirs $(OUT_DF)/pieces.stl $(OUT_DF)/two_colors/frame.stl langs_df


$(OUT_DF)/pieces.stl: $(SCRIPT_DF)
	$(OSCAD) -o $@ -D generate=\"pieces\" $<

$(OUT_DF)/two_colors/frame.stl: $(SCRIPT_DF)
	$(OSCAD) -o $@ -D generate=\"2col_frame\" $<

langs_df: $(LANGS)
	for lang in $^; do \
		$(OSCAD) -o $(OUT_DF)/simple/simple-base-$$lang.stl -D generate=\"simple_base\" -D text_lang=\"$$lang\" $(SCRIPT_DF) ; \
		$(OSCAD) -o $(OUT_DF)/two_colors/text-$$lang.stl -D generate=\"2col_text\" -D text_lang=\"$$lang\" $(SCRIPT_DF) ; \
		$(OSCAD) -o $(OUT_DF)/two_colors/plate-$$lang.stl -D generate=\"2col_plate\" -D text_lang=\"$$lang\" $(SCRIPT_DF) ; \
	done
