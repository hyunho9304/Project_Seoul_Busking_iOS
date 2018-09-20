//
//  SelectTypeViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//
/*
 Description : 회원가입시 버스커 , 관람객 선택화면이다.
 */
import UIKit

class SelectTypeViewController: UIViewController {
    
    @IBOutlet weak var selectBackBtn: UIButton!
    @IBOutlet weak var selectBuskerBtn: ToggleBtn!
    @IBOutlet weak var selectAudienceBtn: ToggleBtn!
    @IBOutlet weak var selectNextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTarget()
        setToggleBtn()
        confirmWrite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        set()
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .default
        
        selectNextBtn.isEnabled = false  //  default setting
        selectBuskerBtn.setImage( #imageLiteral(resourceName: "2_3_1") , for: .normal)
        selectAudienceBtn.setImage( #imageLiteral(resourceName: "2_4_1") , for: .normal)
    }

    func setTarget() {
        
        selectBackBtn.addTarget(self, action: #selector(self.pressedSelectBackBtn(_:)), for: UIControlEvents.touchUpInside)
        selectNextBtn.addTarget(self, action: #selector(self.pressedSelectNextBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func setToggleBtn() {
        
        selectBuskerBtn.otherBtn = self.selectAudienceBtn
        selectAudienceBtn.otherBtn = self.selectBuskerBtn
    }
    
    func confirmWrite() {
        
        selectBuskerBtn.addTarget(self, action: #selector(isValid), for: .touchUpInside)       //  Button
        selectAudienceBtn.addTarget(self, action: #selector(isValid), for: .touchUpInside)
    }
    
    @objc func pressedSelectBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    @objc func pressedSelectNextBtn( _ sender : UIButton ) {
        
        guard let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        
        if selectBuskerBtn.checked == true {
            signUpVC.memberType = "1"
        } else {
            signUpVC.memberType = "0"
        }
        
        self.present( signUpVC , animated: true , completion: nil )
    }
    
    @objc func isValid() {
        
        //  모두 입력 완료
        if( (selectBuskerBtn.checked)! || (selectAudienceBtn.checked)! ) {
            
            selectNextBtn.isEnabled = true
            selectNextBtn.setImage( #imageLiteral(resourceName: "2_5_2") , for: .normal)
            
        } else {
            
            selectNextBtn.isEnabled = false
            selectNextBtn.setImage( #imageLiteral(resourceName: "2_5_1") , for: .normal )
        }
    }


}
