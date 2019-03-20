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
import UIKit

final class ArticleImage: ArticleBase {
    
    var articleImageURL: String?
    var imageURL: URL?
    var articleContent: String?
    var articleImage: UIImage?

    internal required init(from decoder: Decoder) throws {
        
        //Init base properties
        try super.init(from: decoder)
        let container  = try decoder.container(keyedBy: FieldKeys.self)
        self.articleContent = try container.decodeIfPresent(String.self, forKey: .articleContent)
        self.articleImageURL = try container.decodeIfPresent(String.self, forKey: .articleImageURL)
    }
    
    /** Initialise from an Entry object*/
    internal required init(from entry: Entry) {
        //Init base class
        super.init(from: entry)
        self.articleContent = entry[FieldKeys.articleContent]
        let imageAsset: Asset? = entry[FieldKeys.articleImage]
        articleImageURL = imageAsset?.urlString
        self.imageURL = imageAsset?.url
        
    }

    //Get image asynchronously
    internal func getImage(then: @escaping ((UIImage?) -> Void)) {
        if let articleImageURL = self.articleImageURL {
            ContentfulDataManager.shared.fetchImage(for: articleImageURL) { image in
                //Success so return image
                then(image)
            }
        } else {
            //No image to download so call completion with nothing
            then(nil)
        }
    }
    
    //Encode to JSON
    override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: FieldKeys.self)
        try super.encode(to: encoder)
        try container.encode(articleContent, forKey: .articleContent)
        try container.encode(articleImageURL, forKey: .articleImageURL)

    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case articleContent, articleImage, articleImageURL
    }
    
    //Convert MarkDown to AttributedString
    func getAttributedContent(styling: Styling = DefaultStyling()) -> NSAttributedString {
        
        //Check we have content to convert, if not return empty attributed string
        guard let content = self.articleContent else {return NSAttributedString()}
        return MarkyMark.getAttributedContent(from: content)
        
    }
    
    //Convert MarkDown to AttributedString
    func getAttributedContent(completion: @escaping ((NSAttributedString)->Void), styling: Styling = DefaultStyling()) -> NSAttributedString {
        
        //Check we have content to convert, if not return empty attributed string
        guard let content = self.articleContent else {return NSAttributedString()}
        return MarkyMark.getAttributedContent(from: content, completion: completion)
    }
        
}
