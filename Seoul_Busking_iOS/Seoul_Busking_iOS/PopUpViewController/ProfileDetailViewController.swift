//
//  ProfileDetailViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 18..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController , UIScrollViewDelegate {

    @IBOutlet weak var backUIView: UIView!
    @IBOutlet weak var profileDetailBackBtn: UIButton!
    @IBOutlet weak var profileDetailScrollView: UIScrollView!
    @IBOutlet weak var profileDetailImageView: UIImageView!
    
    var detailImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setTarget()
        setDelegate()
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        backUIView.backgroundColor = UIColor.black.withAlphaComponent( 1 )
        profileDetailImageView.image = detailImage
        
        profileDetailImageView.isUserInteractionEnabled = true
        
        profileDetailScrollView.minimumZoomScale = 1.0
        profileDetailScrollView.maximumZoomScale = 6.0
    }
    
    func setTarget() {
        
        //  백 버튼
        profileDetailBackBtn.addTarget(self, action: #selector(self.pressedProfileDetailBackBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //  뒤로가기 버튼 액션
    @objc func pressedProfileDetailBackBtn( _ sender : UIButton ) {
        
        self.view.removeFromSuperview()
        
    }
    
    func setDelegate() {
        
        profileDetailScrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return profileDetailImageView
    }

}
