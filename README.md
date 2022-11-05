# watchurl

A bash script to watch part of a html page of given url (by xpath) every x number of seconds for changes. Save results to git.

## Setup:

Create a new directory and copy files into it eg:<br>
git clone https://github.com/ronanokane/watchurl.git<br>

mkdir ~/urlToWatch<br>
cd watchUrl<br>
cp watchUrl.sh retrieveHtml.js ~/urlToWatch/<br>
cd ~/urlToWatch<br>
npm i puppeteer-core<br>

## Usage:

Make different urlToWatch folder for each new url!
<br>Initially to start watching url element:

./watchUrl.sh \<https://www.whatever.com> \<xpath\>

Alternatively with cookies:

./watchUrl.sh \<https://www.whatever.com> \<xpath\> < cookieFile

After first run you can just use ./watchUrl.sh without args. config.json has stored the arguments for future use. Just delete or modify this file for using different urls and delete .git
<br>Use git command to analyse the changes.
