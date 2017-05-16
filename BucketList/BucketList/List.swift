//
//  List.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/10/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import Foundation
import CloudKit

class List: CloudKitSyncable {
    
    let listName: String
    var items: [Item] = []
    var cloudKitRecordID: CKRecordID?
    
    init(listName: String, items: [Item] = []) {
        self.listName = listName
        self.items = items
    }
    
    var cloudKitRecord: CKRecord? {
        let record = CKRecord(recordType: Keys.listRecordType)
        record[Keys.itemsRecordType] = items as CKRecordValue?
        return record
    }
    
    var recordType: String {
        return Keys.listRecordType
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let listName = cloudKitRecord[Keys.listNameKey] as? String else { return nil }
        self.listName = listName
    }
}

extension CKRecord {
    convenience init( _ list: List) {
        let recordID = list.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "List", recordID: recordID)
        self[Keys.listNameKey] = list.listName as CKRecordValue
        list.cloudKitRecordID = recordID
    }
}
