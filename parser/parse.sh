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

_PARSER_GET_CONTENT="s/^id='storytext'>(.*)/\1/"
_PARSER_REPLACE_BR="s/<br( [^>]*|\/)?>/<\/p><p>/g"
_PARSER_FIX_SPACES_AROUND_CLOSE_TAGS="s/ (<\/[^>]*>) *([^\"])/\1 \2/g"
_PARSER_FIX_SPACES_AROUND_OPEN_TAGS="s/([^\"]) *(<[^/][^>]*>)  */\1 \2/g"
_PARSER_FIX_SPACES_BEFORE_QUOTE="s/([^ >][\"])/ \1/g"
PARSER_EXTRACT_CONTENT="$_PARSER_GET_CONTENT;$_PARSER_REPLACE_BR;$_PARSER_FIX_SPACES_AROUND_CLOSE_TAGS;$_PARSER_FIX_SPACES_AROUND_OPEN_TAGS;$_PARSER_FIX_SPACES_BEFORE_QUOTE"

_PARSER_FIX_ELLIPSIS="s/\\\ldots\{\}/.../g"
_PARSER_CONVERT_QUOTES="s/\"([^\"]+)\"/\`\`\1''/g"
_PARSER_FIX_SPACE_BEFORE_HYPHENQUOTE="s/  *-''/~-''/g"
_PARSER_CONVERT_DISALOG_DASHES="s/^ *-  */---\\\,/g"
_PARSER_FIX_SPACES_WITH_PUNCTUATION="s/([-,.?!])  *''( |$)/\1''\2/g;s/  *([,.?!])/\1/g"
_PARSER_CONVERT_DASHES="s/( |([,.?!]) ?) *-  */\2~--- /g"
PARSER_FIX_TEX="$_PARSER_FIX_ELLIPSIS;$_PARSER_CONVERT_QUOTES;$_PARSER_FIX_SPACE_BEFORE_HYPHENQUOTE;$_PARSER_CONVERT_DISALOG_DASHES;$_PARSER_FIX_SPACES_WITH_PUNCTUATION;$_PARSER_CONVERT_DASHES"

echo "\\weblink{https://www.fanfiction.net/s/5782108/$CHAPTER_NUMBER/}" > part_$CHAPTER_NUMBER.tex
grep "<title" part_$CHAPTER_NUMBER.html | sed -r "s/.*Chapter ([0-9]*): (.*), a harry.*/\\\chapter{Chapter \1: \2}/" >> part_$CHAPTER_NUMBER.tex
grep "nocopy" part_$CHAPTER_NUMBER.html | sed -r "$PARSER_EXTRACT_CONTENT" | pandoc --no-wrap -f html -t latex | sed -r "$PARSER_FIX_TEX" >> part_$CHAPTER_NUMBER.tex
