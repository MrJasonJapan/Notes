//
//  Note.swift
//  Notes
//
//  Created by SpaGettys on 2018/02/08.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation
import CloudKit

struct Note {
    
    static let recordType = "Note"
    
    let title: String
    
    func noteRecord() -> CKRecord {
        let record = CKRecord(recordType: Note.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
