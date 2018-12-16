//
//  ArticleList.swift
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class ArticleList: ArticleBase, EntryDecodable, FieldKeysQueryable {
   
    static let contentTypeId: String = "articleList"
    
    private var articlesOpt: [Article]?
        
    //Computed property to return array of articles, returns empty array even if no articles
    var articles: [Article]  {
        get {
            return articlesOpt == nil ? [Article]() : articlesOpt!
        }
    }
    
    //Computed property to return unique list of ArticleListSections
    var sections: [ArticleListSection] {
        //Filter out nil values and map to array of Sections
        let listSections = articles.filter({$0.listSection != nil}).map({$0.listSection!})
        //Strip out duplicates
        return listSections.reduce([
            ArticleListSection](), {$0.contains($1) ? $0 : $0 + [$1]})
    }
    
    //Return array of articles with given list section
    func getArticles(by listSection: ArticleListSection) -> [Article] {
        return articles.filter({$0.listSection == listSection})
    }
    
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: ArticleList.FieldKeys.self)
        try fields.resolveLinksArray(forKey: .articles, decoder: decoder) { [weak self] itemsArray in self?.articlesOpt = itemsArray as? [Article]
        }
       
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleTitle, articles, subtitle, listSection, isCheckList
    }
        
    
//    public func getArticles(by section: ArticleListSection) -> [{
//        return articles.filter({$0.articleListSection != nil}).reduce([ArticleListSection]){$0.contains($1.articleListSection!) ? $0 : $0 + [$1.articleListSection]}
//    }
    

}
