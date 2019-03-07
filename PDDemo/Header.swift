//
//  Header.swift
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful


final class Header : EntryMappable, Codable  {
    
    static let contentTypeId: String = "header"
    
    //var id: String
    //var updatedAt: Date?
    //var createdAt: Date?
    //var localeCode: String?
    let headerTitle: String?
    let showOnTab: Bool
    let showOnHome: Bool
    let ordinal: Int
 
    var articles: [Article] = [Article]()
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: FieldKeys.self)
        self.headerTitle =  try container.decode(String.self, forKey: .headerTitle)
        self.showOnTab = try container.decode(Bool.self, forKey: .showOnTab)
        self.showOnHome   = try container.decode(Bool.self, forKey: .showOnHome)
        self.ordinal    = try container.decode(Int.self, forKey: .ordinal)
        print(self.headerTitle)
        self.articles = try container.decode(types: ArticleTypes.self, forKey: .articles) as! [Article]
        
    }
    
    //Initialise the header from a Contentful entry object
    public required init(from entry: Entry) {
        
        self.headerTitle =  entry[FieldKeys.headerTitle]
        self.showOnTab = entry[FieldKeys.showOnTab] ?? false
        self.showOnHome   = entry[FieldKeys.showOnHome] ?? false
        self.ordinal    = entry[FieldKeys.ordinal] ?? 0
        if let entries = entry.fields.linkedEntries(at: FieldKeys.articles.stringValue) {
        self.articles =  entries.compactMap({$0.mapTo(types: ArticleTypes.self)}) as! [Article]}
        print(self.headerTitle)
    }
    
    //Encode method, cannot be synthesised as we're inheriting the encodable protocol from article protocol
    func encode(to encoder: Encoder) throws {
        print("Header encoding")
        var container = encoder.container(keyedBy: FieldKeys.self)
        //try container.encode(sys, forKey: .sys)
        try container.encode(headerTitle, forKey: .headerTitle)
        try container.encode(ordinal, forKey: .ordinal)
        try container.encode(showOnTab, forKey: .showOnTab)
        try container.encode(showOnHome, forKey: .showOnHome)
        try container.encode(articles as! [ArticleBase], forKey: .articles)
        try container.encode(Header.contentTypeId, forKey: .contentTypeId)
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case headerTitle, articles, ordinal, showOnTab, showOnHome, contentTypeId
    }
}


//public required init(from decoder: Decoder) throws {
//
//    sys = try decoder.sys()
//    id = sys.id
//    updatedAt = sys.updatedAt
//    createdAt = sys.createdAt
//
//    let fields      = try decoder.contentfulFieldsContainer(keyedBy: Header.FieldKeys.self)
//    self.headerTitle       = try fields.decodeIfPresent(String.self, forKey: .headerTitle)
//
//    if let showOnTab = try fields.decodeIfPresent(Bool.self, forKey: .showOnTab) {
//        self.showOnTab = showOnTab
//    }
//
//    if let showOnHome    = try fields.decodeIfPresent(Bool.self, forKey: .showOnHome) {
//        self.showOnHome = showOnHome
//    }
//
//    if let ordinal    = try fields.decodeIfPresent(Int.self, forKey: .ordinal) {
//        self.ordinal = ordinal
//    }
//
//    try fields.resolveLinksArray(forKey: .articles, decoder: decoder) { [weak self] itemsArray in self?.articles = itemsArray as? [ArticleBase] ?? [ArticleBase]()}
//}
