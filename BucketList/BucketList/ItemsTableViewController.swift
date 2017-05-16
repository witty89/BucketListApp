//
//  ItemsTableViewController.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var list: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addItemButtonTapped(_ sender: Any) {
        addItemAlertController()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.shared.items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Keys.itemCell, for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        
        let item = ItemController.shared.items[indexPath.row]
        cell.item = item
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            let item = ItemController.shared.items[indexPath.row]
            guard let list = list else { return }
            ItemController.shared.delete(item: item, from: list)
        }
    }
    
    func addItemAlertController() {
        let addItemAlertController = UIAlertController(title: "Add item to list", message: nil, preferredStyle: .alert)
        addItemAlertController.addTextField { (itemNameTextField) in
            itemNameTextField.placeholder = "Item Name"
        }
        let newItemAction = UIAlertAction(title: "Add Item", style: .default) { (_) in
            ItemController.shared.createItem(itemName: (addItemAlertController.textFields?.first?.text)!, isComplete: false, completion: { (error) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addItemAlertController.addAction(newItemAction)
        addItemAlertController.addAction(cancelAction)
        present(addItemAlertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.itemCellToItemDVC {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? NotesViewController else { return }
            let item = ItemController.shared.items[indexPath.row]
            detailVC.item = item
        }
        if segue.identifier == Keys.itemCellToMap {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? MapViewController else { return }
            let item = ItemController.shared.items[indexPath.row]
            detailVC.item = item
        }
    }
}











