//
//  ArticleListGroup
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class ArticleListSection: EntryDecodable, FieldKeysQueryable, Equatable, Hashable {
    
    static let contentTypeId: String = "articleListSection"
    
    var id: String
    var updatedAt: Date?
    var createdAt: Date?
    var localeCode: String?
    let articleListSectionTitle: String?
    let showAsSection: Bool?
    
    public required init(from decoder: Decoder) throws {
        
        let sys = try decoder.sys()
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        showAsSection = true
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: ArticleListSection.FieldKeys.self)
        self.articleListSectionTitle       = try fields.decodeIfPresent(String.self, forKey: .articleListSectionTitle)
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleListSectionTitle
    }
    
    //Implement equatable 
    static func == (lhs: ArticleListSection, rhs: ArticleListSection) -> Bool {
        return lhs.articleListSectionTitle == rhs.articleListSectionTitle
    }
    
    //Implement hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.articleListSectionTitle)
    }
}
