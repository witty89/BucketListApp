//
//  ItemTableViewCell.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var hasPhotosButton: UIButton!
    
    var item: Item? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let item = item else { return }
        
        delegate?.buttonTapped(sender: self)
        
        itemNameTextField.text = item.itemName
        
        item.isComplete ? completeButton.setImage(#imageLiteral(resourceName: "bucketCheck"), for: .normal) : completeButton.setImage(#imageLiteral(resourceName: "BucketNoCheck"), for: .normal)
        
        if item.photos.count > 0 {
            hasPhotosButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        }
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        guard let item = item else { return }
        item.isComplete = !item.isComplete
        updateViews()
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        // Go to map Vcontroller
    }
    
    weak var delegate: ItemTableViewCellDelegate?
}

protocol ItemTableViewCellDelegate: class {
    func buttonTapped(sender: ItemTableViewCell)
}
