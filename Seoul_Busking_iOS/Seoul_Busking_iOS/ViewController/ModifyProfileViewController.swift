//
//  ModifyProfileViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 17..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit
import Kingfisher

class ModifyProfileViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITextFieldDelegate , Gallery {
    var homeController: UIViewController?
    

    //  넘어온 정보
    var memberInfo : Member?
    var memberInfoBasic : MemberInfoBasic?  //  멤버 기본 정보 서버
    
    //  네비게이션 바
    @IBOutlet weak var memberModifyProfilesBackBtn: UIButton!
    @IBOutlet weak var memberModifyProfileCommitBtn: UIButton!
    
    //  내용
    let imagePicker : UIImagePickerController = UIImagePickerController()
    var flag : Int?
    @IBOutlet weak var modifyBackProfileImageView: UIImageView!
    @IBOutlet weak var modifyProfileImageView: UIImageView!
    @IBOutlet weak var modifyNicknameTextField: UITextField!
    @IBOutlet weak var modifyOverlapCheckBtn: UIButton!
    @IBOutlet weak var modifyOverlapInfoLabel: UILabel!
    @IBOutlet weak var modifyIntroductionTextView: UITextView!
    @IBOutlet weak var modifyCateogyUIView: UIView!
    @IBOutlet weak var modifyCategoryBtn: UIButton!
    @IBOutlet weak var modifyCategoryLabel: UILabel!
    var checkOverlapNickname : Bool?            //  닉네임 중복 bool 값
    
    @IBOutlet weak var modifyBackProfilePlusBtn: UIButton!
    @IBOutlet weak var modifyProfilePlusBtn: UIButton!
    
    
    
    //  카테고리
    @IBOutlet weak var backUIView: UIView!
    @IBOutlet weak var collectionViewUIView: UIView!
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    var categoryArr : [String] = [ "노래" , "댄스" , "연주" , "마술" , "미술" , "기타" ]
    var categoryImageArr = [ #imageLiteral(resourceName: "2_3_1.png") , #imageLiteral(resourceName: "2_3_1.png") , #imageLiteral(resourceName: "2_3_1.png") , #imageLiteral(resourceName: "2_3_1.png") , #imageLiteral(resourceName: "2_3_1.png") , #imageLiteral(resourceName: "2_3_1.png") ]
    var selectCategory : String?
    
    //  알림창
    @IBOutlet weak var alertUIView: UIView!
    @IBOutlet weak var alertCancelBtn: UIButton!
    @IBOutlet weak var alertCommitBtn: UIButton!
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    var uiviewX : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setDelegate()
        setTarget()
        confirmWrite()
        
        hideKeyboardWhenTappedAround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch? = touches.first
        
        if touch?.view == backUIView {
            
            backUIView.isHidden = true
            collectionViewUIView.isHidden = true
            alertUIView.isHidden = true
        }
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        collectionViewUIView.isHidden = true
        collectionViewUIView.layer.cornerRadius = 10    //  둥근정도
        collectionViewUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        collectionViewUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        collectionViewUIView.layer.shadowOpacity = 0.15                            //  그림자 투명도
        collectionViewUIView.layer.shadowOffset = CGSize(width: 0 , height: 3 )    //  그림자 x y
        collectionViewUIView.layer.shadowRadius = 5                                //  그림자 둥근정도
        //  그림자의 블러는 5 정도 이다
        
        backUIView.isHidden = true
        backUIView.backgroundColor = UIColor.black.withAlphaComponent( 0.6 )
        alertUIView.isHidden = true
        alertUIView.layer.cornerRadius = 5    //  둥근정도
        alertUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        alertUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        alertUIView.layer.shadowOpacity = 0.15                            //  그림자 투명도
        alertUIView.layer.shadowOffset = CGSize(width: 0 , height: 3 )    //  그림자 x y
        alertUIView.layer.shadowRadius = 5                                //  그림자 둥근정도
        //  그림자의 블러는 5 정도 이다
        
        //        okBtn.clipsToBounds = true    안에 있는 글 잘린다
        alertCommitBtn.layer.cornerRadius = 5
        alertCommitBtn.layer.maskedCorners = [.layerMaxXMaxYCorner ]
        
        alertCancelBtn.layer.cornerRadius = 5
        alertCancelBtn.layer.maskedCorners = [ .layerMinXMaxYCorner ]
        
        if( self.memberInfoBasic?.member_profile != nil ) {
            
            let tmpProfile = self.getStoS( (self.memberInfoBasic?.member_profile)! )
            
            self.modifyProfileImageView.kf.setImage(with: URL( string: tmpProfile ) )
            self.modifyProfileImageView.layer.cornerRadius = self.modifyProfileImageView.layer.frame.width/2
            self.modifyProfileImageView.clipsToBounds = true
            
        } else {
            self.modifyProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
        }
        
        //  수정 -> 배경화면
        if( self.memberInfoBasic?.member_backProfile != nil ) {
            
            let tmpProfile = self.getStoS( (self.memberInfoBasic?.member_backProfile)! )
            
            self.modifyBackProfileImageView.kf.setImage(with: URL( string: tmpProfile ) )
            
        } else {
            self.modifyBackProfileImageView.backgroundColor = #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1)
        }
        
        modifyNicknameTextField.text = self.memberInfoBasic?.member_nickname
        modifyIntroductionTextView.text = self.memberInfoBasic?.member_introduction
        
        if( memberInfo?.member_type == "1" ) {
            
            modifyCateogyUIView.isHidden = false
            let tmpCategory = self.getStoS( (self.memberInfoBasic?.member_category)! )
            self.modifyCategoryLabel.text = "# \(tmpCategory)"
            selectCategory = tmpCategory
            
        } else {
            modifyCateogyUIView.isHidden = true
        }
        
        checkOverlapNickname = true
        
        
        
    }
    
