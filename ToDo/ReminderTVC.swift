//
//  ReminderTVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/24/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit

class ReminderTVC: UITableViewCell {
    
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtBody: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(with:Reminder){
        txtName.text = with.title
        txtBody.text = with.body
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let dateString = dateFormatter.string(from: with.date)
        txtDate.text = dateString
    }
    
}
