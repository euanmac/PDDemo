//
//  ArticleBase.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 14/12/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import Foundation
import Contentful


//Protocol defining article
protocol Article {
    var id: String {get}
    var articleTitle: String? {get}
    var subtitle: String? {get}
    var listSection: ArticleListSection? {get}
    var isCheckList: Bool {get}
}


//Base class for article
class ArticleBase: Article, FieldKeysQueryable  {
    
    var id: String
    var updatedAt: Date?
    var createdAt: Date?
    let articleTitle: String?
    let subtitle: String?
    let isCheckList: Bool
    var listSection: ArticleListSection?
    
    public required init(from decoder: Decoder) throws {
        let sys = try decoder.sys()
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        let fields  = try decoder.contentfulFieldsContainer(keyedBy: ArticleSingle.FieldKeys.self)
        self.articleTitle   = try fields.decodeIfPresent(String.self, forKey: .articleTitle)
        self.subtitle = try fields.decodeIfPresent(String.self, forKey: .subtitle)
        self.isCheckList = try fields.decodeIfPresent(Bool.self, forKey: .isCheckList) ?? false
        try fields.resolveLink(forKey: .listSection, decoder: decoder) { [weak self] linkedSection in
            self?.listSection = linkedSection as? ArticleListSection
        }
        
    }
    
    enum FieldKeys: String, CodingKey {
        case articleTitle, subtitle, isCheckList, listSection
    }
}
