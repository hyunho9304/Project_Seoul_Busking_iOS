//
//  DefaultPopUpViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 7..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class DefaultPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpContent: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    var content : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 4
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowOpacity = 1
        popUpView.layer.shadowOffset = CGSize.zero
        popUpView.layer.shadowRadius = 10
        
        okBtn.layer.cornerRadius = 4
        
        set()
        setTarget()
        showAnimate()
    }
    
    func set() {
        
        popUpContent.text = content
        self.view.backgroundColor = UIColor.black.withAlphaComponent( 0.8 )
    }
    
    func setTarget() {
        
        okBtn.addTarget(self, action: #selector(self.pressedOkBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedOkBtn( _ sender : UIButton ) {

        removeAnimate()
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
        }
    }

    func removeAnimate() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
            self.view.alpha = 0.0
        }) { ( finished ) in
            
            if( finished ) {
                self.view.removeFromSuperview()
            }
        }
    }
}















