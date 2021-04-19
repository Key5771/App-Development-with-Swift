//
//  ViewController.swift
//  RealmProject
//
//  Created by 김기현 on 2021/04/19.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create
        let task = LocalOnlyQsTask(name: "Do laundry")
        try! localRealm.write {
            localRealm.add(task)
        }
        
        // Get All tasks
        let tasks = localRealm.objects(LocalOnlyQsTask.self)
        print(tasks)
        
        // change observe
        let notificationToken = tasks.observe { changes in
            switch changes{
            case .initial: break
            case .update(_, let deletions, let insertions, let modifications):
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modification: ", modifications)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        // Update
        let taskToUpdate = tasks[0]
        try! localRealm.write {
            taskToUpdate.status = "InProgress"
        }
        
        print(tasks)
        
        let taskToDelete = tasks[0]
        try! localRealm.write {
            localRealm.delete(taskToDelete)
        }
        
        print("tasks: \(tasks)")
        
        notificationToken.invalidate()
    }
}

