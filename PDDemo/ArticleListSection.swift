//
//  ArticleListGroup
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class ArticleListSection: Codable, EntryMappable, Equatable, Hashable {
    
    let articleListSectionTitle: String?
    let showAsSection: Bool?
    
    public required init(from decoder: Decoder) throws {
        

        let fields      = try decoder.contentfulFieldsContainer(keyedBy: ArticleListSection.FieldKeys.self)
        self.articleListSectionTitle       = try fields.decodeIfPresent(String.self, forKey: .articleListSectionTitle)
        showAsSection = true
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleListSectionTitle
    }
    
    //Initialise from an Entry
    public required init(from entry: Entry) {
        
        showAsSection = true
        self.articleListSectionTitle = entry[FieldKeys.articleListSectionTitle]
        
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
