//
//  CKService.swift
//  Notes
//
//  Created by SpaGettys on 2018/02/08.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation
import CloudKit

class CKService {
    
    private init() {}
    // set our singleton
    static let shared = CKService()
    
    let privateDatabae = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabae.save(record) { (record, error) in
            print(error ?? "error: can't save to CloudKit")
            print(record ?? "error: no CloudKit Record saved")
        }
    }
}
