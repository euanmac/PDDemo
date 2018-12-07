//
//  Cat.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 28/10/2018.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import Contentful
import UIKit

final class ECG: EntryDecodable, FieldKeysQueryable {
    
    static let contentTypeId: String = "ecg"
    
    var id: String
    var updatedAt: Date?
    var createdAt: Date?
    var localeCode: String?
    let name: String?
    let rhythym: String?
    let rate: String?
    let pWave: String?
    let prInterval: String?
    let qrsComplex: String?
    let causes: String?
    let keyFeatures: String?

    var ecgImage: Asset?
    var ecgImageCache: UIImage?
    
    public required init(from decoder: Decoder) throws {
        let sys = try decoder.sys()
        id = sys.id
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: ECG.FieldKeys.self)
        
        self.name       = try fields.decodeIfPresent(String.self, forKey: .name)
        self.rhythym      = try fields.decodeIfPresent(String.self, forKey: .rhythym)
        self.rate      = try fields.decodeIfPresent(String.self, forKey: .rate)
        self.pWave      = try fields.decodeIfPresent(String.self, forKey: .pWave)
        self.prInterval      = try fields.decodeIfPresent(String.self, forKey: .prInterval)
        self.qrsComplex      = try fields.decodeIfPresent(String.self, forKey: .qrsComplex)
        self.causes      = try fields.decodeIfPresent(String.self, forKey: .causes)
        self.keyFeatures      = try fields.decodeIfPresent(String.self, forKey: .keyFeatures)
        
//        try fields.resolveLink(forKey: .bestFriend, decoder: decoder) { [weak self] linkedCat in
//            self?.bestFriend = linkedCat as? ECG
//        }
        
        try fields.resolveLink(forKey: .ecgImage, decoder: decoder) { [weak self] image in
            self?.ecgImage = image as? Asset
        }
    }
    
    // If your field names and your properties names differ, you can define the mapping in your `FieldKeys` enum.
    enum FieldKeys: String, CodingKey {

        case name, ecgImage, rhythym, rate, pWave, prInterval, qrsComplex, causes, keyFeatures
        
    }
}

