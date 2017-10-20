# team-tartan

## Speech shopping search

* Uses iOS 10 Speech API to recognise spoken item from user as text string
* Passes text string to Ichiba item search [API](https://webservice.rakuten.co.jp/api/ichibaitemsearch/)
* Parses `itemCode` of first search result item in response and uses that to build a custom URL
* The URL is used to open the Ichiba app at the item's specific page

### Challenges

* Wanted to do everything in extension but they do not allow mic or camera access

### Future improvements

* Camera shopping search utilising CoreML
