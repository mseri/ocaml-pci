.PHONY: build release install uninstall clean test doc reindent

release:
	jbuilder build @install

build:
	jbuilder build @install --dev

install:
	jbuilder install

uninstall:
	jbuilder uninstall

clean:
	jbuilder clean

test:
	jbuilder runtest

# requires odoc
doc:
	jbuilder build @doc

gh-pages:
	bash .docgen.sh

travis-coveralls.sh:
	wget https://raw.githubusercontent.com/simonjbeaumont/ocaml-travis-coveralls/master/$@

coverage: travis-coveralls.sh
	bash $<
