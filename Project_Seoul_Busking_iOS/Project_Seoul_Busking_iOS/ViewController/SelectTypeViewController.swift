//
//  SelectTypeViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SelectTypeViewController: UIViewController {
    
    @IBOutlet weak var signUpBackBtn: UIButton!
    @IBOutlet weak var selectBuskerBtn: ToggleBtn!
    @IBOutlet weak var selectAudienceBtn: ToggleBtn!
    @IBOutlet weak var signUpNextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTarget()
        settingToggleBtn()
        confirmWrite()
    }

    func settingTarget() {
        
        signUpBackBtn.addTarget(self, action: #selector(self.pressedSignUpBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        signUpNextBtn.addTarget(self, action: #selector(self.pressedSignUpNextBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func settingToggleBtn() {
        
        selectBuskerBtn.otherBtn = self.selectAudienceBtn
        selectAudienceBtn.otherBtn = self.selectBuskerBtn
    }
    
    func confirmWrite() {
        
        signUpNextBtn.isEnabled = false  //  default setting
        
        selectBuskerBtn.addTarget(self, action: #selector(isValid), for: .touchUpInside)       //  Button
        selectAudienceBtn.addTarget(self, action: #selector(isValid), for: .touchUpInside)
    }
    
    @objc func pressedSignUpBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    @objc func pressedSignUpNextBtn( _ sender : UIButton ) {
        
        guard let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        
        if selectBuskerBtn.checked == true {
            signUpVC.memberType = 1
        } else {
            signUpVC.memberType = 0
        }
        
        self.present( signUpVC , animated: true , completion: nil )
    }
    
    @objc func isValid() {
        
        //  모두 입력 완료
        if( (selectBuskerBtn.checked)! || (selectAudienceBtn.checked)! ) {
            
            signUpNextBtn.isEnabled = true
            signUpNextBtn.setImage( #imageLiteral(resourceName: "next_1.png") , for: .normal)
            
        } else {
            
            signUpNextBtn.isEnabled = false
            signUpNextBtn.setImage( #imageLiteral(resourceName: "next.png") , for: .normal )
        }
    }


}
