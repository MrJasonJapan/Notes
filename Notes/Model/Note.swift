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
    
    init(title: String){
        self.title = title
    }
    
    //init needs a ? here because we are not 100% if we can make a note with a record.
    init?(record: CKRecord){
        guard let title = record.value(forKey: "title") as? String else { return nil }
        self.title = title;
    }
    
    func noteRecord() -> CKRecord {
        let record = CKRecord(recordType: Note.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
