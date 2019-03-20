//
//  ECGDetailViewController.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 05/11/2018.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import markymark

class ArticleImageViewController: UIViewController, Storyboarded {

    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var articleImage : ArticleImage?
    var navigatorDelegate: NavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check we have a valid ecg instance and if so load data onto control
        guard let articleImage = articleImage else {return}
        self.navigationItem.largeTitleDisplayMode = .never
        loadData(articleImage)
        
    }
    
    //Load data from Article object
    private func loadData(_ articleImage: ArticleImage) {
        
        //Set title text and content
        if articleImage.articleTitle != nil {navigationItem.title = articleImage.articleTitle!}
        
        let renderText: (NSAttributedString)->() = { attributedContent in
            DispatchQueue.main.async {
                self.content.attributedText = attributedContent
            }
        }
        
        //Set text and call asynchronously to download images
        content.attributedText = articleImage.getAttributedContent(completion: renderText)
        content.contentOffset.y = 0
        
        //Get image and load asynchronously
        articleImage.getImage() { (image) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

}
