# Viewing the Markdown Versions

In addition to viewing the notebook markdown files on GitHub, the markdown
files can be viewed with Firefox using the following Markdown Viewer:

* https://github.com/KeithLRobertson/markdown-viewer

Extract from the README:

> On Linux: Firefox may not know how to handle markdown files by default.
> A workaround for this is to add a new MIME type for markdown file extensions.
> Add the following XML to *~/.local/share/mime/packages/text-markdown.xml*:
> 
> ```xml
> <?xml version="1.0"?>
> <mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
>   <mime-type type="text/plain">
>     <glob pattern="*.md"/>
>     <glob pattern="*.mkd"/>
>     <glob pattern="*.mkdn"/>
>     <glob pattern="*.mdwn"/>
>     <glob pattern="*.mdown"/>
>     <glob pattern="*.markdown"/>
>   </mime-type>
> </mime-info>
> ```
> 
> Then run:
> 
>     % update-mime-database ~/.local/share/mime

# Build HTML, PDF, or EPUB Versions

The SELinux Notebook can be rendered in HTML, PDF, or EPUB using the included
Makefile.  In order to build these versions of the notebook, "pandoc" and
"weasyprint" must be installed on your system; consult your distribution
documentation for information on installing these packages.

The EPUB build will also produce a Kindle "azw3" formatted version if "calibre"
is installed on your system (specifically the "ebook-convert" command).

Once the required packages are installed can generate the PDF notebook with the
following command:

	% make pdf

... the following will generate the HTML notebook:

	% make html

... and the following will generate the EPUB notebook:

	% make epub

The PDF, HTML, and EPUB notebooks will be generated in newly created "pdf",
"html" and "epub" directories.

**Notes:**

- The Notebook examples are not embedded into any of the document formats,
  however they will have links to them via their build directory.
- When viewing the Notebook EPUB version, eBook readers do vary on rendering
  tables, displaying images and resolving links to the examples. For Linux,
  Foliate was found to be the most consistent, and can be found at:
  <https://github.com/johnfactotum/foliate>
