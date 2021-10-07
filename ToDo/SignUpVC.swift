//
//  SignUpVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/21/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    
    //MARK: Variables
    let bag = DisposeBag()
    let vm = SignUpVM()
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
   // @IBOutlet weak var btnSignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    func addObservers(){
        txtEmail.rx.text
            .orEmpty
            .bind(to: vm.email)
            .disposed(by: bag)
        
        txtPassword.rx.text
            .orEmpty
            .bind(to: vm.password)
            .disposed(by: bag)
        
        txtConfirmPassword.rx.text
                 .orEmpty
                 .bind(to: vm.confirmPassword)
                 .disposed(by: bag)
             
        btnSignUp.rx.tap
            .subscribe() {[weak self] event in
                self?.signupRequest()
        }
        .disposed(by: bag)
    }
    
    func signupRequest() {
        view.endEditing(true)
        //self.startLoading()
        //MARK: Manage user registration service with ViewModel
        vm.proceedWithRegister(completion: { status, code, message, data in
            //   self.stopLoading()
            switch status {
            case true:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let topController = storyboard.instantiateViewController(withIdentifier: "HomeNC")
                self.appDelegate.setAsRoot(_controller: topController)                // Hadle function after register
            //      ASP.shared.manageUserDirection()
            default:
                AlertProvider(vc: self).showAlert(title: "Error", message: message, action: AlertAction(title: "Dismiss"))
            }
        })
    }
}
