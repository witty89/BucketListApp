//
//  ListsTableViewController.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ListController.shared.fetchNewRecords(ofType: Keys.listRecordType)
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        newListAlertController()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListController.shared.lists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.listCell, for: indexPath)
        let list = ListController.shared.lists[indexPath.row]
        cell.textLabel?.text = list.listName
        cell.detailTextLabel?.text = "\(list.items.count) items"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            let list = ListController.shared.lists[indexPath.row]
//            ListController.shared.deleteList(list: list)
//        }
    }
    
    func newListAlertController() {
        let alertController = UIAlertController(title: "Create New List", message: "Create a new list and add items to it", preferredStyle: .alert)
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "List Name"
        }
        
        let newListAction = UIAlertAction(title: "New List", style: .default) { (_) in
            ListController.shared.createList(listName: (alertController.textFields?.first?.text)!) { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(newListAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.listCellToListDVC {
            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? ItemsTableViewController else { return }
            let list = ListController.shared.lists[indexPath.row]
            detailVC.list = list
        }
    } 
}













