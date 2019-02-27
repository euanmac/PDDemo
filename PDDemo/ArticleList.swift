//
//  ArticleList.swift
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class ArticleList: ArticleBase {
   
    
    var articles: [Article] = [Article]()
    
    
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
    
    /**Initialise from decoder*/
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: ArticleList.FieldKeys.self)
        try fields.resolveLinksArray(forKey: .articles, decoder: decoder) { [weak self] itemsArray in self?.articles = itemsArray as? [Article] ?? [Article]()
        }
       
    }
    
    // Initialise from an Entry object
    public required init(from entry: Entry) {
        //Init base class
        super.init(from: entry)
        if let entries = entry.fields.linkedEntries(at: FieldKeys.articles.stringValue) {
            self.articles =  entries.compactMap({$0.mapTo(types: ArticleTypes.self)}) as! [Article]
        }
    }
    
    //Encode properties to JSON
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FieldKeys.self)
        try super.encode(to: encoder)
        try container.encode(articles as! [ArticleBase], forKey: .articles)
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articles
    }
        
    //Overriden - true if content is not null
    override var hasContent: Bool {
        get {
            return self.articles.count > 0
        }
    }

}
