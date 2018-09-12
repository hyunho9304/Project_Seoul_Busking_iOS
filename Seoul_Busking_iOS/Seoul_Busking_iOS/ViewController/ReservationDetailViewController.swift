//
//  ReservationDetailViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 13..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ReservationDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {

    //  유저 정보
    var memberInfo : Member?
    var selectMemberNickname : String?      //  선택한 타인 닉네임
    
    //  네비게이션 바
    @IBOutlet weak var reservationBackBtn: UIButton!
    
    //  내용
    var memberInfoReservation : [ MemberReservation ] = [ MemberReservation ]()  //  멤버 공연 신청 현황 서버
    @IBOutlet weak var reservationDetailCollectionView: UICollectionView!
    
    
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
        setTapbarAnimation()
        
    }
    
    func set() {
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        reservationDetailCollectionView.alwaysBounceVertical = true
    }
    
    func setDelegate() {
        
        reservationDetailCollectionView.delegate = self
        reservationDetailCollectionView.dataSource = self
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
    }
    
    func setTapbarAnimation() {
        
        UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.tapbarUIView.frame.origin.x = self.tapbarMemberInfoBtn.frame.origin.x
            
        }, completion: nil )
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
        
        self.dismiss(animated: false, completion: nil )
    }
    
    @objc func btnInCell( _ sender : UIButton ) {
        
        if( sender.image(for: .normal) ==  #imageLiteral(resourceName: "right") ) { //  지도 연결
            print("지도")
        } else {    //  삭제할건지 결정
            print("삭제")
        }
    }
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memberInfoReservation.count
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationDetailCollectionViewCell", for: indexPath ) as! ReservationDetailCollectionViewCell
        
        let borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        let borderOpacity : CGFloat = 0.3
        cell.reservationDetailUIView.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
        cell.reservationDetailUIView.layer.borderWidth = 1
        
        cell.reservationDetailUIView.layer.cornerRadius = 6    //  둥근정도
        cell.reservationDetailUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        cell.reservationDetailUIView.layer.shadowColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)             //  그림자 색
        cell.reservationDetailUIView.layer.shadowOpacity = 0.5                          //  그림자 투명도
        cell.reservationDetailUIView.layer.shadowOffset = CGSize(width: 0 , height: 2 )    //  그림자 x y
        cell.reservationDetailUIView.layer.shadowRadius = 5
        
        let tmpDate = String( memberInfoReservation[ indexPath.row ].r_date )
        //            let tmpYear : String = String(tmpDate[ tmpDate.startIndex ..< tmpDate.index(tmpDate.startIndex , offsetBy: 4) ])
        let tmpMonth : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 4) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 6) ] )
        let tmpDay : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 6) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 8) ] )
        
        cell.reservationDetailDateLabel.text = "\(tmpMonth) / \(tmpDay)"
        cell.reservationDetailTimeLabel.text = "\(gino( memberInfoReservation[ indexPath.row ].r_startTime )) : 00 - \(gino( memberInfoReservation[ indexPath.row ].r_endTime )) : 00"
        cell.reservationDetailZoneNameLabel.text = memberInfoReservation[ indexPath.row ].sbz_name
        
        if( self.memberInfo?.member_nickname == self.selectMemberNickname ) {
            cell.reservationDetailSetBtn.setImage( #imageLiteral(resourceName: "delete"), for: .normal)
        } else {
            cell.reservationDetailSetBtn.setImage( #imageLiteral(resourceName: "right"), for: .normal)
        }
        //  cell 안의 버튼 설정
        cell.reservationDetailSetBtn.tag = indexPath.row
        cell.reservationDetailSetBtn.addTarget(self , action: #selector(self.btnInCell(_:)) , for: UIControlEvents.touchUpInside )
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 375 * self.view.frame.width/375 , height: 70 * self.view.frame.height/667 )
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }


}
