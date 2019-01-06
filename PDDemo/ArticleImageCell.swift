//
//  ArticleImageCell.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 05/01/2019.
//  Copyright © 2019 pddemo. All rights reserved.
//

import UIKit

class ArticleImageCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    func update(with article: Article) {
        //Setup cell - set text to blank if no title or subtitle
        title.text = article.articleTitle ?? ""
        
    }
}
