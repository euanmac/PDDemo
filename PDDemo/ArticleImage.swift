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

final class ArticleImage: ArticleBase {
    
    static let contentTypeId: String = "articleImage"
    
    var articleImage: Asset?
    var articleContent: String?

    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        let fields  = try decoder.contentfulFieldsContainer(keyedBy: ArticleImage.FieldKeys.self)

        self.articleContent = try fields.decodeIfPresent(String.self, forKey: .articleContent)
        try fields.resolveLink(forKey: .articleImage, decoder: decoder) { [weak self] image in
            self?.articleImage = image as? Asset
        }
    }
    
    /** Initialise from an Entry object*/
    public required init(from entry: Entry) {
        //Init base class
        super.init(from: entry)
        self.articleContent = entry[FieldKeys.articleContent]
        self.articleImage = entry[FieldKeys.articleImage]
    
    }
    
    //Encode to JSON
    override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: FieldKeys.self)
        try super.encode(to: encoder)
        try container.encode(articleContent, forKey: .articleContent)
        try container.encode(ArticleImage.contentTypeId, forKey: .articleContent)
        //try container.encode(articleImage, forKey: .articleImage)
        //try container.encode(showOnHome, forKey: .showOnHome)
        //try container.encode(articles, forKey: .articles)
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleContent, articleImage, contentTypeId
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
