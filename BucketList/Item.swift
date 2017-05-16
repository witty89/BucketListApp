//
//  Item.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Item {
    
    let ownerRef: CKReference
    let itemName: String
    var isComplete: Bool
    var notes: String
    var photos: [UIImage]
    var cloudKitRecordID: CKRecordID?
    
    
    init(ownerRef: CKReference, itemName: String, isComplete: Bool = false, notes: String = "", photos: [UIImage] = []) {
        self.ownerRef = ownerRef
        self.itemName = itemName
        self.isComplete = isComplete
        self.notes = notes
        self.photos = photos
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let ownerRef = cloudKitRecord[Keys.ownerRefKey] as? CKReference,
            let itemName = cloudKitRecord[Keys.itemNameKey] as? String,
            let isComplete = cloudKitRecord[Keys.isCompleteKey] as? Bool,
            let notes = cloudKitRecord[Keys.notesKey] as? String,
            let photos = cloudKitRecord[Keys.photosKey] as? [UIImage] else { return nil }
        self.ownerRef = ownerRef
        self.itemName = itemName
        self.isComplete = isComplete
        self.notes = notes
        self.photos = photos
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

extension CKRecord {
    convenience init( _ item: Item) {
        let recordID = item.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "Item", recordID: recordID)
        self[Keys.ownerRefKey] = item.ownerRef as CKReference
        self[Keys.itemNameKey] = item.itemName as CKRecordValue?
        self[Keys.isCompleteKey] = item.isComplete as CKRecordValue?
        self[Keys.notesKey] = item.notes as CKRecordValue?
//        self[Keys.photosKey] = item.photos as [CKAsset] TODO: - deal with this later
        item.cloudKitRecordID = recordID
    }
}
