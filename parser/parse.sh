set -e -x

CHAPTER_NUMBER=$1

if [[ "$CHAPTER_NUMBER" == "" ]]; then
    echo "Usage: ./parser.sh CHAPTER_NUMBER"
    echo "    part_\$CHAPTER_NUMBER.html has to exist then parser will create part_\$CHAPTER_NUMBER.tex."
    exit 1
fi

if [ ! -f "part_$CHAPTER_NUMBER.html" ]; then
    echo "Error: File 'part_$CHAPTER_NUMBER.html' does not exist."
    exit 2
fi

echo "\\weblink{https://www.fanfiction.net/s/5782108/$CHAPTER_NUMBER/}" > part_$CHAPTER_NUMBER.tex
grep "<title" part_$CHAPTER_NUMBER.html | sed -r "s/.*Chapter ([0-9]*): (.*), a harry.*/\\\chapter{Chapter \1: \2}/" >> part_$CHAPTER_NUMBER.tex
grep "nocopy" part_$CHAPTER_NUMBER.html | sed -r "s/^id='storytext'>(.*)/\1/;s/<br( [^>]*|\/)?>/<\/p><p>/g;s/ (<\/[^>]*>) */\1 /g;s/ *(<[^/][^>]*>)  */ \1/g;s/[\"]/ \"/g" | pandoc -f html -t latex | sed -r "s/\\\ldots\{\}/.../g;s/^\"/\`\`/g;s/\"/''/g;s/^ *-  */\"--* /g;s/([-,.?!])  *''/\1''/g;s/( |[,.?!] ?) *-  */\1\"--- /g" >> part_$CHAPTER_NUMBER.tex
