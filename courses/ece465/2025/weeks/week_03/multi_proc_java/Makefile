# Variables
JAVAC = javac
JAVA = java
SOURCE_DIR = src
CLASS_DIR = bin
MAIN_CLASS = MasterProcess

# Targets
all: compile run

compile:
	@mkdir -p $(CLASS_DIR)
	$(JAVAC) -d $(CLASS_DIR) $(SOURCE_DIR)/*.java

run: compile
	$(JAVA) -cp $(CLASS_DIR) $(MAIN_CLASS)

clean:
	rm -rf $(CLASS_DIR) shared_data.txt

.PHONY: all compile run clean