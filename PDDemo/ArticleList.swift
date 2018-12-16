//
//  ArticleList.swift
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class ArticleList: Article, EntryDecodable, FieldKeysQueryable {
   
    static let contentTypeId: String = "articleList"
    
    var id: String
    var updatedAt: Date?
    var createdAt: Date?
    var localeCode: String?
    let articleTitle: String?
    let subtitle: String?
    var listSection: ArticleListSection?
    let isCheckList: Bool
    
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
        
        let sys = try decoder.sys()
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: ArticleList.FieldKeys.self)
        self.articleTitle       = try fields.decodeIfPresent(String.self, forKey: .articleTitle)
        self.subtitle = try fields.decodeIfPresent(String.self, forKey: .subtitle)
        self.isCheckList = try fields.decodeIfPresent(Bool.self, forKey: .isCheckList) ?? false
        try fields.resolveLinksArray(forKey: .articles, decoder: decoder) { [weak self] itemsArray in self?.articlesOpt = itemsArray as? [Article]
        }
        try fields.resolveLink(forKey: .listSection, decoder: decoder) { [weak self] linkedSection in
            self?.listSection = linkedSection as? ArticleListSection
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
