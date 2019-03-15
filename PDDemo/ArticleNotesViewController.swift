//
//  ArticleNotesViewController.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 07/03/2019.
//  Copyright © 2019 pddemo. All rights reserved.
//

import UIKit

class ArticleNotesViewController: UIViewController, UITextViewDelegate, Storyboarded {
    
    @IBOutlet private weak var noteText: UITextView!
    var articleNote: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assume articleNote will be set
        noteText.text = articleNote
        
        //set text box to have the focus
        noteText.becomeFirstResponder()
        noteText.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == noteText {
            articleNote = noteText.text
        }
    }
}
