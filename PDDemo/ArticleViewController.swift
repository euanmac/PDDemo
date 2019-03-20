//
//  SecondViewController.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 28/10/2018.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import markymark


class ArticleViewController: UIViewController, Storyboarded {

    @IBOutlet weak var articleText: UITextView!
    var articleSingle : ArticleSingle?
     
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Check we have an article object
        guard let articleSingle = articleSingle else {
            return
        }
        self.title = articleSingle.articleTitle
        self.navigationItem.largeTitleDisplayMode = .never
        if articleSingle.hasContent {
            articleText.attributedText = articleSingle.getAttributedContent(completion: renderedContent)
            articleText.contentOffset.y = 0
        }
        
    }
    
    //Call back when async rendering is done, needs to be on main thread
    private func renderedContent(attributedText: NSAttributedString) {
        DispatchQueue.main.async {
            self.articleText.attributedText = attributedText
        }
    }
    
}

