//
//  ArticleCheckListTableViewCell.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 09/12/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

protocol ArticleCheckListCellDelegate {
    func didToggleRadioButton(_ indexPath: IndexPath)
}

class ArticleCheckListCell: UITableViewCell {
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var radioButton: CheckListButton!

    func update(with article: Article) {
        title.text = article.articleTitle ?? ""
        subtitle.text = article.subtitle ?? ""
        radioButton.setupButton(hidden: !article.isCheckList)
        //set delegate to this class
        radioButton.buttonValueChangedHandler = buttonValueChangedHandler
    }
    
    func buttonValueChangedHandler(value: Bool) {
        print("Button Value " + value.description)
    }
}
