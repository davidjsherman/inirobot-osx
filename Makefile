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
PORTLIST = $(DASHEL)/Debug/portlist

ASEBA = ~/work/xcode-aseba
ASEBAHTTP = $(ASEBA)/switches/http/Debug/asebahttp
ASEBASCRATCH = $(ASEBA)/examples/clients/scratch/Debug/asebascratch
PROGRAMS = $(PORTLIST) $(ASEBAHTTP) $(ASEBASCRATCH)

SHLIBDASHEL = $(shell echo $(PROGRAMS) | fmt -w1 | xargs otool -L | grep -m1 libdashel | cut -f1 -d\ )

LIBS = /usr/lib/libxml2.2.dylib /usr/lib/liblzma.5.dylib /usr/lib/libiconv.2.dylib $(SHLIBDASHEL)
change = -change /usr/lib/libxml2.2.dylib @executable_path/../Frameworks/libxml2.2.dylib \
	 -change /usr/lib/liblzma.5.dylib @executable_path/../Frameworks/liblzma.5.dylib \
	 -change /usr/lib/libiconv.2.dylib @executable_path/../Frameworks/libiconv.2.dylib \
	 $(if $(SHLIBDASHEL),-change $(SHLIBDASHEL) @executable_path/../Frameworks/libdashel.1.dylib)

all:
	echo SHLIBDASHEL $(SHLIBDASHEL) $(change)
	$(MAKE) bundle
	$(MAKE) bundle BUNDLE=AsebaHTTP-Menu.app SCRIPT=asebahttp-menu.perl PROFILE=AsebaHTTP-Menu.platypus
	$(MAKE) bundle BUNDLE=AsebaScratch-Menu.app SCRIPT=asebascratch-menu.perl PROFILE=AsebaScratch-Menu.platypus

bundle:	app libs pgms

app:	$(SCRIPT)
	rm -rf "$(BUNDLE)"
	platypus -P "$(PROFILE)" "$(BUNDLE)"

libs:	$(LIBS)
	mkdir -p "$(BUNDLE)"/Contents/Frameworks
	install $^ "$(BUNDLE)"/Contents/Frameworks
	$(if $(SHLIBDASHEL),install_name_tool -id @executable_path/../Frameworks/libdashel.1.dylib "$(BUNDLE)"/Contents/Frameworks/libdashel.1.dylib)

pgms:	$(PROGRAMS)
	install $^ "$(BUNDLE)"/Contents/MacOS/
	install_name_tool $(change) "$(BUNDLE)"/Contents/MacOS/portlist
	install_name_tool $(change) "$(BUNDLE)"/Contents/MacOS/asebahttp
	install_name_tool $(change) "$(BUNDLE)"/Contents/MacOS/asebascratch
