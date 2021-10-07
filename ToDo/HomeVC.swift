//
//  HomeVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/22/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit
import Firebase
 
class HomeVC: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var tasks:[Task] = []
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTable()
    }
    
    func setupUI(){
        lblEmail.text = LocalUser.current()?.email
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    @IBAction func didTappedOnAdd(_ sender: Any) {
        showView()
    }
    
    @IBAction func didTappedOnSeeReminders(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ReminderVC") as! ReminderVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func showView(){
        let taskListView  = AddTaskGroupView()
        taskListView.showTaskListView()
        
        taskListView.actionBlockCancel = {
            taskListView.parentView.removeFromSuperview()
        }
        
        taskListView.actionBlockAdd = {
            self.addView(text: taskListView.txtListName.text!,instance:taskListView)
        }
        
        
    }
    
    @IBAction func didTappedOnSignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            guard let user = LocalUser.current() else { return }
            RealmService.shared.delete(user)
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let topController = storyboard.instantiateViewController(withIdentifier: "AuthNC")
            appDelegate.setAsRoot(_controller: topController)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    func updateTable(){
        tasks.removeAll()
        db.collection("tasks").getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let resData = document.data() as NSDictionary
                        self.tasks.append(Task(id: document.documentID, name: resData.value(forKey:"name") as? String, body: resData.value(forKey:"body") as? String))
                        print(resData.value(forKey:"name") as? String)
                    }
                    self.tableView.reloadData()
                }
        }
        //        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }
        //
        //        for i in 0..<count{
        //            if let task = UserDefaults().value(forKey: "id_\(i+1)") as? String{
        //                tasks.append(task)
        //            }
        //        }
    }
    
    func addView(text:String,instance:AddTaskGroupView){
        var ref: DocumentReference? = nil
        ref = db.collection("tasks").addDocument(data: [
            "name": text,
            "tasks":  []
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                instance.parentView.removeFromSuperview()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "TaskListVC") as! TaskListVC
                vc.title = text
                vc.listId = ref!.documentID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func deleteTaskList(id:String,rowId:Int){
        db.collection("tasks").document(id).delete() { err in
            if let err = err {
                AlertProvider(vc: self).showAlert(title: "Error", message: "Error removing document: \(err)", action: AlertAction(title: "Dismiss"))
            } else {
                self.tasks.remove(at: rowId)
                self.tableView.reloadData()
                AlertProvider(vc: self).showAlert(title: "Success", message: "Task List successfully removed!", action: AlertAction(title: "Dismiss"))
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskGroupTVC",for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TaskListVC") as! TaskListVC
        vc.title = tasks[indexPath.row].name
        vc.listId = tasks[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteTaskList(id: tasks[indexPath.row].id!,rowId:indexPath.row)
        }
    }
}
