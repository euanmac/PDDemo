//
//  CheckListGroup.swift
//  Boilerplate
//
//  Created by Euan Macfarlane on 18/10/2018.
//  Copyright © 2018 Contentful. All rights reserved.
//

import Foundation
import Contentful

final class Plan: EntryDecodable, FieldKeysQueryable {
    
    static let contentTypeId: String = "plan"
    
    var id: String
    var updatedAt: Date?
    var createdAt: Date?
    var localeCode: String?
    let text: String?
    var checkListGroups: [CheckListGroup]?
    
    // Relationship fields.
    //var bestFriend: Cat?
    //var image: Asset?
    internal func cb(array: Any) {
        self.checkListGroups = array as? [CheckListGroup]
    }
    
    public required init(from decoder: Decoder) throws {
        let sys = try decoder.sys()
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: Plan.FieldKeys.self)
        
        self.text       = try fields.decodeIfPresent(String.self, forKey: .planName)
        //self.detail      = try fields.decodeIfPresent(String.self, forKey: .detail)
        //self.additionalContent      = try fields.decodeIfPresent(String.self, forKey: .additionalContent)
        //self.likes      = try fields.decodeIfPresent(Array<String>.self, forKey: .likes)
        //self.lives      = try fields.decodeIfPresent(Int.self, forKey: .lives)
        try fields.resolveLinksArray(forKey: .checkListGroups, decoder: decoder, callback: cb)
//        {
//            [weak self] itemsArray in self?.checkListGroups = itemsArray as? [CheckListGroup]
//        }
        
        /*
        try fields.resolveLink(forKey: .bestFriend, decoder: decoder) { [weak self] linkedCat in
            self?.bestFriend = linkedCat as? Cat
        }
        try fields.resolveLink(forKey: .image, decoder: decoder) { [weak self] image in
            self?.image = image as? Asset
        }
        */
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `Fields` enum.
    enum FieldKeys: String, CodingKey {
        case planName, checkListGroups
    }
}
