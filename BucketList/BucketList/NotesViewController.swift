//
//  NotesViewController.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTextField: UITextView!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let notes = notesTextField.text else { item?.notes.append("") ; return }
        item?.notes.append(notes)
        navigationController?.popViewController(animated: true)
    }
}
