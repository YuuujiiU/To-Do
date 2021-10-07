//
//  AddTaskVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/21/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit
import Firebase

class AddTaskVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtTask: UITextField!
    @IBOutlet weak var txtTaskBody: UITextField!
    
    var update:(()-> Void)?
    let db = Firestore.firestore()
    var listId = ""
    var isDetail = false
    var task :Task?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        txtTask.delegate = self
        
        if isDetail{
            title = task?.name
            txtTask.text = task?.name
            txtTaskBody.text = task?.body
            txtTask.isUserInteractionEnabled = false
            txtTaskBody.isUserInteractionEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        }
    }
    
    @IBAction func didTappedOnSave(_ sender: Any) {
        addTask()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTask()
        return true
    }
    
    func addTask(){
        guard let text = txtTask.text, !text.isEmpty else {
            return
        }
        addView()
        update?()
    }
    
    func addView(){
      //  let washingtonRef = db.collection("cities").document("DC")
        let taskInfoDictionary = ["title" : txtTask.text,
            "body" : txtTaskBody.text]
        
        db.collection("tasks").document(listId).setData([ "tasks": FieldValue.arrayUnion([taskInfoDictionary]) ], merge: true)
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
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
