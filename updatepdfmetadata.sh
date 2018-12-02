#!/usr/bin/env python3

import sys
import os.path as path
from pdfrw import PdfReader, PdfWriter

myName = sys.argv[0] + ":"

if len(sys.argv) <= 2:
	print(myName, "Usage: " + myName + " [--author <author>] [--title <title>] [--subject <subject>] [--custom <key> <value>] [<PDF output FILE>] <PDF input FILE>")
	exit(1)

inputFile = sys.argv[-1]
outputFile = "edited.pdf"

if not path.isfile(inputFile):
	print(myName, "Input file not found (" + inputFile + ").")
	exit(1)

trailer = PdfReader(inputFile)
writer = PdfWriter()
writer.trailer = trailer
baseStr = 'trailer.Info.'

options = {
	'-a' : (1, baseStr + 'Author'),
	'-t' : (1, baseStr + 'Title'),
	'-s' : (1, baseStr + 'Subject'),
	'-c' : (2, baseStr),
}

allOptions = {
	'-a'		: options['-a'],
	'--author'	: options['-a'],
	'-t'		: options['-t'],
	'--title'	: options['-t'],
	'-s'		: options['-s'],
	'--subject'	: options['-s'],
	'-c'		: options['-c'],
	'--custom'	: options['-c'],
}

argList = sys.argv[1:-1]
argListIt = enumerate(argList, 1)
for idx, arg in argListIt:
	nArgs, execStr = allOptions.get(arg, (-1, None))
	if nArgs == 1:
		if idx >= len(argList):
			print(myName, "Please provide an author to the '" + arg + "' flag.")
			exit(1)
		idx, nextArg = next(argListIt, None)
		exec(execStr + ' = \'' + nextArg + '\'')
	elif nArgs == 2:
		if idx + 1 >= len(argList):
			print(myName, "Please provide both type and value to the '" + arg + "' flag.")
			exit(1)
		idx, nextArg = next(argListIt, None)
		idx, nextnextArg = next(argListIt, None)
		exec(execStr+nextArg + ' = \'' + nextnextArg+'\'')
	elif idx == len(argList):
		outputFile = arg
		print(myName, "Writing output to:", outputFile)
	elif nArgs == -1:
		print(myName, "Unknown option: " + arg)
		exit(1)
	else:
		print(myName, "Implementation error!")
		exit(1)

writer.write(outputFile)
