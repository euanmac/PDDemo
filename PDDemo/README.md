#  Technical Overview

Contentful Object Structure

Header
->ArticleContent (Title)
->ArticleContent (Title, Image)

Header
->ArticleList
        ->ArticleContent (Title, HeaderOnly, CheckList, ArticleListSection)
        ->ArticleContent
        ->ArticleList
        
Header
->ArticleAlbum (Title)
    ->ArticleContent (Title,Image)
    
Example TBC

    
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
    

