//
//  ViewController.swift
//  Phone_Login
//
//  Created by MAC on 27/11/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var otp: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        otp.isHidden = true
    }
    
    var verification_id : String? = nil
    
    @IBAction func submit(_ sender: UIButton) {
        if (otp.isHidden) {
            if !phoneNumber.text!.isEmpty {
                Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber.text!, uiDelegate: nil, completion: { (verificationId, error) in
                    if(error != nil){
                        return
                    }
                    else {
                        
                        self.verification_id = verificationId
                        self.otp.isHidden = false
                    }
                })
                
            }else{
                    print("Please Enter Phonenumber")
                }
                
        }else{
                if verification_id != nil {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification_id!, verificationCode: otp.text!)
                    Auth.auth().signIn(with: credential) { (authData, error) in
                        if (error != nil ){
                            let alertControllers = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertControllers.addAction(defaultAction)
                            self.present(alertControllers, animated: true, completion: nil)
                        }else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            //self.selectDeselect(tableview : tableView , indexpath : indexPath)
                            
                            let detail:secondViewController = storyboard.instantiateViewController(withIdentifier: "secondViewController") as! secondViewController
                            
                            self.navigationController?.pushViewController(detail, animated: true )
                            
                            
                            
                            print("Authentication Success With" + (authData?.user.phoneNumber ?? "No Phone Number"))
                        }
                        
                    }
                    
                }else {
                    print("Error in Getting verification code")
                }
            
            }
        }
    }
    





