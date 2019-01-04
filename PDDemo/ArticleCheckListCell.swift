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
        //Setup cell - set text to blank if no title or subtitle
        title.text = article.articleTitle ?? ""
        subtitle.text = article.subtitle ?? ""
        
        //setup radio button delegate to this class
        radioButton.setupButton(hidden: !article.isCheckList)
        radioButton.buttonValueChangedHandler = buttonValueChangedHandler
        
        //show disclosure indicator if more content. Disable selection if no more content
        self.accessoryType = article.hasContent ? .disclosureIndicator : .none
        self.selectionStyle = article.hasContent ? .default : .none
        
    }
    
    func buttonValueChangedHandler(value: Bool) {
        print("Button Value " + value.description)
    }
}
