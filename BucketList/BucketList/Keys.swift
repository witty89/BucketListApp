//
//  Keys.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import Foundation
import CloudKit

struct Keys {
    
    // MARK: - TableView Functions 
    
    // from ListsTVC
    static let listCell = "listCell"
    static let listCellToListDVC = "listCellToListDVC"
    
    // from ItemsTVC
    static let itemCell = "itemCell"
    static let itemCellToItemDVC = "itemCellToItemDVC"
    static let itemCellToMap = "itemCellToMap"
    
    // Mark: - Class Keys
    // stuff for CloudKit
    static let listRecordType = "List"
    static let listNameKey = "listName"
    static let itemsKey = "items"
    static let itemsRecordType = "items"
    
    static let itemRecordType = "Item"
    static let itemNameKey = "itemName"
    static let isCompleteKey = "isComplete"
    static let notesKey = "notes"
    static let photosKey = "photos"
    static let ownerRefKey = "ownerRef"
    
    // Mark: - NotificationCenter
    static let DidRefreshNotification = Notification.Name("DidRefreshNotification")
}

protocol CloudKitSyncable {
    
    //    init?(record: CKRecord)
    
    var cloudKitRecordID: CKRecordID? { get set }
    var recordType: String { get }
}

extension CloudKitSyncable {
    
    var isSynced: Bool {
        return cloudKitRecordID != nil
    }
    
    var cloudKitReference: CKReference? {
        
        guard let recordID = cloudKitRecordID else { return nil }
        
        return CKReference(recordID: recordID, action: .deleteSelf)
    }
}
