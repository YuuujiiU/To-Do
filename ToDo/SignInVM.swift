//
//  SignInVM.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/21/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

public enum ValidateError: Error {
    case invalidData(String)
}

class SignInVM:NSObject{
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    func proceedWithLogin(completion: @escaping CompletionHandlerWithData) {
        validateLoginUser(completion: { status, message in
            if status{
                Auth.auth().signIn(withEmail: email.value, password: password.value) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    // ...
                    if error != nil{
                        completion(false, 0, error!.localizedDescription, nil)
                    }
                    else{
                        let _user = User(_id: authResult?.user.uid, email: self?.email.value)
                        LocalUser.saveLoginData(user: _user)
                        completion(true, 200, "Success", _user)
                    }
                    
                }
            }
            else{
                 completion(false, 0, message, nil)
            }


        })
    }
    
    //MARK: Validate Login User
    public func validateLoginUser(completion: (_ status: Bool, _ message: String) -> ()) {
        do {
            if try validateForm() {
                completion(true, "Success")
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, "Missing Data")
        }
    }
    
    func validateForm() throws -> Bool {
        guard (email.value is String), let value = email.value as? String else {
            throw ValidateError.invalidData("Invalid Email")
        }
        guard !(value.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Email Empty")
        }
        guard isValidEmailAddress(email: value) else {
            throw ValidateError.invalidData("Invalid Email")
        }
        guard !(password.value.isEmpty) else {
            throw ValidateError.invalidData("Passowrd is Empty")
        }
        return true
    }
    
    //MARK: This function is used to check the email address validity
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
}

public extension String {
    
    func trimLeadingTralingNewlineWhiteSpaces() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

