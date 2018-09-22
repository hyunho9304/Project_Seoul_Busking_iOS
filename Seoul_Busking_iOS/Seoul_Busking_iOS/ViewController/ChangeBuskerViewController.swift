//
//  ChangeBuskerViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 22..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ChangeBuskerViewController: UIViewController {

    //  넘어온 정보
    var memberInfo : Member?
    
    //  네비게이션 바
    @IBOutlet weak var changeBuskerBackBtn: UIButton!
    
    //  내용
    @IBOutlet weak var changeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTarget()
    }
    
    func setTarget() {
        
        //  백 버튼
        changeBuskerBackBtn.addTarget(self, action: #selector(self.pressedChangeBuskerBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  장르 선택하기 버튼
        changeBtn.addTarget(self, action: #selector(self.pressedChangeBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //  백 버튼 액션
    @objc func pressedChangeBuskerBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    //  장르 선택하기 버튼 액션
    @objc func pressedChangeBtn( _ sender : UIButton ) {
        
        guard let selectCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectCategoryViewController") as? SelectCategoryViewController else { return }
        
        selectCategoryVC.memberInfo = self.memberInfo
        
        self.present( selectCategoryVC , animated: false , completion: nil )
    }

}
