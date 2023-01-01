extends Node

# HERE YOU'LL WRITE ALL OF YOUR COMMANDS

enum {
	INT,
	STRING,
	BOOL,
	FLOAT
}

# HERE IS WHERE YOU'RE GONNA WRITE YOUR COMMAND FUNCTION NAMES
const valid_commands = [
	["someFunction"], # ARRAYS WITH SIZE 1 DON'T REQUIRE PARAMETERS
	["anotherFunction", [INT, STRING, BOOL, FLOAT]]
]

# PREFERABLY YOU WOULD PUT SOMETHING USEFUL INSIDE THESE
func someFunction():
	print("Happy new year!")
	return "Thank you!"
# IT'S ALSO VERY IMPORTANT TO END ALL YOUR FUNCTIONS WITH A STRING RETURN !!!!!!!!!!

func anotherFunction(i, s, b, f):
	for x in [i, s, b, f]:
		print(x)
	return "Nice variables. They're mine now."
