//
//  CheckListButton.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 10/12/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

class CheckListButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    //Set up the images and delegate
    private func setupButton() {
        let deselectedImage = UIImage(named: "ic_radio_button_unchecked_white")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "ic_radio_button_checked_white")?.withRenderingMode(.alwaysTemplate)
        self.setImage(deselectedImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    @objc func radioButtonTapped(_ radioButton: UIButton) {
        print("Checklist button tapped")
        let isSelected = !self.isSelected
        self.isSelected = isSelected
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
