//
//  ArticleBase.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 14/12/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import Foundation
import Contentful


//Types for decoding and deserialising
protocol ContentTypes : Decodable {
    func getType() -> EntryMappable.Type
    init?(rawValue: String)
}

//Defines Article Classes - if new classes added then they also need to be defined here.
//The string enums need to match the contentful contenttype ids
enum ArticleTypes : String, ContentTypes {
    case articleSingle = "article"
    case articleImage = "articleImage"
    case articleList = "articleList"
    case articleListSection = "articleListSection"
    
    func getType() -> EntryMappable.Type {
        switch self {
        case .articleSingle:
            return ArticleSingle.self
        case .articleImage:
            return ArticleImage.self
        case .articleList:
            return ArticleList.self
        case .articleListSection:
            return ArticleListSection.self
        }
    }
}


//Protocol defining article
protocol Article: Codable {
    var contentTypeId: String? {get}
    var articleTitle: String? {get}
    var subtitle: String? {get}
    var listSection: ArticleListSection? {get}
    var isCheckList: Bool {get}
    var hasContent: Bool {get}
}

//Base class for article - note that this class is not entry mappable though it probably should be 
class ArticleBase: Article, Codable, EntryMappable {
    
    let articleTitle: String?
    let subtitle: String?
    let isCheckList: Bool
    let contentTypeId: String?
    var listSection: ArticleListSection?
    
    /**Initialies from decoder*/
    public required init(from decoder: Decoder) throws {

        let fields  = try decoder.contentfulFieldsContainer(keyedBy: ArticleBase.FieldKeys.self)
        self.articleTitle   = try fields.decodeIfPresent(String.self, forKey: .articleTitle)
        self.subtitle = try fields.decodeIfPresent(String.self, forKey: .subtitle)
        self.isCheckList = try fields.decodeIfPresent(Bool.self, forKey: .isCheckList) ?? false
        self.contentTypeId = try fields.decodeIfPresent(String.self, forKey: .contentTypeId)
        try fields.resolveLink(forKey: .listSection, decoder: decoder) { [weak self] linkedSection in
            self?.listSection = linkedSection as? ArticleListSection
        }
    }
    
    /**Initialise from an Entry object*/
    public required init(from entry: Entry) {
        
        self.articleTitle = entry[FieldKeys.articleTitle]
        self.subtitle = entry[FieldKeys.subtitle]
        self.isCheckList = entry[FieldKeys.isCheckList] ?? false
        if let lsEntry = entry[entryKey: FieldKeys.listSection] {
            self.listSection = ArticleListSection(from: lsEntry)
        }
        self.contentTypeId = entry.sys.contentTypeId
    }
    
    /**Encode for caching */
    func encode(to encoder: Encoder) throws {
 
        var container = encoder.container(keyedBy: FieldKeys.self)
        try container.encode(articleTitle, forKey: .articleTitle)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(isCheckList, forKey: .isCheckList)
        try container.encode(listSection, forKey: .listSection)
    }
    
    //Override this in subclasses
    var hasContent: Bool {
        get {
            return false
        }
    }
    
    //Needs to be private so can be defined in subclasses
    private enum FieldKeys: String, CodingKey {
        case articleTitle, subtitle, isCheckList, listSection, contentTypeId
    }
}


