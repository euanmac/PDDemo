//
//  ContentfulData.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 29/10/2018.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import Contentful
import UIKit

enum CodingTypes: String, CodingKey {
    case contentTypeId
}

protocol EntryMappable {
    init (from: Entry)
}

protocol ContentfulDataObserver {
    func headersLoaded(result: (Result<[Header]>))
}

final class ContentfulDataManager {
    
    public let SPACE_ID = "4hscjhj185vb"
    public let ACCESS_TOKEN = "b4ab36dc9ea14f8e8e4a3ece38115c907302591186e836d0cdfc659144b75e85"
    private let SYNC_TOKEN = "synctoken.json"
    private let HEADER_CACHE = "headercache.json"
    private let NOTES_FILE = "notes.json"
  
    //Array of listeners
    var observers = [ContentfulDataObserver]()
    //Image cache
    //var imageCache: [AssetID: UIImage] = [:]
    //Headers
    var headers = [Header]()
    //Notes- provide access through property so Notes can be loaded only when needed
    private var notes = ArticleNotes()
    
    //Hide initialiser to make singleton
    private init() {}
    static let shared = ContentfulDataManager()
   
    //Property for notes - will load notes when first requested
    public var articleNotes : ArticleNotes {
        get {
            if notes.state == .empty {
                //Load notes
                notes = fetchNotesFromFile() ?? ArticleNotes()
            }
            return notes
        }
        
        set {
            notes = newValue
            notes.state = .changed
        }
    }
    
    //Initialises the processes of populating the headers object model
    //Will attempt to load from cached json file if available and not changed
    //If not will attempt to download from the contentful website
    //Once loaded will let any registered listeners know outcome of load
    public func fetchHeaders(useCache: Bool = true) {
        
        //Try loading from cache, if successful call listeners
        //Errors here are suppressed as not fatal
        //TODO: Add logging
        if useCache, let cacheHeaders = fetchHeadersFromFileCache() {
            headers = cacheHeaders
            observers.forEach() {$0.headersLoaded(result: Result.success(cacheHeaders))}
            print("Successfully loaded \(cacheHeaders.count) headers from cache")
            return
        }
        
        //No file cached headers so will get contentful space and initialise model from there
        fetchHeadersFromSyncSpace() {(result: Result<[Header]>) in
            switch result {
            case .success(let syncHeaders):
                self.headers = syncHeaders
                self.writeHeadersToFileCache()
                self.observers.forEach() {$0.headersLoaded(result: Result.success(syncHeaders))}
                
            case .error(let err):
                //TODO: Log this properly
                print(err.localizedDescription)
            }
        }
        return
    }
    
