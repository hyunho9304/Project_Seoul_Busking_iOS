//
//  SignUpViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var signUpBackBtn: UIButton!
    @IBOutlet weak var signUpIDTextField: UITextField!
    @IBOutlet weak var signUpPWTextField: UITextField!
    @IBOutlet weak var signUpNicknameTextField: UITextField!
    @IBOutlet weak var signUpCompletionBtn: UIButton!
    @IBOutlet weak var signUpBuskerView: UIView!
    @IBOutlet weak var signUpAudienceView: UIView!
    
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    
    
    var memberType : Int?           //  버스커 or 관람객
    var categoryArr : [String] = [ "노래" , "댄스" , "연주" , "마술" , "캐리커쳐" , "기타" ]
    var selectedIndex : IndexPath?    //  버스커 카테고리 선택
    var selectedCategory : String?  //  버스커 선택한 카테고리

    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setTarget()
        hideKeyboardWhenTappedAround()
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

    @objc func pressedSignUpBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    @objc func pressedSignUpCompletionBtn( _ sender : UIButton ) {
    
        //  회원가입 서버 진행
    }
    
// Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return categoryArr.count
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectCategoryCollectionViewCell", for: indexPath ) as! selectCategoryCollectionViewCell
        
        cell.categoryLabel.text = categoryArr[ indexPath.row ]

        if indexPath == selectedIndex {
            
            cell.categoryLabel.textColor = UIColor.white
            cell.categoryBackImage.isHidden = false
            
            self.selectedCategory = cell.categoryLabel.text
        }
        else {

            cell.categoryLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
            cell.categoryBackImage.isHidden = true
        }
        
        return cell
    }

    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedIndex = indexPath
        collectionView.reloadData()
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 88 * self.view.frame.width/375 , height: 53 * self.view.frame.height/667 )
    }
    
    //  cell 섹션 내부 여백( default 는 0 보다 크다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    //  cell 간 세로 간격 ( vertical 이라서 세로 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 19
    }
    
    //  cell 간 가로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 18
    }

}
