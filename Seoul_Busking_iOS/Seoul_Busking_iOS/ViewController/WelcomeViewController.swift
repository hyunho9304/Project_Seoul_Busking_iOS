//
//  WelcomeViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 21..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    //  유저 info
    var memberInfo : Member?
    
    @IBOutlet weak var commitBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTarget()
    }
    
    func setTarget() {
        
        commitBtn.addTarget(self, action: #selector(self.pressedCommitBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //  commit btn 액션
    @objc func pressedCommitBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        homeVC.memberInfo = memberInfo
        
        self.present( homeVC , animated: true , completion: nil )
    }
}
