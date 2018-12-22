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
        guard let _ = articleSingle else {
            return
        }
        self.title = articleSingle?.articleTitle
        self.navigationItem.largeTitleDisplayMode = .never
        if let content = articleSingle?.articleContent {
            articleText.attributedText = getAttributedText(text: content)
        }
    }
    
    //Convert MarkDown to AttributedString
    func getAttributedText(text: String, styling: Styling = DefaultStyling()) -> NSAttributedString {
        let markyMark = MarkyMark() { $0.setFlavor(ContentfulFlavor()) }
        let markdownItems = markyMark.parseMarkDown(text)
        let config = MarkDownToAttributedStringConverterConfiguration(styling: styling)
        
        let converter = MarkDownConverter(configuration: config)
        let attributedText = converter.convert(markdownItems)
        return attributedText
    }


}

