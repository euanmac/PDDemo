#  PDDemo

This iOS application displays data from a Contentful "space".

#  Contentful Model Overview

The content model is meant to be generic enough that it can be reused across different subject domains. 
The structure is relatively simple:

**Header** is the top level object which has one or more **articles**. An **article** can be a single piece of content (specifically MarkDown) or instead a list of articles. This allows for a flexible, recursive structure. Each article in an article list can be grouped under a section for improved readibility or display in a tableview.
The application uses this structure to render the content. Headers will populate the "home" tab. They can also be flagged to show as tabs in their own right.

Header
->ArticleContent (Title)
->ArticleContent (Title, Image)

Header
->ArticleList
        ->ArticleContent (Title, HeaderOnly, CheckList, ArticleListSection)
        ->ArticleContent
        ->ArticleList
        
#  How To Use
Clone this repo in XCode from the Source Control menu. 
The repo includes two dependencies. These are:
* **Contentful** - an API for calling downloading content from Contentful
* **markymark** - a MarkDown rendering package

Both are included so the project/workspace should compile.
The dependencies were installed originally using CocoaPods and the Podfile and Podfile.lock are included in repo so no need to "pod install".

#  To Do
* Persistance - partly complete. Markdown with inline images is not  cached and blocks as not loaded asynchronously 
* ~~Notes~~
* Notes (Landscape mode)
* Logging
* Scroll content
* ImageArticle Cell
* Automated unit testing - need populate model with test JSON 

#  Application Structure

__Object Model__

ContentfulDataManager
Effectively the model manager in that it controls loading of the model objects and controls access to both Contentful API and also to filesystem for caching / saving data.
Defines observer protocol - this can be implemented by any class wanting to know when Contentful data has been loaded. Observers need to register for updates.

__View Controllers__

HeaderViewController
Takes a header and displays all articles listed - used as starting view controller for each tab (not home). No grouping.

ArticleList Table view
Takes an article list and displays articles grouped by listsection.

ArticleViewController
Displays single article content (markdown)


__App Delegate__
Sets up the GUI and holds reference to ContentfulDataManager

AppController
start 
navigate (to:ArticleSingle)
navigate (from: Article
    


Pseudo code for getting and syncing data

load_token from file
if no token then load_headers
    if load_headers 
        load_token from web
        save_token
        save_headers
        display_data
    else
        exit_error
    end if
else
    if in_sync
        load_headers_from_cache
        display_data
    else
        load_headers from web
        load_token_from web
        save_token
        save_headers
        display_data
    end if
end if

 sync_token is string
 load from file
 


