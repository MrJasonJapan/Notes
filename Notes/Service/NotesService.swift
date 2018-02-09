//
//  NotesService.swift
//  Notes
//
//  Created by SpaGettys on 2018/02/08.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation

class NotesService {
    
    private init() {}
    
    static func getNotes(completion: @escaping ([Note]) -> Void) {
        CKService.shared.query(recordType: Note.recordType) { (records) in
            
            var notes = [Note]()
            for record in records {
                guard let note = Note(record: record) else { continue } // contine -> means skip the to the next loop item.
                notes.append(note)
            }
            completion(notes)
        }
    }
}
