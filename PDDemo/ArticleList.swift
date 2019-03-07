//
//  ArticleList.swift
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class ArticleList: ArticleBase {
   
    var articles = [Article]()
    var sections = [ArticleListSection]()
    
    //Return array of articles with given list section
    func getArticles(by listSection: ArticleListSection) -> [Article] {
        return articles.filter({$0.listSection == listSection})
    }
    
    /**Initialise from decoder*/
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: FieldKeys.self)
        self.articles = try container.decode(types: ArticleTypes.self, forKey: .articles) as! [Article]
        //Get unique non-nil list of sections from articles by using compactmap to remove nils
        //and then reduce to get distinct list
        sections = articles.compactMap {$0.listSection}.reduce([
            ArticleListSection](), {$0.contains($1) ? $0 : $0 + [$1]})
        try super.init(from: decoder)
        
    }
    
    // Initialise from a Contentful Entry object
    public required init(from entry: Entry) {
        
        //Init base class
        super.init(from: entry)
        if let entries = entry.fields.linkedEntries(at: FieldKeys.articles.stringValue) {
            self.articles =  entries.compactMap({$0.mapTo(types: ArticleTypes.self)}) as! [Article]
        }
        //Get unique non-nil list of sections from articles by using compactmap to remove nils
        //and then reduce to get distinct list
        sections = articles.compactMap {$0.listSection}.reduce([
            ArticleListSection](), {$0.contains($1) ? $0 : $0 + [$1]})
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
