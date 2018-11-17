# updatePDFmetadata
Updates PDF metadata from the commandline using *pdftk*. Special characters are properly escaped using either *recode* or *python3*.

#### Synopsis
	./updatepdfmetadata.sh [--author <author>] [--title <title>] [--subject <subject>] [--custom \"<PDF key>;<value>\"] [--dont-clean] [--print-pdfinfo] <PDF input file> [<output FILE>] [<dump FILE>]

#### Example usage
```bash
# update author
./updatepdfmetadata.sh --author Foo input.pdf

# update title and use non-default output name
./updatepdfmetadata.sh --title "Long title with special characters: äöü" input.pdf myoutput.pdf

# update a custom field
./updatepdfmetadata.sh --custom "Producer;Foo" input.pdf
```

#### Options

All long options are available as short options with their respective first letter (e.g. "-a" for "--author"). Put multiple words in quotes.

	--help : Show usage.
	--author : Change the author field.
	--title : Change the title field.
	--subject : Change the subject field.
	--custom : Change a custom field. Use a semicolon as separator for the key name and value. See the examples. Multiple usage possible.
	--print-pdfinfo : Set this to dump the pdfinfo output of the newly updated PDF file.
	--dont-clean : Set this to not remove any temporary files created for the updating process.
