# Variables
JAVAC = javac
JAVA = java
SOURCE_DIR = src
CLASS_DIR = bin
MAIN_CLASS = WordCounterMaster

# Targets
all: compile run

compile:
	@mkdir -p $(CLASS_DIR)
	$(JAVAC) -d $(CLASS_DIR) $(SOURCE_DIR)/*.java

#	$(JAVA) -cp .:$(CLASS_DIR) $(MAIN_CLASS) && \
run: compile
	cd ./bin && \
	mkdir -p text_files && \
	cd text_files && \
	wget -q https://www.gutenberg.org/cache/epub/84/pg84.txt && \
	wget -q https://www.gutenberg.org/cache/epub/1342/pg1342.txt && \
	wget -q https://www.gutenberg.org/cache/epub/1513/pg1513.txt && \
	$(JAVA) $(MAIN_CLASS) && \
	cd ..

clean:
	rm -rf $(CLASS_DIR) shared_data.txt text_files *.txt *.txt.1

.PHONY: all compile run clean