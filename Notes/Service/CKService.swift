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
    
    // NSPredicate(value: true) means "just give us everything"
    func query(recordType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        privateDatabae.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "error: CKQuery failed")
            guard let records = records else { return }
            // do a dispach bacause we are working witn an Asynchronous call
            DispatchQueue.main.async {
                completion(records)
            }
            
        }
    }
}
