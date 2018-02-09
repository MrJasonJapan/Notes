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
            print(error ?? "No CKQuery error")
            guard let records = records else { return }
            // do a dispach bacause we are working witn an Asynchronous call
            DispatchQueue.main.async {
                completion(records)
            }
            
        }
    }
    
    // Set up our subscription
    func subscribe() {
        let subscribtion = CKQuerySubscription(recordType: Note.recordType,
                                               predicate: NSPredicate(value: true),
                                               options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subscribtion.notificationInfo = notificationInfo
        
        privateDatabae.save(subscribtion) { (sub, error) in
            print(error ?? "No CKQueryScription error")
            print(sub ?? "No subscription error")
        }
        
    }
    
    // use to fetch the actual record with regards to the recordId that iCloud pushed us via didReceiveRemoteNotification
    func fetchRecord(with recordId: CKRecordID) {
        
        privateDatabae.fetch(withRecordID: recordId) { (record, error) in
            print(error ?? "No CK fetch error")
            guard let record = record else { return }
            
            // make sure that we return to the main queue (making it run on the the main thread, maybe, I think?)
            // this is because all of the didReceiveRemoteNotification business in happening in the background (I think...)
            DispatchQueue.main.async {
                
                // send an 'internal' notification
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchedRecord"), object: record)
            }
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable: Any]) {
        
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        switch notification.notificationType {
        case.query:
            guard
                let queryNotification = notification as? CKQueryNotification,
                let recordId = queryNotification.recordID
                else { return }
            fetchRecord(with: recordId)
        default: return
        }
    }
}
