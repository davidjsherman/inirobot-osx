# Makefile for building MacOS app bundles
#
# Default target builds Scratch2-ThymioII.app
# To build the menu items use:
#   make BUNDLE=AsebaHTTP-Menu.app SCRIPT=asebahttp-menu.perl PROFILE=AsebaHTTP-Menu.platypus
#   make BUNDLE=AsebaScratch-Menu.app SCRIPT=asebascratch-menu.perl PROFILE=AsebaScratch-Menu.platypus

BUNDLE = Scratch2-ThymioII.app
SCRIPT = asebascratch-none.perl
PROFILE = Scratch2-ThymioII.platypus

DASHEL = ~/src/xcode-dashel
PORTLIST = $(DASHEL)/portlist

ASEBA = ~/work/xcode-aseba
ASEBAHTTP = $(ASEBA)/switches/http/Debug/asebahttp
ASEBASCRATCH = $(ASEBA)/examples/clients/scratch/Debug/asebascratch
PROGRAMS = $(PORTLIST) $(ASEBAHTTP) $(ASEBASCRATCH)

LIBS = /usr/lib/libxml2.2.dylib /usr/lib/liblzma.5.dylib /usr/lib/libiconv.2.dylib
change = -change /usr/lib/libxml2.2.dylib @executable_path/../Frameworks/libxml2.2.dylib \
	 -change /usr/lib/liblzma.5.dylib @executable_path/../Frameworks/liblzma.5.dylib \
	 -change /usr/lib/libiconv.2.dylib @executable_path/../Frameworks/libiconv.2.dylib

all:	bundle

bundle:	app libs pgms

app:	$(SCRIPT)
	rm -rf "$(BUNDLE)"
	platypus -P "$(PROFILE)" "$(BUNDLE)"

libs:	$(LIBS)
	mkdir -p "$(BUNDLE)"/Contents/Frameworks
	install $^ "$(BUNDLE)"/Contents/Frameworks

pgms:	$(PROGRAMS)
	install $^ "$(BUNDLE)"/Contents/MacOS/
	install_name_tool $(change) "$(BUNDLE)"/Contents/MacOS/asebahttp
	install_name_tool $(change) "$(BUNDLE)"/Contents/MacOS/asebascratch
