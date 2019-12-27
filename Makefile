
all:
	find . -type d -maxdepth 1 -execdir sh -c 'cd "{}" && latexmk -pdf' \;
	
clean:
	find . -type d -maxdepth 1 -execdir sh -c 'cd "{}" && latexmk -c' \;
