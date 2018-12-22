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

final class ContentfulDataManager {
    
    typealias AssetID = String
    let SPACE_ID = "4hscjhj185vb"
    let ACCESS_TOKEN = "b4ab36dc9ea14f8e8e4a3ece38115c907302591186e836d0cdfc659144b75e85"
    
  
    var headers = [Header]()
    private(set) var headersCached = false
    
    var imageCache: [AssetID: UIImage] = [:]
    
    private init() {}
    static let shared = ContentfulDataManager()
    
    
    //Download Headers and articles
    func fetchHeaders(completion: @escaping (() -> Void)) {
        
        //Check if headers are cached then call handler and return
        if (headersCached) {
            completion()
            return
        }
        
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
                completion()
                
            case .error(let error):
                print("Oh no something went wrong: \(error)")
            }
        }
    }
    
    //Retrieve image for a given asset using the Contentful client.
    //Will call a completion handler on succesful fetch of image and pass the UIImage to it.
    func fetchImage(for asset: Asset, _ completion: @escaping ((UIImage) -> Void)) {
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
    
}

