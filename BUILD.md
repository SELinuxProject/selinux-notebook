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

# Build HTML or PDF Versions

The SELinux Notebook can be rendered in both HTML and PDF using the included
Makefile.  In order to build these versions of the notebook, "pandoc" and
"weasyprint" must be installed on your system; consult your distribution
documentation for information on installing these packages.

Once the required packages are installed can generate the PDF notebook with the
following command:

	% make pdf

... and the following will generate the HTML notebook:

	% make html

The PDF and HTML notebooks will be generated in newly created "pdf" and "html"
directories.
