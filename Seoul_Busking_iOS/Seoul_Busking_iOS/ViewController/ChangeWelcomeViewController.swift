//
//  ChangeWelcomeViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 22..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ChangeWelcomeViewController: UIViewController {

    //  넘어온 정보
    var memberInfo : Member?
    
    @IBOutlet weak var changeWelecomCommitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTarget()
    }
    
    func setTarget() {
        
        //  완료 버튼
        changeWelecomCommitBtn.addTarget(self, action: #selector(self.pressedChangeWelecomCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    //  완료 버튼 액션
    @objc func pressedChangeWelecomCommitBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        homeVC.memberInfo = memberInfo
        
        self.present( homeVC , animated: true , completion: nil )
    }


}
