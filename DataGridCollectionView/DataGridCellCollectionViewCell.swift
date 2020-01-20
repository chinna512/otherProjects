//
//  DataGridCellCollectionViewCell.swift
//  DataGridCollectionView
//
//  Created by chinnababu on 20/01/20.
//  Copyright © 2020 chinnababu. All rights reserved.
//

import UIKit

class DataGridCellCollectionViewCell: UICollectionViewCell {
    var editClosure : ((_ index:Int) -> Void)?
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    var isEdit = false
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = ""
        self.backgroundColor = .clear
        self.leadingConstraint.constant = 0
    }
    
    func reloadDataForTheCellIfEdit(isEdit:Bool, text:String, section:Int) {
        self.textLabel.text = text
        self.editButton.tag = section
        if !isEdit {
            leadingConstraint.constant = 0
        } else {
            leadingConstraint.constant = 25
        }
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.editClosure!(self.editButton.tag)
    }
    
}
