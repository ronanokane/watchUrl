#!/bin/bash

# Watch remote html page for changes and record
# Cd into separate dir for each new Url

git_update(){
	git add "pageExtract" &> /dev/null
	git commit -m "$1" &> /dev/null
}

getPageElement(){
	downloadedpage=$(node retrieveHtml.js "$1" "$cookies" 2> /dev/null) || { echo "Connection failure $1" >&2; return -1; }
	extract=$(xmllint --html --xpath $2 <(echo $downloadedpage) 2> /dev/null) || { echo "Parse error..." >&2; exit 1; }
}

usage(){
	echo "Usage: $1 -u <url> -x <xPath_element> -c <cookies>" >&2
	echo "Note: Initial use requires at least -u and -x options" >&2
	echo "subsequent use after requires no args as state is already saved" >&2
	exit 1
}

while getopts ':u:x:c:' OPTION; do
	case "$OPTION" in
		u)
			url="$OPTARG";;
		x)
			xpath="$OPTARG";;
		c)
			cookies="$OPTARG";;
	esac
done

if [ $# -eq 0 ]; then
	if [ -e "config.json" ]; then
		url=$(cat config.json | jq '.url' | xargs)
		xpath=$(cat config.json | jq '.xpath' | xargs)
		cookies=$(cat config.json | jq '.cookies' | xargs)
	else
		usage $0
	fi
elif [ ! -z $xpath ] && [ ! -z $url ]; then
	getPageElement "$url" "$xpath" || exit 1
	echo "$extract" > "pageExtract"
	jq -n "{url: \"$url\", xpath: \"$xpath\", cookies: \"$cookies\"}" > config.json
	git init &> /dev/null && git_update "initial commit... $xpath"
else
	usage $0
fi

while :
do
	sleep 10
	getPageElement "$url" "$xpath" 2> /dev/null || { echo "Connection down ?... retrying" >&2; continue; }

	if [ $(md5sum "pageExtract" | awk '{print $1}') != $(echo "$extract" | md5sum | awk '{print $1}') ]; then
		echo "$extract" > "pageExtract"
		git_update 'change...'
		git show --pretty=format:'%b'
		notify-send --icon=git "change..." "$url" 
	fi
done