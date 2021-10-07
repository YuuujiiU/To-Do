//
//  AddTaskGroupView.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/22/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit

class AddTaskGroupView: UIView {
    
    @IBOutlet weak var txtListName: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var actionBlockAdd: (() -> Void)? = nil
    var actionBlockCancel: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AddTaskGroupView", owner: self, options: nil)
        mainView.layer.cornerRadius = 4.0
        parentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func diTappedOnAdd(_ sender: Any) {
        actionBlockAdd?()
    }
    
    @IBAction func didTappedOnCancel(_ sender: Any) {
        actionBlockCancel?()
    }
    
    func showTaskListView() {
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
}
