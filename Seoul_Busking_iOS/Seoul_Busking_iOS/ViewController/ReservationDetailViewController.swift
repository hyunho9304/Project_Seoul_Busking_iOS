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
    var refresher : UIRefreshControl?
    
    //  popView
    @IBOutlet weak var alertUIView: UIView!
    @IBOutlet weak var alertCancelBtn: UIButton!
    @IBOutlet weak var alertCommitBtn: UIButton!
    @IBOutlet weak var backUIView: UIView!
    var selectedDropIndex : Int?
    
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var uiviewX : CGFloat?
    
    var year = calendar.component(.year, from: date)
    var month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let hour = calendar.component(.hour, from: date)
    var todayDateTime : Int?    //  선택한년월일 ex ) 2018815
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setDelegate()
        setTarget()
        reloadTarget()
        setTapbarAnimation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getMemberInfoReservation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch? = touches.first
        
        if touch?.view == backUIView {
            
            backUIView.isHidden = true
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
        
        reservationDetailCollectionView.alwaysBounceVertical = true
        
        backUIView.isHidden = true
        backUIView.backgroundColor = UIColor.black.withAlphaComponent( 0.6 )
        alertUIView.isHidden = true
        alertUIView.layer.cornerRadius = 5 * self.view.frame.width / 375    //  둥근정도
        alertUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        alertUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        alertUIView.layer.shadowOpacity = 0.15                            //  그림자 투명도
        alertUIView.layer.shadowOffset = CGSize(width: 0 , height: 3 )    //  그림자 x y
        alertUIView.layer.shadowRadius = 5                                //  그림자 둥근정도
        //  그림자의 블러는 5 정도 이다
        
        //        okBtn.clipsToBounds = true    안에 있는 글 잘린다
        alertCommitBtn.layer.cornerRadius = 5 * self.view.frame.width / 375
        alertCommitBtn.layer.maskedCorners = [.layerMaxXMaxYCorner ]
        
        alertCancelBtn.layer.cornerRadius = 5 * self.view.frame.width / 375
        alertCancelBtn.layer.maskedCorners = [ .layerMinXMaxYCorner ]
        
        let yearString : String = String(year)
        var monthString : String = String( month )
        var dayString : String = String( day )
        
        
        if( monthString.count == 1 ) {
            monthString.insert("0", at: monthString.startIndex )
        }
        if( dayString.count == 1 ) {
            dayString.insert("0", at: dayString.startIndex )
        }
        
        let tmpDate : String = yearString + monthString + dayString
        todayDateTime = Int( tmpDate )
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
        
        //  취소 버튼
        alertCancelBtn.addTarget(self, action: #selector(self.pressedAlertCancelBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  확인 버튼
        alertCommitBtn.addTarget(self, action: #selector(self.pressedAlertCommitBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func reloadTarget() {
        
        refresher = UIRefreshControl()
        refresher?.tintColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
        refresher?.addTarget( self , action : #selector( reloadData ) , for : .valueChanged )
        reservationDetailCollectionView.addSubview( refresher! )
    }
    
    @objc func reloadData() {
        
        self.getMemberInfoReservation()
        stopRefresher()
    }
    
    func stopRefresher() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            self.refresher?.endRefreshing()
        })
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
    
    //  취소 버튼 액션
    @objc func pressedAlertCancelBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = true
        alertUIView.isHidden = true
    }
    
    //  확인 버튼 액션
    @objc func pressedAlertCommitBtn( _ sender : UIButton ) {
        
        Server.reqDropReservation(r_id: self.memberInfoReservation[selectedDropIndex! ].r_id!) { ( rescode ) in

            if( rescode == 201 ) {
                
                self.backUIView.isHidden = true
                self.alertUIView.isHidden = true
                self.getMemberInfoReservation()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }

    }
    
    //  공연 신청 현황 가져오기
    func getMemberInfoReservation() {
        
        Server.reqMemberInfoReservation(member_nickname: self.selectMemberNickname! , r_date: self.todayDateTime! ) { ( memberReservationData , rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberInfoReservation = memberReservationData
                self.reservationDetailCollectionView.reloadData()
                
                if( self.memberInfoReservation.count == 0 ) {
                    self.dismiss(animated: false , completion: nil)
                }
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
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
        
        cell.reservationDetailUIView.layer.cornerRadius = 6 * self.view.frame.width / 375    //  둥근정도
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
        
        var resultStartMin : String = "0"
        var resultEndMin : String = "0"
        let startmin : Int = gino( memberInfoReservation[ indexPath.row ].r_startMin )
        let tmpStartMin = String( startmin )
        let endMin : Int = gino( memberInfoReservation[ indexPath.row ].r_endMin )
        let tmpEndMin = String( endMin )
        if( tmpStartMin.count == 1 ) {
            resultStartMin = resultStartMin + tmpStartMin
        } else {
            resultEndMin = tmpEndMin
        }
        if( tmpEndMin.count == 1 ) {
            resultEndMin = resultEndMin + tmpEndMin
        } else {
            resultEndMin = tmpEndMin
        }
        
        cell.reservationDetailTimeLabel.text = "\(gino( memberInfoReservation[ indexPath.row ].r_startTime )) : \(resultStartMin) - \(gino( memberInfoReservation[ indexPath.row ].r_endTime )) : \(resultEndMin)"
        
        
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
    
    //  cell 안의 버튼 눌렀을 때
    @objc func btnInCell( _ sender : UIButton ) {
        
        if( sender.image(for: .normal) ==  #imageLiteral(resourceName: "right") ) { //  지도 연결
            
            guard let zoneMapDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoneMapDetailViewController") as? ZoneMapDetailViewController else { return }
            
            zoneMapDetailVC.memberInfo = self.memberInfo
            zoneMapDetailVC.uiviewX = self.uiviewX
            zoneMapDetailVC.selectedBoroughName = self.memberInfoReservation[ sender.tag ].sb_name
            zoneMapDetailVC.selectedZoneName = self.memberInfoReservation[ sender.tag ].sbz_name
            zoneMapDetailVC.selectedZoneImage = self.memberInfoReservation[ sender.tag ].sbz_photo
            zoneMapDetailVC.selectedZoneAddress = self.memberInfoReservation[ sender.tag ].sbz_address
            zoneMapDetailVC.selectedZoneLongitude = self.memberInfoReservation[ sender.tag ].sbz_longitude
            zoneMapDetailVC.selectedZoneLatitude = self.memberInfoReservation[ sender.tag ].sbz_latitude
            
            self.present( zoneMapDetailVC , animated: false , completion: nil )
            
        } else {    //  삭제할건지 결정
            
            self.alertUIView.isHidden = false
            self.backUIView.isHidden = false
            
            self.alertUIView.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
            self.alertUIView.alpha = 0.0
            UIView.animate(withDuration: 0.18) {
                self.alertUIView.alpha = 1.0
                self.alertUIView.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
            }
            
            self.selectedDropIndex = sender.tag
        }
    }

    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if(  self.memberInfo?.member_nickname != self.selectMemberNickname  ) { //  지도 연결
            
            guard let zoneMapDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoneMapDetailViewController") as? ZoneMapDetailViewController else { return }
            
            zoneMapDetailVC.memberInfo = self.memberInfo
            zoneMapDetailVC.uiviewX = self.uiviewX
            zoneMapDetailVC.selectedBoroughName = self.memberInfoReservation[ indexPath.row ].sb_name
            zoneMapDetailVC.selectedZoneName = self.memberInfoReservation[ indexPath.row ].sbz_name
            zoneMapDetailVC.selectedZoneImage = self.memberInfoReservation[ indexPath.row ].sbz_photo
            zoneMapDetailVC.selectedZoneAddress = self.memberInfoReservation[ indexPath.row ].sbz_address
            zoneMapDetailVC.selectedZoneLongitude = self.memberInfoReservation[ indexPath.row ].sbz_longitude
            zoneMapDetailVC.selectedZoneLatitude = self.memberInfoReservation[ indexPath.row ].sbz_latitude
            
            self.present( zoneMapDetailVC , animated: false , completion: nil )
            
        } else {    //  삭제할건지 결정
            
            self.alertUIView.isHidden = false
            self.backUIView.isHidden = false
            
            self.alertUIView.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
            self.alertUIView.alpha = 0.0
            UIView.animate(withDuration: 0.18) {
                self.alertUIView.alpha = 1.0
                self.alertUIView.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
            }
            
            self.selectedDropIndex = indexPath.row
        }
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
