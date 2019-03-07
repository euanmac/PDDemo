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
        content.attributedText = articleImage.getAttributedContent()
        
        //Get image and load asynchronously
        articleImage.getImage() { (image) in
            DispatchQueue.main.async {
                self.imageView.image = image
                print ("Set image")
            }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
