//
//  ArticleNotes.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 08/03/2019.
//  Copyright © 2019 pddemo. All rights reserved.
//
//  Dictionary Wrapper to hold notes and link them to an article
//  Simple so can be encoded and decoded with no fuss

import Foundation

import UIKit
import Foundation

typealias ArticleID = String

struct ArticleNotes : Codable {
    
    typealias ArticleNote = String
    private var notes = [ArticleID : ArticleNote]()
    
    enum State {
        case empty
        case clean
        case changed
    }
    
    var state = State.empty
    
    subscript(articleID: ArticleID) -> ArticleNote? {
        get {
            return notes[articleID]
        }
        set {
            notes[articleID] = newValue
            state = .changed
        }
    }
    enum CodingKeys: String, CodingKey {
        case notes
    }
}
