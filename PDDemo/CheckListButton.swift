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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //Delegate to respond to value changes of the radio button
    var buttonValueChangedHandler : ((Bool) -> Void)?
    
    //Set up the images and delegate
    public func setupButton(hidden: Bool) {
        let deselectedImage = UIImage(named: "ic_radio_button_unchecked_white")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "ic_radio_button_checked_white")?.withRenderingMode(.alwaysTemplate)
        self.setImage(deselectedImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.isHidden = hidden //Remove this if want to keep text aligned when no radio button
        self.tintColor = hidden ? UIColor.clear : UIColor(hex: 0xDB324D)
        self.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }

    
    //Respond to button tapped
    @objc func radioButtonTapped(_ radioButton: UIButton) {
        let isSelected = !self.isSelected
        self.isSelected = isSelected
        //Check if delegate var not nil and if so call
        if let buttonValueChangedHandler = buttonValueChangedHandler {
            buttonValueChangedHandler(self.isSelected)
        }
    }


}
