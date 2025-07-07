# object files for shared libraries need to be compiled as position independent
# code (-fPIC) because they are mapped to any position in the address space.

VERSION := 2024.2

CFLAGS += -O0 -Wall -Werror -I./include -std=c99 -fPIC
ifndef RANLIB
	RANLIB = ranlib
endif

# COMPILING SETUP
CC        = gcc
LD        = ld
AR        = ar
RANLIB    = ranlib

all: c_bin deb

.PHONY: deb

deb: is_documented
	rm -rf build/deb

	# temporary fpm source
	mkdir -p build/deb/is-documented/usr/local/bin/is-documented/
	cp is_documented build/deb/is-documented/usr/local/bin/
	cp config.cfg build/deb/is-documented/usr/local/bin/is-documented/
	cp doxygen build/deb/is-documented/usr/local/bin/is-documented/
	mkdir -p build/deb/is-documented/usr/local/share/man/man3
	#cp -r $(MANS) build/deb/is-documented/usr/local/share/man/man3
	fpm \
	    --after-install postinst \
	    --after-remove postrm \
	    --category apps \
	    --chdir build/deb/is-documented \
	    --deb-priority optional \
	    --description "Check doxygen documentation for C functions" \
	    --input-type dir \
	    --maintainer "Intro_SW" \
	    --name is-documented \
	    --output-type deb \
	    --package build/deb \
	    --provides is-documented \
	    --replaces is-documented \
	    --url https://www.istr.unican.es/asignaturas/intro_sw/ \
	    --vendor Intro_SW \
	    --version $(VERSION) \
	    --depends gcc
	    .

	rm -rf build/deb/is-documented

clean:
	rm -rf build/deb
