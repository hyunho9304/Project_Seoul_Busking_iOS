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
        
        set()
        setTarget()
        showAnimate()
    }
    
    func set() {
        
        popUpContent.text = content
        self.view.backgroundColor = UIColor.black.withAlphaComponent( 0.6 )
        
        popUpView.layer.cornerRadius = 5    //  둥근정도
        popUpView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        popUpView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        popUpView.layer.shadowOpacity = 0.15                            //  그림자 투명도
        popUpView.layer.shadowOffset = CGSize(width: 0 , height: 3 )    //  그림자 x y
        popUpView.layer.shadowRadius = 5                                //  그림자 둥근정도
                                                                        //  그림자의 블러는 5 정도 이다
        
        //        okBtn.clipsToBounds = true    안에 있는 글 잘린다
        okBtn.layer.cornerRadius = 5
        okBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner ]
    }
    
    
    func setTarget() {
        
        okBtn.addTarget(self, action: #selector(self.pressedOkBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedOkBtn( _ sender : UIButton ) {

        self.view.removeFromSuperview()
        //removeAnimate()
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.18) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
        }
    }

//    func removeAnimate() {
//
//        UIView.animate(withDuration: 0.18, animations: {
//            self.view.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
//            self.view.alpha = 0.0
//        }) { ( finished ) in
//
//            if( finished ) {
//                self.view.removeFromSuperview()
//            }
//        }
//    }
}















