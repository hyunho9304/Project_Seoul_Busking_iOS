//
//  SignInViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//
/*
 Description : 로그인 화면으로 시작하면 뜨는 화면이다.
*/

import UIKit

class SignInViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var signInIDTextField: UITextField!
    @IBOutlet weak var signInPWTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!

    
    @IBAction func goFirst(segue: UIStoryboardSegue){}  //  로그인화면으로
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setTarget()
        setDelegate()
        confirmWrite()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        signInBtn.isEnabled = false
        signInIDTextField.text = ""
        signInPWTextField.text = ""
        
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func set() {
        
        signInIDTextField.returnKeyType = UIReturnKeyType.continue
        signInPWTextField.returnKeyType = UIReturnKeyType.done
    }
    func setTarget() {
        
        signInBtn.addTarget(self, action: #selector(self.pressedSignInBtn(_:)), for: UIControlEvents.touchUpInside)
        signUpBtn.addTarget(self, action: #selector(self.pressedSignUpBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setDelegate() {
        
        signInIDTextField.delegate = self
        signInPWTextField.delegate = self
    }
    
    func confirmWrite() {
        
        signInIDTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)   //  textField
        signInPWTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)   //  textField
    }
    
    @objc func isValid() {
        
        if( !(signInIDTextField.text?.isEmpty)! && !(signInPWTextField.text?.isEmpty)! ) {
            
            signInBtn.isEnabled = true
            
        } else {
            
            signInBtn.isEnabled = false
        }
    }
    
    @objc func pressedSignInBtn( _ sender : UIButton ) {
        
        Server.reqSignIn(member_ID: signInIDTextField.text! , member_PW: signInPWTextField.text!) { ( memberData , rescode ) in
            
            if rescode == 201 {
                
                guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                
                homeVC.memberInfo = memberData
                
                self.present( homeVC , animated: true , completion: nil )
                
                
            } else if rescode == 401 {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "아이디 또는 비밀번호를 확인해주세요."
                
                self.addChildViewController( defaultPopUpVC )
                defaultPopUpVC.view.frame = self.view.frame
                self.view.addSubview( defaultPopUpVC.view )
                defaultPopUpVC.didMove(toParentViewController: self )
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
                
            }
        }
    }
    
    @objc func pressedSignUpBtn( _ sender : UIButton ) {
        
        guard let selectTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectTypeViewController") as? SelectTypeViewController else { return }
        
        self.present( selectTypeVC , animated: true , completion: nil )
    }
    
    
//  Mark -> UITextField Delegate
    //  키보드 확인 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}


