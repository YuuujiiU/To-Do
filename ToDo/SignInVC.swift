//
//  SignInVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/21/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInVC: UIViewController {
    
    //MARK: Variables
    let bag = DisposeBag()
    let vm = SignInVM()
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
      
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        
        btnLogin.rx.tap
            .subscribe() {[weak self] event in
                self?.loginRequest()
        }
        .disposed(by: bag)
        
        btnSignUp.rx.tap
                   .subscribe() {[weak self] event in
                       self?.didTappedOnSignUp()
               }
               .disposed(by: bag)
    }
    
    func didTappedOnSignUp(){
        let vc = storyboard?.instantiateViewController(identifier: "SignUpVC") as! SignUpVC
         navigationController?.pushViewController(vc, animated: true)
    }

    func loginRequest() {
        view.endEditing(true)
        //self.startLoading()
        //MARK: Manage user registration service with ViewModel
        vm.proceedWithLogin(completion: { status, code, message, data in
            //   self.stopLoading()
            switch status {
            case true:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let topController = storyboard.instantiateViewController(withIdentifier: "HomeNC")
                self.appDelegate.setAsRoot(_controller: topController)
                // Hadle function after register
            //      ASP.shared.manageUserDirection()
            default:
                AlertProvider(vc: self).showAlert(title: "Error", message: message, action: AlertAction(title: "Dismiss"))
            }
        })
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
