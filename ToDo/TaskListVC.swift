//
//  TaskListVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/21/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit
import Firebase

public struct Task: Codable {
    let id :String?
    let name: String?
    let body:String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case body
    }
}

class TaskListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var tasks = [Task]()
    var listId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
     //   updateTable()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
   //     title = "Tasks"
        updateTable()
    }
    
    func updateTable(){
        tasks.removeAll()
        db.collection("tasks").document(listId).getDocument 
            { document, err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        
                        let resData = document.data()! as NSDictionary
                        let arrayTasks = resData.value(forKey:"tasks") as! [NSDictionary]
                        
                        for task in arrayTasks {
                        let newTask = Task(id: nil, name: task.value(forKey:"title") as? String, body: task.value(forKey:"body") as? String)
                            self.tasks.append(newTask)
                        }
                        print("Document data: \(dataDescription)")

                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    func deleteTask(selectedTitle:Task,row:Int){
        let taskInfoDictionary = ["title" : selectedTitle.name,
                                  "body" : selectedTitle.body]
      //  let washingtonRef = db.collection("cities").document("DC")
        db.collection("tasks").document(listId).setData([ "tasks": FieldValue.arrayRemove([taskInfoDictionary])], merge: true)
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.tasks.remove(at: row)
                self.tableView.reloadData()
                print("Document successfully updated")
            }
        }
    }

    @IBAction func didTappedOnAdd(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddTaskVC") as! AddTaskVC
        vc.update = {
            DispatchQueue.main.async {
                self.updateTable()
            }
        }
        vc.listId = listId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TaskListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTVC",for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteTask(selectedTitle: tasks[indexPath.row], row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskListView  = TaskSelectionView()
        taskListView.showTaskSelectionView()
        
        taskListView.actionBlockCancel = {
            taskListView.parentView.removeFromSuperview()
        }
        
        taskListView.actionBlockDetails = {
            taskListView.parentView.removeFromSuperview()
            let vc = self.storyboard?.instantiateViewController(identifier: "AddTaskVC") as! AddTaskVC
            vc.isDetail = true
            vc.task = self.tasks[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        taskListView.actionBlockReminder = {
            taskListView.parentView.removeFromSuperview()
            let vc = self.storyboard?.instantiateViewController(identifier: "AddReminderVC") as! AddReminderVC
            vc.id = "\(indexPath.row)\(self.listId)"
            vc.taskName = self.tasks[indexPath.row].name!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

