#  PDDemo

This iOS application displays data from a Contentful "space"

#  Contentful Model Overview

The content model has been defined to provide structure yet still allow flexibility.
Header is the top level object which has one or more articles. An article can be a single piece of content (specifically MarkDown) or instead a list of articles. This allows for a flexible recursive structure. Each article in an article list can be grouped under a section for improved readibility.
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
Clone this repo using XCode, this will give the project files only so wont compile. Note the directory location. 
There are two dependencies that then need to be installed using CocoaPods.
To do this, first ensure install CocoaPods. This can be done easily by following the instructions at https://cocoapods.org.

The dependencies are:

Contentful - an API for calling downloading content from Contentful
markymark - a MarkDown rendering package

Open Terminal and go to your cloned project directory.



#  Application Structure
    
Aricles Table view
takes a header and displays all articles listed

ArticleList Table view
takes an article list and displays list groups as sections and the articles in the groups as cells

Article Content view
displays the article content (markdown)


App Delegate -
    Create TabBar and Navigation Controllers, one Home for all "Headers" and "Header" table view to show the header and articles under that header
    Create a router and pass it to each of the  the 

AppController
start 
navigate (to:ArticleSingle)
navigate (from: Article
    

