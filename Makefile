#
# Makefile
# edgardleal, 2020-02-28 08:08
#

DONE = echo ✓ $@ done
SOURCES = $(shell find ./src -name '*.md')
# Docker = docker run --platform linux/amd64 --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex 
Docker = docker run --platform linux/amd64 --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc-cache

# PANDOC = pandoc
PANDOC = $(Docker)
.PHONY: all clean help lint

.PHONY: phony

FIGURES = $(shell find ./src/img -name '*.png')
# --pdf-engine=xelatex               
PANDOCFLAGS =                                \
  --table-of-contents                        \
	--strip-comments                           \
  --from=markdown+grid_tables+pipe_tables    \
	--lua-filter filters/include-files.lua     \
	--lua-filter filters/cleanup.lua           \
	--lua-filter filters/first-line-indent.lua \
	--lua-filter filters/obsidian-callouts.lua \
	--highlight-style theme_haddock.theme \
	--css=style2.css                      \
  --number-sections                     \
  --indented-code-classes=javascript    \
	-F mermaid-filter                     \
  -V mainfont="Palatino"                \
  -V documentclass=report               \
  -V papersize=A4                       \
  -V geometry:margin=0in                \
  -Vgeometry:paperwidth=6in             \
	-Vgeometry:paperheight=9in            \
	-Vgeometry:margin=0.5in               \
	-Vmainfont="Times New Roman"          \
	-Vfontsize=12pt

  # --highlight-style=monochrome       \
		#
all: epub pdf html

.last_docker_image_build: Dockerfile
	docker build -t pandoc-cache .
	@touch .last_docker_image_build

build_docker_image: .last_docker_image_build

img:
	ln -s ./src/img ./img

tmp:
	mkdir tmp

stat.csv: $(SOURCES) $(FIGURES) style.css
	./stat.sh

setup: build_docker_image output img

output/book.pdf: $(SOURCES) $(FIGURES) style.css setup
	 #pandoc $< -o $@ $(PANDOCFLAGS)
	 $(PANDOC) $(SOURCES) -o $@ $(PANDOCFLAGS)

output/book.odt: $(SOURCES) $(FIGURES) style.css setup
	 #pandoc $< -o $@ $(PANDOCFLAGS)
	 $(PANDOC) $(SOURCES) -o $@ $(PANDOCFLAGS)

output/book.docx: $(SOURCES) $(FIGURES) style.css setup
	 #pandoc $< -o $@ $(PANDOCFLAGS)
	 $(PANDOC) $(SOURCES) -o $@ $(PANDOCFLAGS)

output/cache.html: $(SOURCES) $(FIGURES) style.css setup
	 $(PANDOC) $(SOURCES) -o $@ $(PANDOCFLAGS) --ascii

output/book.epub: $(SOURCES) $(FIGURES) style.css setup stat.csv
	 $(PANDOC) --to epub3 $(SOURCES) -o $@ $(PANDOCFLAGS)

output/book.mobi: $(SOURCES) $(FIGURES) style.css setup stat.csv
	 $(PANDOC) --to mobi $(SOURCES) -o $@ $(PANDOCFLAGS)

pdf: ## pdf: generate a book in pdf format
pdf: output/book.pdf

odt: ## odt: generate a word process version
odt: output/book.odt

docx: ## docx: generate a MS Word version
docx: output/book.docx

mobi: ## mobi: generate a mobi version of this book
mobi: output/book.mobi

epub: ## epub: generate a book in epub format
epub: output/book.epub

html: ## html: generate a html version of the book
html: output/cache.html

output:
	mkdir $@

clean: phony
	 rm -rf ./output
	 rm -rf ./tmp
	 @$(DONE)

open: phony output/book.pdf
	 open output/book.pdf

# vim:ft=make
#
