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
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabase.save(record) { (record, error) in
            print(error ?? "error: no save to CK error")
            print(record ?? "error: no CK record error")
        }
    }
    
    // NSPredicate(value: true) means "just give us everything"
    func query(recordType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
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
        
        privateDatabase.save(subscribtion) { (sub, error) in
            print(error ?? "No CKQueryScription error")
            print(sub ?? "No subscription error")
        }
        
    }
    
    func subscribeWithUI() {
        let subscribtion = CKQuerySubscription(recordType: Note.recordType,
                                               predicate: NSPredicate(value: true),
                                               options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        // These only work from iOS 11.0 and later.
        notificationInfo.title = "This is cool"
        notificationInfo.subtitle = "A Whole New iCloud"
        notificationInfo.alertBody = "I bet ya didn't you know about the power of the cloud."
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subscribtion.notificationInfo = notificationInfo
        
        privateDatabase.save(subscribtion) { (sub, error) in
            print(error ?? "No CKQueryScription error")
            print(sub ?? "No subscription error")
        }
    }
    
    // use to fetch the actual record with regards to the recordId that iCloud pushed us via didReceiveRemoteNotification
    func fetchRecord(with recordId: CKRecordID) {
        
        privateDatabase.fetch(withRecordID: recordId) { (record, error) in
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
