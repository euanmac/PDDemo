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

protocol EntryMappable : EntryDecodable {
    init (from: Entry)
}

public extension Entry {
    
    /// A set of convenience subscript operators to access the fields dictionary directly and return a value
    /// for a given Coding Key
    public subscript(key: CodingKey) -> Int? {
        return fields[key.stringValue] as? Int
    }
    
    public subscript(key: CodingKey) -> String? {
        return fields[key.stringValue] as? String
    }
    
    public subscript(key: CodingKey) -> Bool? {
        return fields[key.stringValue] as? Bool
    }
    
    public subscript(entryKey key: CodingKey) -> Entry? {
        return fields.linkedEntry(at: key.stringValue)
    }
    
    public subscript(key: CodingKey) -> [Entry]? {
        return fields.linkedEntries(at: key.stringValue)
    }
    
    public subscript(key: CodingKey) -> Asset? {
        return fields.linkedAsset(at: key.stringValue)
    }
    
    public subscript(key: CodingKey) -> [Asset]? {
        return fields.linkedAssets(at: key.stringValue)
    }
    
    //Maps a list of linked sub entries
    internal func mapTo (types: [EntryMappable.Type]) -> EntryMappable?
    {
        //Ensure we are passed a type that maps to the entry type
        guard let mapType = types.first(where: {$0.contentTypeId == self.sys.contentTypeId}) else {
            return nil
        }
        
        //Init the type found using the entry and cast to T
        return mapType.init(from: self)
        
    }
    
}


final class ContentfulDataManager {
    
    typealias AssetID = String
    let SPACE_ID = "4hscjhj185vb"
    let ACCESS_TOKEN = "b4ab36dc9ea14f8e8e4a3ece38115c907302591186e836d0cdfc659144b75e85"
    let SYNC_TOKEN = "synctoken.json"
    let HEADER_CACHE = "headercache.json"
  
    var headers = [Header]()
    private(set) var headersCached = false
    var imageCache: [AssetID: UIImage] = [:]
    
    private init() {}
    static let shared = ContentfulDataManager()
    
   
    
    
    //Get Sync Info, if existing sync token then use that, otherwise empty string to get an initial sync token
    func initialSync(){
        
        let client: Client = Client(spaceId: SPACE_ID, accessToken: ACCESS_TOKEN)
        let syncSpace = SyncSpace()
        
        client.sync(for: syncSpace) {(result: Result<SyncSpace>) in
            switch result {
            case .success(let nextSyncSpace):
                    print(nextSyncSpace.syncToken)
                
                case .error(let error):
                    print("Oh no something went wrong: \(error)")
            
            }
        }
    }
    
    //Download Headers and articles
    func fetchSyncSpace(completion: @escaping ((Bool) -> Void)) {
        
        let client: Client = Client(spaceId: SPACE_ID, accessToken: ACCESS_TOKEN)
        client.sync() { (result: Result<SyncSpace>) in
            
            switch result {
                
            case .success(let syncSpace):
                self.headers = self.initHeaders(from: syncSpace)
                completion(true)
                
            case .error(let error):
                print("Oh no something went wrong: \(error)")
                completion(false)
            }
        }
        
    }
    
    //Class to map contentful entries to an object model
    class ContentfulDataMapper {
        
        let types: [EntryDecodable.Type]
        init(contentTypeClasses: [EntryDecodable.Type]) {
            self.types = contentTypeClasses
        }
    }
    
    private func initHeaders(from space: SyncSpace) -> [Header] {
        return space.entries.filter({$0.sys.contentTypeId == "header"}).map() {entry in
            return Header(from: entry)
        }
    }
    
    //Download Headers and articles
    func fetchHeaders(completion: @escaping ((Bool) -> Void)) {
        
        //Check if headers are cached in memory, if so then call handler and return
        if (headersCached) {
            completion(true)
            return
        }
        
        //Load sync token from file
        //self.headers = readHeadersFromCache()
        
        let contentTypeClasses: [EntryDecodable.Type]? = [
            Header.self,
            ArticleSingle.self,
            ArticleList.self,
            ArticleListSection.self,
            ArticleImage.self
        ]
        
        let client: Client = Client(spaceId: SPACE_ID, accessToken: ACCESS_TOKEN, contentTypeClasses: contentTypeClasses)
        
        //Fetch array of Plan objects and decode, if successful then store in class variable and call completion handler
        client.fetchArray(of: Header.self, matching: QueryOn<Header>().include(3)) { (result: Result<ArrayResponse<Header>>) in
            
            switch result {
            
            case .success(let headerResponse):
                self.headers = headerResponse.items
                self.headersCached = true
                self.writeHeadersToCache()
                completion(true)
                
            case .error(let error):
                print("Oh no something went wrong: \(error)")
                completion(false)
            }
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
    private func writeHeadersToCache() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(headers)
        let cachesDir = FileManager().urls(for: .cachesDirectory, in: .allDomainsMask).first!
        let cacheFile = cachesDir.appendingPathComponent(HEADER_CACHE)
        print (cacheFile.absoluteURL)
        do {
            try data.write(to: cacheFile)
        } catch {fatalError("Couldnt write to file")}
        return

    }
    
    
    private func readHeadersFromCache() -> [Header] {
        let decoder = JSONDecoder()
        let cachesDir = FileManager().urls(for: .cachesDirectory, in: .allDomainsMask).first!
        let cacheFile = cachesDir.appendingPathComponent(HEADER_CACHE)
        print(cacheFile.absoluteURL)
        do {
            let jsonData = try Data(contentsOf: cacheFile)
            let a  = try JSONDecoder().decode([Header].self, from: jsonData)
            return a
            
        } catch {
            // contents could not be loaded
            print (error)
            return [Header]()
        }
        
    }
    
}

//Extend Sys class so it can be written and cached
extension Sys : Encodable  {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(locale, forKey: .locale)
        try container.encodeIfPresent(revision, forKey: .revision)
        try container.encodeIfPresent(contentTypeId, forKey: .contentType)
    }
}

//Struct to hold sync token
struct SyncToken {
    let token: String
}


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
