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
    @IBOutlet weak var signUpOverlapIDCheckBtn: UIButton!
    @IBOutlet weak var signUpOverlapIDInfoLabel: UILabel!
    @IBOutlet weak var signUpPWTextField: UITextField!
    @IBOutlet weak var signUpNicknameTextField: UITextField!
    @IBOutlet weak var signUpOverlapNicknameCheckBtn: UIButton!
    @IBOutlet weak var signUpOverlapNicknameInfoLabel: UILabel!
    @IBOutlet weak var signUpCompletionBtn: UIButton!
    @IBOutlet weak var signUpBuskerView: UIView!
    @IBOutlet weak var signUpAudienceView: UIView!
    
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    
    let userdefault = UserDefaults.standard     //  기본회원정보
    var memberType : String?                    //  버스커 or 관람객
    var categoryArr : [String] = [ "노래" , "댄스" , "연주" , "마술" , "캐리커쳐" , "기타" ]
    var selectedIndex : IndexPath?              //  버스커 카테고리 선택
    var selectedCategory : String?           //  버스커 선택한 카테고리
    var checkOverlapID : Bool? = false                 //  아이디 중복 bool 값
    var checkOverlapNickname : Bool? = false           //  닉네임 중복 bool 값

    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setTarget()
        confirmWrite()
        hideKeyboardWhenTappedAround()
    }
    
    func set() {

        if memberType == "1" {
            signUpBuskerView.isHidden = false
        } else {
            signUpAudienceView.isHidden = false
        }
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self
        
        signUpOverlapIDInfoLabel.isHidden = true
        signUpOverlapNicknameInfoLabel.isHidden = true
        
        
        
    }
    
    func setTarget() {
        
        signUpBackBtn.addTarget(self, action: #selector(self.pressedSignUpBackBtn(_:)), for: UIControlEvents.touchUpInside)
        signUpCompletionBtn.addTarget(self, action: #selector(self.pressedSignUpCompletionBtn(_:)), for: UIControlEvents.touchUpInside)
        
        signUpOverlapIDCheckBtn.addTarget(self, action: #selector(self.pressedSignUpOverlapIDCheckBtn(_:)), for: UIControlEvents.touchUpInside)
        signUpOverlapNicknameCheckBtn.addTarget(self, action: #selector(self.pressedSignUpOverlapNicknameCheckBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func confirmWrite() {
        
        signUpCompletionBtn.isEnabled = false  //  default setting
        
        signUpIDTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)   //  textField
        signUpPWTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)   //  textField
        signUpNicknameTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)   //  textField
        
    }
    
    @objc func isValid() {
        
        if( !(signUpIDTextField.text?.isEmpty)! && !(signUpPWTextField.text?.isEmpty)! && !(signUpNicknameTextField.text?.isEmpty)! ) {
            
            if memberType == "1" {
                
                if selectedCategory != nil {   //  버스커 성공
                    
                    signUpCompletionBtn.isEnabled = true
                    signUpCompletionBtn.setImage( #imageLiteral(resourceName: "3_5_2") , for: .normal)
                    
                }
                
            } else {
                
                signUpCompletionBtn.isEnabled = true
                signUpCompletionBtn.setImage( #imageLiteral(resourceName: "3_5_2") , for: .normal)
                
            }
            
        } else {
            
            signUpCompletionBtn.isEnabled = false
            signUpCompletionBtn.setImage( #imageLiteral(resourceName: "3_5_1") , for: .normal)
        }
    }

    @objc func pressedSignUpBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    @objc func pressedSignUpCompletionBtn( _ sender : UIButton ) {
    
        if ( !(checkOverlapID)! ) {
            print( "아이디중복확인" )
        } else if( !(checkOverlapNickname)! ) {
            print( "닉네임중복확인" )
        } else {
            print( "진행")
        }
    }
    
    @objc func pressedSignUpOverlapIDCheckBtn( _ sender : UIButton ) {
        
        if !(signUpIDTextField.text?.isEmpty)! {
            
            Server.reqOverlapIDCheck(member_ID: signUpIDTextField.text!) { ( rescode ) in
                
                if rescode == 201 {
                    
                    self.signUpOverlapIDCheckBtn.setImage( #imageLiteral(resourceName: "3_2_2") , for: .normal )
                    self.checkOverlapID = true
                    self.signUpOverlapIDInfoLabel.isHidden = true
                    
                    
                } else if rescode == 401 {
                    
                    self.signUpOverlapIDCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
                    self.checkOverlapID = false
                    self.signUpOverlapIDInfoLabel.isHidden = false
                
                } else {
                    
                    self.signUpOverlapIDCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
                    self.checkOverlapID = false
                    self.signUpOverlapIDInfoLabel.isHidden = true
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                    
                }
            }
        } else {
            
            self.signUpOverlapIDCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
            self.checkOverlapID = false
            self.signUpOverlapIDInfoLabel.isHidden = true
            
            let alert = UIAlertController(title: "중복확인", message: "아이디를 입력해주세요", preferredStyle: .alert )
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
            alert.addAction( ok )
            self.present(alert , animated: true , completion: nil)
            
        }
    }
    
    @objc func pressedSignUpOverlapNicknameCheckBtn( _ sender : UIButton ) {
        
        if !(signUpNicknameTextField.text?.isEmpty)! {
            
            Server.reqOverlapNicknameCheck(member_nickname: signUpNicknameTextField.text!) { ( rescode ) in
                
                if rescode == 201 {
                    
                    self.signUpOverlapNicknameCheckBtn.setImage( #imageLiteral(resourceName: "3_2_2") , for: .normal )
                    self.checkOverlapNickname = true
                    self.signUpOverlapNicknameInfoLabel.isHidden = true
                    
                } else if rescode == 401 {
                    
                    self.signUpOverlapNicknameCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
                    self.checkOverlapNickname = false
                    self.signUpOverlapNicknameInfoLabel.isHidden = false
                    
                } else {
                    
                    self.signUpOverlapNicknameCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
                    self.checkOverlapNickname = false
                    self.signUpOverlapNicknameInfoLabel.isHidden = true
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                    
                }
            }
        } else {
            
            self.signUpOverlapNicknameCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
            self.checkOverlapNickname = false
            self.signUpOverlapNicknameInfoLabel.isHidden = true
            
            let alert = UIAlertController(title: "중복확인", message: "닉네임을 입력해주세요", preferredStyle: .alert )
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
            alert.addAction( ok )
            self.present(alert , animated: true , completion: nil)
            
        }
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
            
            self.selectedCategory = categoryArr[ indexPath.row ]
            isValid()
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
