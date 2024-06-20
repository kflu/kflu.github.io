#!/bin/sh

THIS_DIR="$( cd "$(dirname "$0")"; pwd )"
POSTS_DIR="$THIS_DIR/_posts"

main() {
    local cmd="$1"; shift
    case "$cmd" in
        new|n)  new "$@" ;;
        edit|e) edit "$@" ;;
        *) usage ;;
    esac
}

new() {
    local title tags date
    printf "Title: "; read title
    printf "Tags: "; read tags
    tags=$( IFS=", "; echo $tags )
    date="$( date "+%Y-%m-%d" )"

    local title_escaped="$(echo "$title" | tr -C '[:alnum:]' - | sed -E 's/-+$//' )"
    local fn="$date-$title_escaped.md"

    ( # populate the new post file
        cd "$POSTS_DIR"
        local tmp=`mktemp`
        cat <<EOF > "$tmp"
---
title: $title
comments: true
date: $date
tags: $( echo;
for t in $tags; do
    echo "    -" "$t"
done
)
---

EOF
        local tmp_hash="$( cksum "$tmp" )"
        "$EDITOR" "$tmp"
        local tmp_hash2="$( cksum "$tmp" )"
        if [ "$tmp_hash" = "$tmp_hash2" ]; then
            echo "Post not changed - abandoning"
        else
            echo "Commiting to $fn"
            cp "$tmp" "$fn"
        fi
        rm "$tmp"
    )
}

edit() {
    echo not implemented yet
    # TODO
}

usage() {
    cat <<EOF >&2
USAGE:
    b new
    b edit
...
EOF
}

main "$@"
