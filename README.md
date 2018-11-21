# small-pdf.sh

## SYNOPSIS

```
$ small-pdf skript.pdf small.pdf
Splitting input file... 13.30s
Degrading pages... 2.00s
Joining pages... 0.22s
New size: 4.0% of input file
```

## DESCRIPTION

Takes a PDF file as input, splits its pages into separate PNGs,
which are then degraded/optimized for space and joins them
together again.

The script is useful for lecture notes taken on a tablet, when
that spits out PDFs containing painfully detailed and large
vector graphics.

## DEPENDENCIES

This is a Perl script and requires, apart from core modules
in Perl v5.10+, the `Path::Tiny`, `File::pushd` and `Sort::Naturally`
modules from CPAN. Furthermore, it needs the `convert` and
`img2pdf` utilities.

A PNG optimizer and other things --- optionally? --- in the
future, maybe.

## BUGS AND CAVEATS

Yes. Currently, the pages come out too small from `convert` to
be suitable for archiving the output of this script over its
input. For some reason, the pages are blurry, too, and one
of the pages in my test PDF looks horribly aliased.
