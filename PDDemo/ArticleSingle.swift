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

/*Class that models a single content article. Inherits from Base article class*/
final class ArticleSingle: ArticleBase {
    
    var articleContent: String?
    
    public required init(from decoder: Decoder) throws {
        
        //Init base properties
        try super.init(from: decoder)
        let fields  = try decoder.contentfulFieldsContainer(keyedBy: ArticleSingle.FieldKeys.self)
        self.articleContent = try fields.decodeIfPresent(String.self, forKey: .articleContent)
    }
    
    /** Initialise from an Entry object*/
    public required init(from entry: Entry) {
        //Init base class
        super.init(from: entry)
        self.articleContent = entry[FieldKeys.articleContent]
    }
    
    //Encode properties to JSON
    override func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: FieldKeys.self)
        try super.encode(to: encoder)
        try container.encode(articleContent, forKey: .articleContent)
        try container.encode(contentTypeId, forKey: .contentTypeId)
        
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleContent, contentTypeId
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
    
    //Overriden - true if content is not null
    override var hasContent: Bool {
        get {
            return self.articleContent != nil
        }
    }
}
