//
//  ItemController.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import UIKit
import CloudKit

class ItemController {
    
    static let shared = ItemController()
    
    var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: Keys.DidRefreshNotification, object: self)
            }
        }
    }
    
    func createItem(itemName: String, isComplete: Bool, completion: @escaping (() -> Void) = { _ in }) {
        CloudKitManager.cloudKitManager.fetchLoggedInUserRecord { (record, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) File: \(#file) Line: \(#line)")
                completion(); return
            }
            if let userRecord = record {
                let reference = CKReference(recordID: userRecord.recordID, action: .deleteSelf)
                let item = Item(ownerRef: reference, itemName: itemName)
            
                let record = CKRecord(item)
                CloudKitManager.cloudKitManager.saveRecord(record, completion: { (record, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription) File: \(#file) Line: \(#line)")
                        completion() ; return
                    }
                    print("Successsfulllly saved item to cloudKit!")
                    self.items.append(item)
                    completion()
                })
            }
        }
    }
    
    func updateItem(item: Item) {
        
    }
    
    func delete(item: Item, from list: List) {
//        http://theapplady.net/cloudkit-delete-a-record/
    }
    
    // Mark: - stuff to do to fetch records from Cloud
    
    func requestFullSync(_ completion: (() -> Void)? = nil) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.performFullSync {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            completion?()
        }
    }
    
    var isSyncing: Bool = false
    
    func performFullSync(completion: @escaping (() -> Void) = { _ in }) {
        
        guard !isSyncing else {
            completion()
            return
        }
        
        isSyncing = true
        
        
        self.fetchNewRecords(ofType: Keys.itemRecordType) {
            self.isSyncing = false
            completion()
        }
    }
    
    private func recordsOf(type: String) -> [CloudKitSyncable] {
        switch type {
        case Keys.itemRecordType:
            return items.flatMap { $0 as? CloudKitSyncable }
        default:
            return []
        }
    }
    
    func syncedRecords(ofType type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { $0.isSynced }
    }
    
    func unsyncedRecords(ofType type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { !$0.isSynced }
    }
    
    func fetchNewRecords(ofType type: String, completion: @escaping (() -> Void) = { _ in }) {
        var referencesToExclude = [CKReference]()
        var predicate: NSPredicate?
        
        if type == Keys.itemRecordType {
            predicate = NSPredicate(value: true)
        }
        
        referencesToExclude = self.syncedRecords(ofType: type).flatMap {$0.cloudKitReference}
        
        CloudKitManager.cloudKitManager.fetchRecordsWithType(Keys.itemRecordType, recordFetchedBlock: nil) { (records, error) in
            guard let records = records else { completion(); return }
            switch type {
            case Keys.itemRecordType:
                let items = records.flatMap { Item(cloudKitRecord: $0) }
                self.items = items
                completion()
            default:
                completion() ; return
            }
        }
    }
}
