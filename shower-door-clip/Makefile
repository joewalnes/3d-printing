# Makefile for converting .scad files to .stl and previewing.
# You should have 'openscad' and 'meshlab' installed.

# -Joe Walnes

MODEL=shower-door-clip

$(MODEL).stl: $(MODEL).scad
	openscad -s $@ $<

preview: $(MODEL).stl
	meshlab $^
.PHONY: preview

