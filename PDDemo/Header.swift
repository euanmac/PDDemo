//
//  Header.swift
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class Header: EntryDecodable, FieldKeysQueryable, Encodable {
    
    static let contentTypeId: String = "header"
    
    var id: String
    var updatedAt: Date?
    var createdAt: Date?
    var localeCode: String?
    let headerTitle: String?
    let sys: Sys
    var showOnTab: Bool = false
    var showOnHome: Bool = true
    var ordinal: Int = 0
 
    var articles: [ArticleBase] = [ArticleBase]()
    
    public required init(from decoder: Decoder) throws {
        
        sys = try decoder.sys()
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt

        let fields      = try decoder.contentfulFieldsContainer(keyedBy: Header.FieldKeys.self)
        self.headerTitle       = try fields.decodeIfPresent(String.self, forKey: .headerTitle)
        
        if let showOnTab = try fields.decodeIfPresent(Bool.self, forKey: .showOnTab) {
            self.showOnTab = showOnTab
        }
        
        if let showOnHome    = try fields.decodeIfPresent(Bool.self, forKey: .showOnHome) {
            self.showOnHome = showOnHome
        }

        if let ordinal    = try fields.decodeIfPresent(Int.self, forKey: .ordinal) {
            self.ordinal = ordinal
        }
        
        try fields.resolveLinksArray(forKey: .articles, decoder: decoder) { [weak self] itemsArray in self?.articles = itemsArray as? [ArticleBase] ?? [ArticleBase]()}
    }
    
    public required init(from entry: Entry) {
        
        sys = entry.sys
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        print (entry.sys.contentTypeId)
        
        
        let fields      =  entry.fields
        self.headerTitle =  entry[FieldKeys.headerTitle]
        
        self.showOnTab = entry[FieldKeys.showOnTab] ?? false
        
        self.showOnHome   = entry[FieldKeys.showOnHome] ?? false
    
        self.ordinal    = entry[FieldKeys.ordinal] ?? 0

//        self.articles = entry.fields.linkedEntries(at: "articles").map({entry in
//            return entry.mapTo(types: ArticleList.self)})
//
        if let entries = entry.fields.linkedEntries(at: FieldKeys.articles.stringValue) {
            
            self.articles =  entries.map({$0.mapTo(types: [ArticleList.self, ArticleSingle.self, ArticleImage.self])}) as?
                    [ArticleBase] ?? [ArticleBase]()
            
        }
        print(articles.count)
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case headerTitle, articles, ordinal, showOnTab, showOnHome
    }
}
