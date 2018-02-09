//
//  AlertService.swift
//  Notes
//
//  Created by SpaGettys on 2018/02/08.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit

class AlertService {
    
    // make sure we can't make an AlertService object anywhere else in the code.
    private init() {}
    
    static func composeNote(in vc: UIViewController, completion: @escaping (Note) -> Void) {
        let alert = UIAlertController(title: "New note", message: "What's on your mind?", preferredStyle: .alert)
        
        alert.addTextField { (titleTF) in
            titleTF.placeholder = "title"
        }
        
        let post = UIAlertAction(title: "Post", style: .default) {
            (_) in
            
            guard let title = alert.textFields?.first?.text else { return }
            let note = Note(title: title)
            // call our completion and pass in the note we just created.
            completion(note)
        }
        
        // Notice how we are "@escaping" the completion above.
        // this let our "note" above (assigned to post) outlive its original scope, which is only in the closeure of UIAlertAction.
        // So, how I'm understanding it now, is that "@escaping" just tells the completion() function that anything within it's scope
        // is now viewable directly outside of it's scope, in this case in form of our 'post' constanst.
        alert.addAction(post)
        vc.present(alert, animated: true)
        
        
    }
    
}
