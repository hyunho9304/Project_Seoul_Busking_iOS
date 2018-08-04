//
//  SignUpViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var signUpBackBtn: UIButton!
    @IBOutlet weak var signUpIDTextField: UITextField!
    @IBOutlet weak var signUpPWTextField: UITextField!
    @IBOutlet weak var signUpNicknameTextField: UITextField!
    @IBOutlet weak var signUpCompletionBtn: UIButton!
    @IBOutlet weak var signUpBuskerView: UIView!
    @IBOutlet weak var signUpAudienceView: UIView!
    
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    
    var memberType : Int?           //  버스커 or 관람객
    var selectedIndex:IndexPath?    //  버스커 카테고리 선택
    var selectedCategory : String?  //  버스커 선택한 카테고리

    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setTarget()
        categoryInit()
    }
    
    func set() {

        if memberType == 1 {
            signUpBuskerView.isHidden = false
        } else {
            signUpAudienceView.isHidden = false
        }
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self
        
    }
    
    func setTarget() {
        
        signUpBackBtn.addTarget(self, action: #selector(self.pressedSignUpBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        signUpCompletionBtn.addTarget(self, action: #selector(self.pressedSignUpCompletionBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func categoryInit() {
        
        //  카테고리 가져오기 서버 진행
    }

    @objc func pressedSignUpBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    @objc func pressedSignUpCompletionBtn( _ sender : UIButton ) {
    
        //  회원가입 서버 진행
    }
    
// Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        collectionView.reloadData()
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

}
