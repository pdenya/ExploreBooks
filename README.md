# Explore Books

The goal is to make very nuanced searches possible.

For example a search:
 - Genres: Fantasy, Magic Realism
 - Avoid Genres: Young Adult
 - Ratings: medium (between 100 - 10,000)
 - Published Date: After 2001
 - Page count: >300
 - Included in lists: Genius protagonists
 - Not included in lists: Worst books of all time

 ## Status

 Retired project. I'd still love to do this but book recommendations were made so incredibly good by LLMs and the driving need for this in my life has waned :)

## TODO
 - automatically add more genres/tags
 	- comment analysis
 	- lists confer tags
 	- lists as tags
 - import from other sources
    - https://openlibrary.org/dev/docs/api/covers
 	- https://openlibrary.org/developers/dumps
 	- https://openlibrary.org/developers/api
 	- https://isbndb.com/apidocs/v2
 	- audible
 	- amazon (uses ISBN as ASIN)
 	- https://developer.nytimes.com/docs/books-product/1/overview
	- Tons of data here - non commercial https://sites.google.com/eng.ucsd.edu/ucsdbookgraph/home?pli=1
	- https://www.kaggle.com/datasets/bahramjannesarr/goodreads-book-datasets-10m
 - read tracking, filter out read books
 	- mark series as read
 - cover art



## Domain

https://domains.google.com/registrar/explorebooks.app/dns?hl=en


### Other Options

https://www.fictiondb.com/search/search.htm

https://www.bookdigits.com - they're giving fairly good recommendations and doing comment analysis to provide additional details

https://www.amazon.com/advanced-search/books

https://books.google.com/advanced_book_search

https://www.whichbook.net/

https://www.librarything.com/suggest
https://www.librarything.com/work/2410323/recommendations


https://manybooks.net/search-book

https://weird-old-book-finder.glitch.me/

https://www.fantasticfiction.com/

http://www.bookfinder4u.com/

https://www.bookbrowse.com/

### Reach Out

Hey, I want to show you a book app I've been working on soon. I want to prep a demo though. Send me a few goodreads lists you like (imports in seconds, lots is great, 4 minimum) and a few you might filter by.

Example:

Good:

https://www.goodreads.com/list/show/88.Best_Fantasy_Books_of_the_21st_Century#14201
https://www.goodreads.com/list/show/3153.Big_Fat_Books_Worth_the_Effort#14201
https://www.goodreads.com/list/show/871.Most_Interesting_Magic_System#14201
https://www.goodreads.com/list/show/17747.Historical_Fiction_With_a_Dash_of_Magic#14201
https://www.goodreads.com/list/show/2700.Sci_Fi_and_Fantasy_Must_Reads#14201

Filter:

https://www.goodreads.com/list/show/43.Best_Young_Adult_Books#28187
https://www.goodreads.com/list/show/685.Best_Teen_Young_Adult_Books#28187
https://www.goodreads.com/list/show/21091.Best_Greek_Novels#28187



response = Book.search({
  "query": { 
    "bool": {
      "must":[
          {"term":{"genres": "Fantasy" } },
          {"term":{"genres": "Magic" } },
          { "exists": { "field": "description" }}
        ],
      "must_not": [
        {"term":{"genres": "Young Adult" } },
      ]
      },
    },
 })



 response = Book.search({
  "query": { 
    "bool": {
      "must":[
          {"term":{"genres": "Fantasy" } },
          {"term":{"genres": "Magic" } },
        ],
      "must_not": [
        {"term":{"genres": "Young Adult" } },
      ]
      },
    },
 })
