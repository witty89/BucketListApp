//
//  ItemController.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import UIKit
import CloudKit

class ListController {
    
    static let shared = ListController()
    
    var lists: [List] = [] {
        didSet {
            DispatchQueue.main.async {
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: Keys.DidRefreshNotification, object: self)
            }
        }
    }
    
    func createList(listName: String, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let list = List(listName: listName)
        let record = CKRecord(list)
        CloudKitManager.cloudKitManager.save(record: record) { (error) in
            defer { completion(error) }
            if let error = error {
                print("In \(#file) \(#function) - Error saving createdList to CloudKit with error \(error)")
                return
            }
        }
        self.lists.append(list)
    }
    
    //    func deleteList(recordID: CKRecordID, completion: @escaping (Error?) -> Void) {
    //        CloudKitManager.cloudKitManager.deleteRecordWithID(recordID) { (record, error) in
    //            if let error = error {
    //                print("Error: \(error.localizedDescription) File: \(#file) Line: \(#line). Error deleting list")
    //            }
    //            if let record = record {
    //                print("We got the record, let's delete it")
    //                // TODO: - delete record http://stackoverflow.com/questions/30336590/how-to-delete-a-ckrecord
    //            }
    //        }
    //    }
    
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
        
        
        self.fetchNewRecords(ofType: Keys.listRecordType) { // get this from the fetchNewRecords func in 12AM
                
                self.isSyncing = false
                completion()
        }
    }
    
    private func recordsOf(type: String) -> [CloudKitSyncable] {
        switch type {
        case Keys.listRecordType:
            return lists.flatMap { $0 as CloudKitSyncable }
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

        if type == Keys.listRecordType {
            predicate = NSPredicate(value: true)
        }
            
        referencesToExclude = self.syncedRecords(ofType: type).flatMap {$0.cloudKitReference}
        
        CloudKitManager.cloudKitManager.fetchRecordsWithType(Keys.listRecordType, recordFetchedBlock: nil) { (records, error) in
            guard let records = records else { completion(); return }
            switch type {
            case Keys.listRecordType:
                let lists = records.flatMap { List(cloudKitRecord: $0) }
                ListController.shared.lists = lists
                completion()
            default:
                completion() ; return
            }
        }
    }
}
