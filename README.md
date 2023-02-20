# watchurl

A bash script to watch part of a html page of given url (by xpath) every x number of seconds for changes. Save results to git.

## Setup:

Requires chromium, nodejs, xmllint, notify-send and puppeteer-core<br>

Copy watchUrl.sh and retrieveHtml.js into separate dir for each Url to be watched.

## Usage:

<br>To start watching url:

./watchUrl.sh -u \<https://www.whatever.com> -x \<xpath\>

Alternatively with cookies:

./watchUrl.sh -u \<https://www.whatever.com> -x \<xpath\> -c cookies

After first run you can just use ./watchUrl.sh without args. config.json has stored the arguments for future use.<br>Use git command to analyse the changes.
