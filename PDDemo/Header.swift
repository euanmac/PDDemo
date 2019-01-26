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
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case headerTitle, articles, ordinal, showOnTab, showOnHome
    }
}
