# Using Firefox with a Markdown Viewer

The Notebook \*.md files can be viewed using Firefox with the following
Markdown Viewer: <https://github.com/KeithLRobertson/markdown-viewer>

Extract from the README:

On Linux: Firefox may not know how to handle markdown files by default.
A workaround for this is to add a new MIME type for markdown file extensions.
Add the following XML to *~/.local/share/mime/packages/text-markdown.xml*:

```
<?xml version="1.0"?>
<mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
  <mime-type type="text/plain">
    <glob pattern="*.md"/>
    <glob pattern="*.mkd"/>
    <glob pattern="*.mkdn"/>
    <glob pattern="*.mdwn"/>
    <glob pattern="*.mdown"/>
    <glob pattern="*.markdown"/>
  </mime-type>
</mime-info>
```

Then run:

`update-mime-database ~/.local/share/mime`

<br>

# Build Single HTML or PDF files

The `Makefile` is work in progress as the PDF files produced have issues
rendering complex tables and/or images to fit a page.

Pandoc is required to build the HTML version:

`dnf install pandoc`

and these build the PDF versions:

```
dnf install weasyprint
dnf install texlive
```

Use `make html` or `make pdf`

The `make html` target will build *html/SELinux_Notebook.html*, then use this
to produce the PDF versions.

The *html/SELinux_Notebook.html* renders in a brower ok, however the PDF
versions have issues with either `make html` or `make pdf`, for example:

-   With **--pdf-engine=weasyprint**, the larger images (e.g Figure 2) and
    larger tables (e.g. those in the 'Using libselinux Functions' section)
    are not rendered to fit page and are therefore chopped.
-   With **--pdf-engine=xelatex**, the more complex tables are not rendered
    correctly.
