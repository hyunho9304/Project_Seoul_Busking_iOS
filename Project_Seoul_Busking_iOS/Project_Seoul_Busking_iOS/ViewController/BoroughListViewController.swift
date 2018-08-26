//
//  BoroughListViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//
import UIKit

class BoroughListViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //  넘어온 정보
    var memberInfo : Member?            //  유저 정보
    var selectedBoroughIndex : Int?     //  선택한 자치구 index
    var selectedBoroughName : String?   //  선택한 자치구 name
    var selectedZoneIndex : Int?        //  멤버가 선택한 존 index
    var selectedZoneName : String?      //  멤버가 선택한 존 name
    var selectedZoneImage : String?     //  멤버가 선택한 존 ImageString
    var selectedTmpDate : String?       //  멤버가 선택한 날짜.
    var selectedDate : String?          //  멤버가 선택한 날짜
    
    
    //  네비게이션 바
    @IBOutlet weak var reservationBackBtn: UIButton!
    
    //  자치구 내용
    @IBOutlet weak var boroughListCollectionView: UICollectionView!
    var boroughList : [ Borough ] = [ Borough ]()  //  서버 자치구 리스트
    var boroughSelectedIndexPath :IndexPath?    //  선택고려
    var selectedIndex : Int?      //  선택한 index
    var selectedName : String?    //  선택한 name
    
    @IBOutlet weak var selectBoroughCommitBtn: UIButton!        //  선택완료버튼
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var uiviewX : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimate()
        set()
        setDelegate()
        setTarget()
        setTapbarAnimation()
        
        boroughInit()
    }
    
    func showAnimate() {
        
        self.view.frame = CGRect(x: 375, y: 0, width: 375, height: 667)
        
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn , animations: {
            
            self.view.frame.origin.x = 0
            
        }, completion: nil )
    }
    
    
    func set() {

        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        selectBoroughCommitBtn.layer.cornerRadius = 25
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  뒤로가기 버튼
        reservationBackBtn.addTarget(self, action: #selector(self.pressedReservationBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  선택완료 버튼
        selectBoroughCommitBtn.addTarget(self, action: #selector(self.pressedSelectBoroughCommitBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setDelegate() {
        
        boroughListCollectionView.delegate = self
        boroughListCollectionView.dataSource = self
    }
    
    func setTapbarAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            
            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.tapbarUIView.frame.origin.x = self.tapbarHomeBtn.frame.origin.x
                
            }, completion: nil )
        })
    }
    
    func boroughInit() {
        
        Server.reqBoroughList { (boroughData , rescode ) in
            
            if( rescode == 200 ) {
                
                self.boroughList = boroughData
                self.boroughListCollectionView.reloadData()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        
        mapVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        mapVC.memberInfo = self.memberInfo
        
        self.present( mapVC , animated: false , completion: nil )
    }
    
    //  홈 버튼 액션
    @objc func pressedTapbarHomeBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        homeVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        homeVC.memberInfo = self.memberInfo
        
        self.present( homeVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        memberInfoVC.memberInfo = self.memberInfo
        
        self.present( memberInfoVC , animated: false , completion: nil )
    }
    
    //  뒤로가기 버튼 액션
    @objc func pressedReservationBackBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseIn , animations: {
            
            self.view.frame.origin.x = 375
          
            guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
            
            reservationVC.memberInfo = self.memberInfo
            reservationVC.uiviewX = self.uiviewX
            
            reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
            reservationVC.selectedBoroughName = self.selectedBoroughName
            reservationVC.selectedZoneIndex = self.selectedZoneIndex
            reservationVC.selectedZoneName = self.selectedZoneName
            reservationVC.selectedZoneImage = self.selectedZoneImage
            reservationVC.selectedTmpDate = self.selectedTmpDate
            reservationVC.selectedDate = self.selectedDate
            
            self.present( reservationVC , animated: false , completion: nil )
            
            self.view.removeFromSuperview()
        })
    }
    
    //  선택완료 버튼 액션
    @objc func pressedSelectBoroughCommitBtn( _ sender : UIButton ) {
        
        //  선택 했을경우
        if( boroughSelectedIndexPath != nil  ) {
            
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseIn , animations: {
                
                self.view.frame.origin.x = 375
              
                guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
                
                reservationVC.memberInfo = self.memberInfo
                reservationVC.uiviewX = self.uiviewX
                
                reservationVC.selectedBoroughIndex = self.selectedIndex
                reservationVC.selectedBoroughName = self.selectedName
                
                
                self.present( reservationVC , animated: false , completion: nil )
                
                self.view.removeFromSuperview()
            })

            
        } else {    //  선택 안했을 경우
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "지역을 선택해 주세요."
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
            
        }

    }
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return boroughList.count
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectBoroughCollectionViewCell", for: indexPath ) as! SelectBoroughCollectionViewCell
        
        cell.boroughLabel.text = boroughList[ indexPath.row ].sb_name
        
        if( indexPath == boroughSelectedIndexPath ) {
            
            cell.boroughBackView.layer.cornerRadius = 20
            cell.boroughBackView.isHidden = false
            cell.boroughLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.selectedIndex = boroughList[ indexPath.row ].sb_id
            self.selectedName = boroughList[ indexPath.row ].sb_name
            
        } else {
            
            cell.boroughBackView.isHidden = true
            cell.boroughLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
            
        }
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        boroughSelectedIndexPath = indexPath
        
        collectionView.reloadData()
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 72 * self.view.frame.width/375 , height: 39 * self.view.frame.height/667 )
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 13
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 14
    }


}
