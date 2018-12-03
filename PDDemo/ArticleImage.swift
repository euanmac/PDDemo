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

//class ArticleBase : Article {
//
//}

final class ArticleImage: Article, EntryDecodable, FieldKeysQueryable {
    
    static let contentTypeId: String = "articleImage"
    
    var id: String
    var updatedAt: Date?
    var createdAt: Date?
    var localeCode: String?
    let articleTitle: String?
    let subtitle: String?
    var articleContent: String?
    var listSection: ArticleListSection?
    var articleImage: Asset?
    
    public required init(from decoder: Decoder) throws {
        
        let sys = try decoder.sys()
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        let fields  = try decoder.contentfulFieldsContainer(keyedBy: ArticleImage.FieldKeys.self)
        self.articleTitle   = try fields.decodeIfPresent(String.self, forKey: .articleTitle)
        self.articleContent = try fields.decodeIfPresent(String.self, forKey: .articleContent)
        self.subtitle = try fields.decodeIfPresent(String.self, forKey: .subtitle)
        try fields.resolveLink(forKey: .listSection, decoder: decoder) { [weak self] linkedSection in
            self?.listSection = linkedSection as? ArticleListSection
        }
        try fields.resolveLink(forKey: .articleImage, decoder: decoder) { [weak self] image in
            self?.articleImage = image as? Asset
        }
        
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleTitle, articleContent, ordinal, subtitle, listSection, articleImage
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