    //Retrieve image for a given URL string using the Contentful client.
    //Will call a completion handler on succesful fetch of image and pass the UIImage to it otherwise will pass nil
    public func fetchImage(for imageUrl: String, _ completion: @escaping ((UIImage?) -> Void)) {
        
        //Check we have a valid URL, if not exit and call completion with nil
        guard let url = URL(string: imageUrl) else {
            completion(nil)
            //Todo : Log this
            print("Invalid URL string")
            return
        }
        
        //Otherwise use client to get image
        let client:Client = Client(spaceId: SPACE_ID, accessToken: ACCESS_TOKEN)
        let _ = client.fetch(url: url) { result in
            
            switch result {
            case .success(let imageData):
                let image = UIImage(data: imageData)
                completion(image)
            case .error(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    
    //Download object model from Contentful Space
    private func fetchHeadersFromSyncSpace(then completion: @escaping ResultsHandler<[Header]>) {
        
        let client: Client = Client(spaceId: SPACE_ID, accessToken: ACCESS_TOKEN)
        client.sync() { (result: Result<SyncSpace>) in
            
            switch result {
                
            case .success(let syncSpace):
                let syncHeaders = self.initHeaders(from: syncSpace)
                completion(Result.success(syncHeaders))
                
            case .error(let err):
                print("Oh no something went wrong: \(err)")
                completion(Result.error(err))
            }
        }
    }
        
    //Initialies the object model from contentful space entries
    private func initHeaders(from space: SyncSpace) -> [Header] {
        
        return space.entries.filter({$0.sys.contentTypeId == "header"}).map() {entry in
            return Header(from: entry)
        }
    }
    
    //Encode headers to JSON and write to file
    //Errors here can be suppressed for now unless trying to write file which will throw fatal error
    private func writeHeadersToFileCache() {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(headers)

        let cachesDir = FileManager().urls(for: .cachesDirectory, in: .allDomainsMask).first!
        let cacheFile = cachesDir.appendingPathComponent(HEADER_CACHE)
        print (cacheFile.absoluteURL)
        do {
            try data.write(to: cacheFile)
        } catch {
            fatalError("Couldnt write to cache " + cacheFile.absoluteString)
        }
        
        return
    }
    
    //Load the object model from json cache
    //Errors here  can be suppressed for now as will fall back to using contenful data
    private func fetchHeadersFromFileCache() -> [Header]? {
        
        //let decoder = JSONDecoder()
        let cachesDir = FileManager().urls(for: .cachesDirectory, in: .allDomainsMask).first!
        let cacheFile = cachesDir.appendingPathComponent(HEADER_CACHE)
        print(cacheFile.absoluteURL)
        do {
            let jsonData = try Data(contentsOf: cacheFile)
            let cachHeaders  = try JSONDecoder().decode([Header].self, from: jsonData)
            return cachHeaders
            
        } catch {
            // contents could not be loaded
            print (error)
            return nil
        }
    }
    
    //Load the article notes from json
    //Errors here  can be suppressed for now as will fall back to using contenful data
    private func fetchNotesFromFile() -> ArticleNotes? {
        
        let fileManager = FileManager()
        let docsDir = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first!
        let notesFile = docsDir.appendingPathComponent(NOTES_FILE)
        print(notesFile.path)
        
        
        //check file exists
        guard fileManager.fileExists(atPath: notesFile.path) else {
            return nil
        }
    
        do {
            let jsonData = try Data(contentsOf: notesFile)
            var notes  = try JSONDecoder().decode(ArticleNotes.self, from: jsonData)
            notes.state = .clean
            return notes
            
        } catch {
            // contents could not be loaded
            print (error)
            return nil
        }
    }
    
    
    //Encode notes to JSON and write to file
    //Errors here can be suppressed for now unless trying to write file which will throw fatal error
    public func writeNotesToFile() {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(notes)
        
        let docsDir = FileManager().urls(for: .documentDirectory, in: .allDomainsMask).first!
        let notesFile = docsDir.appendingPathComponent(NOTES_FILE)
        print (notesFile.absoluteURL)
        do {
            try data.write(to: notesFile)
            notes.state = .clean
        } catch {
            fatalError("Couldnt write notes to " + notesFile.absoluteString)
        }
        
        return
    }
    
}

extension Entry {
    
    /// A set of convenience subscript operators to access the fields dictionary directly and return a value
    /// for a given Coding Key
    subscript(key: CodingKey) -> Int? {
        return fields[key.stringValue] as? Int
    }
    
    subscript(key: CodingKey) -> String? {
        return fields[key.stringValue] as? String
    }
    
    subscript(key: CodingKey) -> Bool? {
        return fields[key.stringValue] as? Bool
    }
    
    subscript(entryKey key: CodingKey) -> Entry? {
        return fields.linkedEntry(at: key.stringValue)
    }
    
    subscript(key: CodingKey) -> [Entry]? {
        return fields.linkedEntries(at: key.stringValue)
    }
    
    subscript(key: CodingKey) -> Asset? {
        return fields.linkedAsset(at: key.stringValue)
    }
    
    subscript(key: CodingKey) -> [Asset]? {
        return fields.linkedAssets(at: key.stringValue)
    }
    
    //Maps an entry to one of a defined set of types
    //Returns nil if type on Entry is not known - makes
    //T should be an enum that describes set of concrete classes that could be mapped to
    func mapTo <T: ContentTypes>(types: T.Type) -> EntryMappable?  {
        
        if let contentType = types.init(rawValue: self.sys.contentTypeId!) {
            let mappedObject = contentType.getType().init(from: self)
            return mappedObject
        } else {
            //TODO: Log
            print("Type of entry not known, skipping")
            return nil
        }
    }
}

// Extension to decodable to allow decoded initialisation of object from it's type
internal extension Decodable where Self: Decodable {
    // This is a magic workaround for the fact that dynamic metatypes cannot be passed into
    // initializers such as UnkeyedDecodingContainer.decode(Decodable.Type), yet static methods CAN
    // be called on metatypes.
    static func popEntryDecodable(from container: inout UnkeyedDecodingContainer) throws -> Self {
        let entryDecodable = try container.decode(self)
        return entryDecodable
    }
}

//Extension to decode an array of types
internal extension KeyedDecodingContainer {
    
        //Specfic extennsion to decoder to allow decoding of heterogenous array
        //i.e. decode different concrete article types but coalesce into single array of [Article]
        //protocol instances. Requires set of possible types to be defined in ContentTypes enum
        func decode<T: ContentTypes> (types: T.Type, forKey
            key: K) throws -> [Decodable] {
    
            var container = try self.nestedUnkeyedContainer(forKey: key)
            var list = [Decodable]()
            var tmpContainer = container

            while !container.isAtEnd {
                let typeContainer = try container.nestedContainer(keyedBy: CodingTypes.self)
                let jSONtype = try typeContainer.decode(String.self, forKey: CodingTypes.contentTypeId)
            
                if let decodableType = types.init(rawValue: jSONtype)?.getType() as? Decodable.Type {
                    
                    list.append(try decodableType.popEntryDecodable(from: &tmpContainer))
                } else {
                    //TODO: Log
                    print("Type of entry not known, skipping")
                }
    
            }
            return list
        }
}

//Struct to hold sync token
//struct SyncToken {
//    let token: String
//}
