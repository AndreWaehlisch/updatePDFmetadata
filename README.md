# updatePDFmetadata
Updates PDF metadata from the commandline using *pdfrw* of python3. Special characters are properly escaped.

#### Synopsis
	./updatepdfmetadata.sh [--author <author>] [--title <title>] [--subject <subject>] [--custom \"<PDF key>;<value>\"] [<output FILE>] <PDF input file>

#### Example usage
```bash
# update author
./updatepdfmetadata.sh --author Foo input.pdf

# update title and use non-default output name
./updatepdfmetadata.sh --title "Long title with special characters: äöü" myoutput.pdf input.pdf

# update a custom field
./updatepdfmetadata.sh --custom Producer Foo input.pdf
```

#### Options

All long options are available as short options with their respective first letter (e.g. "-a" for "--author"). Put multiple words in quotes.

	--author : Change the author field.
	--title : Change the title field.
	--subject : Change the subject field.
	--custom : Change a custom field. Use a semicolon as separator for the key name and value. See the examples. Multiple usage possible.
