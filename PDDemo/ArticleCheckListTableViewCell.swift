//
//  ArticleCheckListTableViewCell.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 09/12/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

protocol CustomTableViewCellDelegate {
    func didToggleRadioButton(_ indexPath: IndexPath)
}

class ArticleCheckListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var radioButton: CheckListButton!
    
    
    func update(with article: ArticleSingle) {
        title.text = article.articleTitle ?? ""
        subtitle.text = article.subtitle ?? ""
        radioButton.isHidden = !article.isCheckList
    }
}