    func setDelegate() {
        
        homeController = self
        
        modifyNicknameTextField.delegate = self
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  백 버튼
        memberModifyProfilesBackBtn.addTarget(self, action: #selector(self.pressedMemberModifyProfilesBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  프로필 수정 커밋 버튼
        memberModifyProfileCommitBtn.addTarget(self, action: #selector(self.pressedMemberMemberModifyProfileCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  배경사진
        let tapBackProfileImage = UITapGestureRecognizer(target: self , action: #selector( self.pressedModifyBackProfileImageView(_:) ))
        modifyBackProfileImageView.isUserInteractionEnabled = true
        modifyBackProfileImageView.addGestureRecognizer(tapBackProfileImage)
        //  배경사진 수정 버튼
        modifyBackProfilePlusBtn.addTarget(self, action: #selector(self.pressedModifyBackProfileImageView(_:)), for: UIControlEvents.touchUpInside)

        //  프로필사진
        let tapProfileImage = UITapGestureRecognizer(target: self , action: #selector( self.pressedModifyProfileImageView(_:) ))
        modifyProfileImageView.isUserInteractionEnabled = true
        modifyProfileImageView.addGestureRecognizer(tapProfileImage)
        //  프로필 수정 버튼
        modifyProfilePlusBtn.addTarget(self, action: #selector(self.pressedModifyProfileImageView(_:)), for: UIControlEvents.touchUpInside)
        
        //  닉네임 중복 확인 체크 버튼
        modifyOverlapCheckBtn.addTarget(self, action: #selector(self.pressedModifyOverlapCheckBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  카테고리 선택 버튼
        modifyCategoryBtn.addTarget(self, action: #selector(self.pressedModifyCategoryBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  취소 버튼
        alertCancelBtn.addTarget(self, action: #selector(self.pressedAlertCancelBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  확인 버튼
        alertCommitBtn.addTarget(self, action: #selector(self.pressedAlertCommitBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func confirmWrite() {
        
        modifyNicknameTextField.addTarget(self, action: #selector(setOverlapNickname), for: .editingChanged)   //  textField
        
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        
        mapVC.memberInfo = self.memberInfo
        
        self.present( mapVC , animated: false , completion: nil )
    }
    
    //  홈 버튼 액션
    @objc func pressedTapbarHomeBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        
        homeVC.uiviewX = self.tapbarMemberInfoBtn.frame.origin.x
        homeVC.memberInfo = self.memberInfo
        
        self.present( homeVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: false , completion: nil )
        
    }
    
    //  백 버튼 액션
    @objc func pressedMemberModifyProfilesBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: false , completion: nil )
    }
    
    //  프로필 수정 커밋 버튼 액션
    @objc func pressedMemberMemberModifyProfileCommitBtn( _ sender : UIButton ) {
        
        if( checkOverlapNickname == true ) {
            
            backUIView.isHidden = false
            alertUIView.isHidden = false
            
        } else {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "닉네임 중복확인을 해주세요"
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
        }
    }
    
    //  배경사진 이미지 액션
    @objc func pressedModifyBackProfileImageView( _ sender : UIImageView ) {
        
        flag = 0
        openGalleryCamera()
    }
    
    //  프로필사진 이미지 액션
    @objc func pressedModifyProfileImageView( _ sender : UIImageView ) {
        
        flag = 1
        openGalleryCamera()
    }
    
    //  닉네임 중복확인 버튼 액션
    @objc func pressedModifyOverlapCheckBtn( _ sender : UIButton ) {
        
        if !(modifyNicknameTextField.text?.isEmpty)! {
            
            if( modifyNicknameTextField.text == memberInfoBasic?.member_nickname ) {
                
                self.modifyOverlapCheckBtn.setImage( #imageLiteral(resourceName: "3_2_2") , for: .normal )
                self.checkOverlapNickname = true
                
                self.modifyOverlapInfoLabel.text = "사용 가능한 닉네임입니다."
                self.modifyOverlapInfoLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                self.modifyOverlapInfoLabel.isHidden = false
            
            } else {
                
                Server.reqOverlapNicknameCheck(member_nickname: modifyNicknameTextField.text!) { ( rescode ) in
                    
                    if rescode == 201 {
                        
                        self.modifyOverlapCheckBtn.setImage( #imageLiteral(resourceName: "3_2_2") , for: .normal )
                        self.checkOverlapNickname = true
                        
                        self.modifyOverlapInfoLabel.text = "사용 가능한 닉네임입니다."
                        self.modifyOverlapInfoLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                        self.modifyOverlapInfoLabel.isHidden = false
                        
                    } else if rescode == 401 {
                        
                        self.modifyOverlapCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
                        self.checkOverlapNickname = false
                        
                        self.modifyOverlapInfoLabel.text = "이미 사용중인 닉네임입니다."
                        self.modifyOverlapInfoLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                        self.modifyOverlapInfoLabel.isHidden = false
                        
                    } else {
                        
                        self.modifyOverlapCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
                        self.checkOverlapNickname = false
                        self.modifyOverlapInfoLabel.isHidden = true
                        
                        let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
                        
                    }
                }
            }
        } else {
            
            self.modifyOverlapCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
            self.checkOverlapNickname = false
            
            self.modifyOverlapInfoLabel.text = "닉네임을 입력해 주세요."
            self.modifyOverlapInfoLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            self.modifyOverlapInfoLabel.isHidden = false
            
        }
    }
    
    //  카테고리 선택 버튼 액션
    @objc func pressedModifyCategoryBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = false
        collectionViewUIView.isHidden = false
    }
    
    //  취소 버튼 액션
    @objc func pressedAlertCancelBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = true
        alertUIView.isHidden = true
    }
    
    //  확인 버튼 액션
    @objc func pressedAlertCommitBtn( _ sender : UIButton ) {
        
        if( memberInfo?.member_type == "1" ) {
          
            Server.reqMemberBuskerUpdateInfo(member_ID: (self.memberInfo?.member_ID)! , member_nickname: self.modifyNicknameTextField.text! , member_introduction: self.modifyIntroductionTextView.text! , member_category: self.selectCategory! , file1: self.modifyBackProfileImageView.image! , file2: self.modifyProfileImageView.image!) { ( rescode ) in
                
                if( rescode == 201 ) {
                    
                    self.backUIView.isHidden = true
                    self.alertUIView.isHidden = true
                    
                    self.dismiss(animated: true , completion: nil )
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
        } else {
            
            Server.reqMemberUpdateInfo(member_ID: (self.memberInfo?.member_ID)! , member_nickname: self.modifyNicknameTextField.text! , member_introduction: self.modifyIntroductionTextView.text! , file1: self.modifyBackProfileImageView.image! , file2: self.modifyProfileImageView.image!) { ( rescode ) in
                
                if( rescode == 201 ) {
                    
                    self.backUIView.isHidden = true
                    self.alertUIView.isHidden = true
                    
                    self.dismiss(animated: true , completion: nil )
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
        }
    }

    
    //  닉네임 텍스트필드 변경 시 액션
    @objc func setOverlapNickname() {
        
        self.modifyOverlapCheckBtn.setImage( #imageLiteral(resourceName: "3_2_1") , for: .normal )
        self.checkOverlapNickname = false
        self.modifyOverlapInfoLabel.isHidden = true
    }
    
// Mark -> CollectionView delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArr.count
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCategoryCollectionViewCell", for: indexPath ) as! ReservationCategoryCollectionViewCell
        
        cell.categoryNameLabel.text = categoryArr[ indexPath.row ]
        cell.categoryImageView.image = categoryImageArr[ indexPath.row ]
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        modifyCategoryLabel.text = "# \(categoryArr[ indexPath.row ])"
        backUIView.isHidden = true
        collectionViewUIView.isHidden = true
        selectCategory = self.categoryArr[ indexPath.row ]
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 141 * self.view.frame.width/375 , height: 106 * self.view.frame.height/667 )
    }
    
    //  cell 섹션 내부 여백( default 는 0 보다 크다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    //  cell 간 가로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func getItoI( _ sender : Int ) -> Int {
        
        let result = gino( sender )
        return result
        
    }
    
    func getStoS( _ sender : String ) -> String {
        
        let result = gsno( sender )
        return result
    }
}

//  Mark -> 겔러리 , 카메라
extension ModifyProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.dismiss(animated: true, completion:  {self.customFunction(image: pickedImage)} )
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func customFunction(image: UIImage) {
        
        if( self.flag == 0 ) {
            modifyBackProfileImageView.image = image
        } else {
            modifyProfileImageView.image = image
            modifyProfileImageView.layer.cornerRadius = self.modifyProfileImageView.layer.frame.width/2
            modifyProfileImageView.clipsToBounds = true
        }
    }
}
