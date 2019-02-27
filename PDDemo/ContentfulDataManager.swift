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
    
    typealias AssetID = String
    let SPACE_ID = "4hscjhj185vb"
    let ACCESS_TOKEN = "b4ab36dc9ea14f8e8e4a3ece38115c907302591186e836d0cdfc659144b75e85"
    let SYNC_TOKEN = "synctoken.json"
    let HEADER_CACHE = "headercache.json"
  
    //Array of listeners
    var observers = [ContentfulDataObserver]()
    //Image cache
    var imageCache: [AssetID: UIImage] = [:]
    //Headers
    var headers = [Header]()
    
    private(set) var headersCached = false
    
    //Hide initialiser to make singleton
    private init() {}
    static let shared = ContentfulDataManager()
   
    //Initialises the processes of populating the headers object model
    //Will attempt to load from cached json file if available and not changed
    //If not will attempt to download from the contentful website
    //Once loaded will let any registered listeners know outcome of load
    public func fetchHeaders() {
        
        //Try loading from cache, if successful call listeners
        //Errors here are suppressed as not fatal
        //TODO: Add logging
//        if let cacheHeaders = fetchHeadersFromFileCache() {
//            headers = cacheHeaders
//            headersCached = true
//            observers.forEach() {$0.headersLoaded(result: Result.success(cacheHeaders))}
//            return
//        }
        
        //No file cached headers so will get contentful space and initialise model from there
        fetchHeadersFromSyncSpace() {(result: Result<[Header]>) in
            switch result {
            case .success(let syncHeaders):
                self.headers = syncHeaders
                self.writeHeadersToFileCache()
                self.headersCached = true
                self.observers.forEach() {$0.headersLoaded(result: Result.success(syncHeaders))}
                
            case .error(let err):
                print("Could not load data - todo show error to user")
            }
        }
        return
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
        
    //Initialies the object model from contentful space
    private func initHeaders(from space: SyncSpace) -> [Header] {
        
        return space.entries.filter({$0.sys.contentTypeId == "header"}).map() {entry in
            return Header(from: entry)
        }
    }
    
    //Retrieve image for a given asset using the Contentful client.
    //Will call a completion handler on succesful fetch of image and pass the UIImage to it.
    public func fetchImage(for asset: Asset, _ completion: @escaping ((UIImage) -> Void)) {
        let client: Client = Client(spaceId: SPACE_ID, accessToken: ACCESS_TOKEN)
        client.fetchImage(for: asset) { (result: Result<UIImage>) in
            switch result {
            case .success(let image):
                completion(image)
            case .error(let error):
                print("Oh no something went wrong: \(error)")
            }
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
            fatalError("Couldnt write to file " + cacheFile.absoluteString)
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
    
    //Maps a list of linked sub entries
//    internal func mapTo <T> (types: [T.Type]) -> T? where T : EntryMappable & ContentType
//    {
//        //Ensure we are passed a type that maps to the entry type
//             
//        
//        //Init the type found using the entry and cast to T
//        //return mapType.init(from: self)
//        
//    }
    
}


// This is a magic workaround for the fact that dynamic metatypes cannot be passed into
// initializers such as UnkeyedDecodingContainer.decode(Decodable.Type), yet static methods CAN
// be called on metatypes.
//internal extension Decodable where Self: ArticleDecodable {
//    // This is a magic workaround for the fact that dynamic metatypes cannot be passed into
//    // initializers such as UnkeyedDecodingContainer.decode(Decodable.Type), yet static methods CAN
//    // be called on metatypes.
//    static func popEntryDecodable(from container: inout UnkeyedDecodingContainer) throws -> Self {
//        let entryDecodable = try container.decode(self)
//        return entryDecodable
//    }
//}

//Extension to decode an array of types
internal extension KeyedDecodingContainer {
    
    /// Decode a heterogeneous list of objects given an array of decodable types
    /// - Parameters:
    ///     - heterogeneousType: The decodable type of the list.
    ///     - family: The ClassFamily enum for the type family.
    ///     - key: The CodingKey to look up the list in the current container.
    /// - Returns: The resulting list of heterogeneousType elements.
//    func decode(forTypes types: [ArticleDecodable.Type], forKey
//        key: K) throws -> [ArticleDecodable] {
//        
//        var container = try self.nestedUnkeyedContainer(forKey: key)
//        var list = [ArticleDecodable]()
//        var tmpContainer = container
//        var types2 : [EntryMappable] = [ArticleList.self, ArticleSingle.self, ArticleImage.self]
//        
//        while !container.isAtEnd {
//            let typeContainer = try container.nestedContainer(keyedBy: CodingTypes.self)
//            let jSONtype = try typeContainer.decode(String.self, forKey: CodingTypes.contentTypeId)
//            
//            for contreteType in types2 {
//                if contreteType.contentTypeId == jSONtype {
//                    list.append(try contreteType.popEntryDecodable(from: &tmpContainer))
//                }
//            }
//        
//        }
//        return list
//    }
}


//Struct to hold sync token
struct SyncToken {
    let token: String
}



//    func fetchHeaders(completion: @escaping ((Bool) -> Void)) {
//
//        //Check if headers are cached in memory, if so then call handler and return
//        if (headersCached) {
//            completion(true)
//            return
//        }
//
//        //Load sync token from file
//        //self.headers = readHeadersFromCache()
//
////        let contentTypeClasses: [EntryDecodable.Type]? = [
////            Header.self,
////            ArticleSingle.self,
////            ArticleList.self,
////            ArticleListSection.self,
////            ArticleImage.self
////        ]
//
//        let client: Client = Client(spaceId: SPACE_ID, accessToken: ACCESS_TOKEN, contentTypeClasses: contentTypeClasses)
//
//        //Fetch array of Plan objects and decode, if successful then store in class variable and call completion handler
//        client.fetchArray(of: Header.self, matching: QueryOn<Header>().include(3)) { (result: Result<ArrayResponse<Header>>) in
//
//            switch result {
//
//            case .success(let headerResponse):
//                self.headers = headerResponse.items
//                self.headersCached = true
//                self.writeHeadersToCache()
//                completion(true)
//
//            case .error(let error):
//                print("Oh no something went wrong: \(error)")
//                completion(false)
//            }
//        }
//    }


/*
if let filepath = Bundle.main.path(forResource: "InitPuzzle4x4", ofType: "json") {
    do {
        let jsonURL = URL(fileURLWithPath: filepath)
        let jsonData = try Data(contentsOf: jsonURL)
        blockPuzzle  = try JSONDecoder().decode(BlockPuzzle.self, from: jsonData)
        
    } catch {
        // contents could not be loaded
        print (error)
    }
} else {
    // example.txt not found!
}

return
}
private func savePuzzle() throws -> Void {
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsDirectory.appendingPathComponent("PuzzleBlock")
    
    if let jsonData = try? JSONEncoder().encode(blockPuzzle) {
        let jsonString = String(data: jsonData, encoding: .utf8)
        try jsonData.write(to: archiveURL)
    }
    return
}
*/

////Extend Sys class so it can be written and cached
//extension Sys : Encodable  {
//    public func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(type, forKey: .type)
//        try container.encodeIfPresent(createdAt, forKey: .createdAt)
//        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
//        try container.encodeIfPresent(locale, forKey: .locale)
//        try container.encodeIfPresent(revision, forKey: .revision)
//        try container.encodeIfPresent(contentTypeId, forKey: .contentType)
//    }
//}
