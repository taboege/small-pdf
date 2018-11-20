#!/bin/sh

# FIXME:
#   - The pages have the wrong size and are blurry in qpdfview
#     (because it scales for some reason?). It's sharp in mupdf.
#
# TODO:
#   + Support -density and -adaptive-resize to control page sizes.
#   + Option to use jpeg with a -quality setting instead of png.

infile="$1"
outfile="$2"
if [ -z "$infile" -o -z "$outfile" ]
then echo Usage: $0 INFILE OUTFILE >&2
  exit 1
fi

# Be extra-extra careful with any `rm`
tmp=$(mktemp -d)
if [ "$?" -gt 0 -o -z "$tmp" -o ! -d "$tmp" ]
then echo Something is wrong with the temporary directory. Bailing out >&2
  exit 1
fi
cleanup() {
  rm -f "$tmp/$infile"-*.png && rmdir "$tmp"
}
trap cleanup EXIT

time_task() {
  start=$(date +%s.%N)
  echo -n "$1... "
  $2
  bc <<<"scale=2; $(date +%s.%N) - $start" |
    xargs printf "%.2fs\n"
}

split_pages() {
  convert "$infile" "$tmp/$infile-%d.png"
}

degrade_pages() {
  pushd "$tmp" >/dev/null
    mogrify -background white -alpha off \
      -colors 256 -depth 8 +dither \
      -compress zip -strip *.png
  popd >/dev/null
}

join_pages() {
  ls "$tmp"/*.png | sort -V | xargs \
    img2pdf --output "$outfile"
    # or: pdfjoin -q --rotateoversize false -o "$outfile"
}

time_task "Splitting input file" split_pages
time_task "Degrading pages"      degrade_pages
time_task "Joining pages"        join_pages

bc <<<"scale=2; 100*$(stat -c%s "$outfile") / $(stat -c%s "$infile")" |
  xargs printf "New size: %.1f%% of input file\n"
