//
//  TaskSelectionView.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/25/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit

class TaskSelectionView: UIView {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var actionBlockDetails: (() -> Void)? = nil
    var actionBlockReminder: (() -> Void)? = nil
    var actionBlockCancel: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("TaskSelectionView", owner: self, options: nil)
        mainView.layer.cornerRadius = 4.0
        parentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func diTappedOnViewDetails(_ sender: Any) {
        actionBlockDetails?()
    }
    
    @IBAction func diTappedOnAddReminder(_ sender: Any) {
        actionBlockReminder?()
    }
    
    @IBAction func didTappedOnCancel(_ sender: Any) {
        actionBlockCancel?()
    }
    
    func showTaskSelectionView() {
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
}
