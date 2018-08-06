//
//  SignInViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInIDTextField: UITextField!
    @IBOutlet weak var signInPWTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTarget()
        confirmWrite()
        hideKeyboardWhenTappedAround()
        
    }
    
    func setTarget() {
        
        signInBtn.addTarget(self, action: #selector(self.pressedSignInBtn(_:)), for: UIControlEvents.touchUpInside)
        signUpBtn.addTarget(self, action: #selector(self.pressedSignUpBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func confirmWrite() {
        
        signInBtn.isEnabled = false  //  default setting
        
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
        
        //  로그인
        /*
        if( !(emailTextField.text?.isEmpty)! && !( (passwordTextField.text?.isEmpty)!) ) {
         
            userdefault.set(gsno(emailTextField.text), forKey: "member_email")
         
            Server.reqSignIn(email: emailTextField.text! , password: passwordTextField.text!) { (rescode , flag ) in
                
                if rescode == 201 {
                    
                    let myHomeVCtap = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myHomeVCtap")
                    
                    self.present( myHomeVCtap , animated: true , completion: nil )
                    
                } else if rescode == 401 {
         
                    if flag == 1 {
                        
                        
                        let alert = UIAlertController(title: "로그인 실패", message: "이메일이 없습니다", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
                        
                    }
                    else if flag == 2 {
                        
                        let alert = UIAlertController(title: "로그인 실패", message: "비밀번호 틀렸는데요..?", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
         
         
                    }
                } else {
         
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
        } else {
         
            let alert = UIAlertController(title: "로그인", message: "이메일과 비밀번호를 입력해주세요!!", preferredStyle: .alert )
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
         
            alert.addAction( ok )
         
            present( alert , animated: true , completion: nil )
        }
        */
    }
    
    @objc func pressedSignUpBtn( _ sender : UIButton ) {
        
        guard let selectTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectTypeViewController") as? SelectTypeViewController else { return }
        
        self.present( selectTypeVC , animated: true , completion: nil )
    }
    
    
}


