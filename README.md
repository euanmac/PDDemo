#  PDDemo

This iOS application displays data from a Contentful "space"

#  Contentful Model Overview

The content model is meant to be generic enough that it can be reused across different subject domains. 
The structure is relatively simple:

**Header** is the top level object which has one or more **articles**. An **article** can be a single piece of content (specifically MarkDown) or instead a list of articles. This allows for a flexible, recursive structure. Each article in an article list can be grouped under a section for improved readibility.
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
The dependencies were installed originally using CocoaPods and the Podfile and Podfile.lock are included so there should be no need to redownload.

#  To Do
* Checklist cell
* Persistance cell
* ImageArticle Cell

#  Application Structure
    
HeaderViewController
Takes a header and displays all articles listed - used as starting view controller for each tab (not home). No grouping.

ArticleList Table view
Takes an article list and displays articles grouped by listsection.

ArticleViewController
Displays single article content (markdown)

App Delegate -
    Create TabBar and Navigation Controllers, one Home for all "Headers" and "Header" table view to show the header and articles under that header
    Create a router and pass it to each of the  the 

AppController
start 
navigate (to:ArticleSingle)
navigate (from: Article
    

