//
//  ViewController.swift
//  Notes
//
//  Created by SpaGettys on 2018/02/08.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    var notes = [Note]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //CKService.shared.subscribe()
        CKService.shared.subscribeWithUI()
        
        UNService.shared.authroize()
        
        getNotes()
        
        // start watching for when a record gets sent from our 'internal' notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleFetch(_:)),
                                               name: NSNotification.Name("internalNotification.fetchedRecord"),
                                               object: nil)
    }
    
    func getNotes() {
        NotesService.getNotes { (notes) in
            self.notes = notes
            // bind the datasource to our tableView
            self.tableView.reloadData()
        }
    }

    @IBAction func onComposeTapped() {
        AlertService.composeNote(in: self) { (note) in
            // save our note to iCloud
            CKService.shared.save(record: note.noteRecord())
            // insert our note to local memory (notes) and instruct table view to set it's current index to row 0
            self.insert(note: note)
        }
    }
    
    func insert(note: Note) {
        // insert note into our Model Object.
        notes.insert(note, at: 0)
        
        // set our index at the very top of the table
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // our TableView's delegate functions will handle the rest.
    }
    
    @objc
    func handleFetch(_ sender: Notification) {
        guard
            let record = sender.object as? CKRecord,
            let note = Note(record: record)
            else { return }
        
        // persist the note to our model (notes) and insert the note into the top of our tableView.
        insert(note: note)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
}

