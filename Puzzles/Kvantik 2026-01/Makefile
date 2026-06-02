# path to the openscad binary
OSCAD := "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
SHELL := /bin/bash
SCRIPT_CALENDAR := calendar-windows.scad
OUT_CALENDAR := stl-Calendar
LANGS := en ru de fr sv

.PHONY: all_calendar dirs langs $(LANGS)

all_calendar: dirs $(OUT_CALENDAR)/pieces.stl langs_calendar $(OUT_CALENDAR)/two_colors/frame.stl

dirs:
	mkdir -p $(OUT_CALENDAR)/{simple,two_colors}

$(OUT_CALENDAR)/pieces.stl: $(SCRIPT_CALENDAR)
	$(OSCAD) -o $@ -D generate=\"pieces\" $<

$(OUT_CALENDAR)/two_colors/frame.stl: $(SCRIPT_CALENDAR)
	$(OSCAD) -o $@ -D generate=\"2col_frame\" $<

langs_calendar: $(LANGS)
	for lang in $^; do \
		$(OSCAD) -o $(OUT_CALENDAR)/simple/simple-base-$$lang.stl -D generate=\"simple_base\" -D text_lang=\"$$lang\" $(SCRIPT_CALENDAR) ; \
		$(OSCAD) -o $(OUT_CALENDAR)/simple/simple-base-text-$$lang.stl -D generate=\"simple_text\" -D text_lang=\"$$lang\" $(SCRIPT_CALENDAR) ; \
		$(OSCAD) -o $(OUT_CALENDAR)/two_colors/text-$$lang.stl -D generate=\"2col_text\" -D text_lang=\"$$lang\" $(SCRIPT_CALENDAR) ; \
		$(OSCAD) -o $(OUT_CALENDAR)/two_colors/plate-$$lang.stl -D generate=\"2col_plate\" -D text_lang=\"$$lang\" $(SCRIPT_CALENDAR) ; \
	done
