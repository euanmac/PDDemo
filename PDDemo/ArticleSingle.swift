//
//  CheckListGroup.swift
//  Boilerplate
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful
import markymark

final class ArticleSingle: ArticleBase, EntryDecodable, FieldKeysQueryable {
    
    static let contentTypeId: String = "article"
    
    var articleContent: String?
    
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
      
        let fields  = try decoder.contentfulFieldsContainer(keyedBy: ArticleSingle.FieldKeys.self)
        self.articleContent = try fields.decodeIfPresent(String.self, forKey: .articleContent)
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleContent 
    }
    
    //Convert MarkDown to AttributedString
    func getAttributedContent(styling: Styling = DefaultStyling()) -> NSAttributedString {
        
        //Check we have content to convert, if not return empty attributed string
        guard let content = self.articleContent else {return NSAttributedString()}
        
        let markyMark = MarkyMark() { $0.setFlavor(ContentfulFlavor()) }
        let markdownItems = markyMark.parseMarkDown(content)
        let config = MarkDownToAttributedStringConverterConfiguration(styling: styling)
        let converter = MarkDownConverter(configuration: config)
        let attributedText = converter.convert(markdownItems)
        return attributedText
    }
        
}
