//
//  ArticleListGroup
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

//ListSection Class, Codable will be synthesized by compiler, needs Equatable and Hashable for sorting, finding
final class ArticleListSection: Codable, EntryMappable, Equatable, Hashable {
    
    let articleListSectionTitle: String?
    let showAsSection: Bool?
    
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
