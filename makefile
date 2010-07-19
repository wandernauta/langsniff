all:
	rock langsniff && strip ./langsniff

tests:
	find tests/ -type f -exec ./langsniff {} \;
	
.PHONY: tests
