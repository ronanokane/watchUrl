#!/bin/bash

# Watch remote html element for changes and record
# Place this .sh in its own dir for each URL

git_update(){
	git add 'pagePart.html' > /dev/null
	git commit -m $1 > /dev/null
}

getPageElement(){
	downloadedpage=$(curl $(if [[ $cookies != "" ]]; then echo -b "\"$cookies\" "; fi)-L $1 2> /dev/null) || { echo "Invalid url $1" ; exit 1; }
	element=$(xmllint --html --xpath $2 <(echo $downloadedpage) 2> /dev/null) || { echo 'Parse error'; exit 1; } 
}

usage(){
	echo "Usage: $1 <url> <xPath_element>"
	echo "Usage: $1 <url> <xPath> < cookiefile"
	echo "Usage: $1"
	echo
	echo "Note: Initial use requires 2 args"
	echo "subsequent use after requires no args as state is already saved"
	echo
	exit 1
}

read -t 1 cookies

if [ $# -eq 2 ]; then
	url=$1
	xpath=$2
elif [ $# -eq 0 ]; then
	if [ -e "config.json" ]; then
		url=$(cat config.json | jq '.url' | tr -d '"')
		xpath=$(cat config.json | jq '.xpath' | tr -d '"')
		cookies=$(cat config.json | jq '.cookies' | tr -d '"')
	else
		usage $0
	fi
else
	usage $0
fi

if [ ! -e "pagePart.html" ]; then
	getPageElement $url $xpath
	echo $element > pagePart.html
	git init 2> /dev/null
	git_update 'initial_commit'
	jq -n "{url: \"$1\", xpath: \"$2\", cookies: \"$cookies\"}" > config.json
fi

while :
do
	sleep 10
	getPageElement $url $xpath

	if [ $(md5sum pagePart.html | awk '{print $1}') != $(echo $element | md5sum | awk '{print $1}') ]; then
		echo $element > pagePart.html
		git_update 'element_change'
		echo 'recorded a change...'
	fi  
done
