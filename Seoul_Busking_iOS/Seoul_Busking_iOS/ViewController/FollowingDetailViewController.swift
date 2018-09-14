//
//  FollowingDetailViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 14..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class FollowingDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //  유저 정보
    var memberInfo : Member?
    var memberInfoBasic : MemberInfoBasic?  //  멤버 기본 정보 서버
    
    //  네비게이션 바
    @IBOutlet weak var reservationBackBtn: UIButton!
    
    //  내용
    var memberInfoFollowingReservation : [ MemberFollowingReservation ] = [ MemberFollowingReservation ]()  //  멤버 팔로잉 멤버들의 공연 신청 현황 서버
    @IBOutlet weak var followingDetailCollectionView: UICollectionView!
    var refresher : UIRefreshControl?
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    var uiviewX : CGFloat?
    
    //  오늘 시간
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
        
        getMemberInfoFollowingReservation()
    }
    
    func set() {
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        followingDetailCollectionView.alwaysBounceVertical = true
        
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
    
    func reloadTarget() {
        
        refresher = UIRefreshControl()
        refresher?.tintColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
        refresher?.addTarget( self , action : #selector( reloadData ) , for : .valueChanged )
        followingDetailCollectionView.addSubview( refresher! )
    }
    
    @objc func reloadData() {
        
        self.getMemberInfoFollowingReservation()
        stopRefresher()
    }
    
    func stopRefresher() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            self.refresher?.endRefreshing()
        })
    }
    
    func setDelegate() {
        
        followingDetailCollectionView.delegate = self
        followingDetailCollectionView.dataSource = self
    }
    
    func setTapbarAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            
            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.tapbarUIView.frame.origin.x = self.tapbarMemberInfoBtn.frame.origin.x
                
            }, completion: nil )
        })
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
        
        self.dismiss(animated: true , completion: nil )
    }
    
    //  팔로잉 멤버들의 공연 일정 가져오기
    func getMemberInfoFollowingReservation() {
        
        Server.reqMemberInfoFollowingReservation(member_nickname: (self.memberInfoBasic?.member_nickname)!, r_date: self.todayDateTime!) { ( memberFollowingReservationData , rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberInfoFollowingReservation = memberFollowingReservationData
                self.followingDetailCollectionView.reloadData()
                
                if( self.memberInfoFollowingReservation.count == 0 ) {
                    self.dismiss(animated: true , completion: nil)
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
        
        return memberInfoFollowingReservation.count
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowingDetailCollectionViewCell", for: indexPath ) as! FollowingDetailCollectionViewCell
        
        let borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        let borderOpacity : CGFloat = 0.3
        cell.followingDetailUIView.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
        cell.followingDetailUIView.layer.borderWidth = 1
        
        cell.followingDetailUIView.layer.cornerRadius = 6    //  둥근정도
        cell.followingDetailUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        cell.followingDetailUIView.layer.shadowColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)             //  그림자 색
        cell.followingDetailUIView.layer.shadowOpacity = 0.5                          //  그림자 투명도
        cell.followingDetailUIView.layer.shadowOffset = CGSize(width: 0 , height: 2 )    //  그림자 x y
        cell.followingDetailUIView.layer.shadowRadius = 5
        
        if( memberInfoFollowingReservation[ indexPath.row ].member_profile != nil ) {
            
            cell.followingDetailProfileImageView.kf.setImage( with: URL( string:gsno(memberInfoFollowingReservation[ indexPath.row ].member_profile ) ) )
            cell.followingDetailProfileImageView.layer.cornerRadius = cell.followingDetailProfileImageView.layer.frame.width/2
            cell.followingDetailProfileImageView.clipsToBounds = true
            
        } else {
            
            cell.followingDetailProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
        }
        
        cell.followingDetailNicknameLabel.text = memberInfoFollowingReservation[ indexPath.row ].member_nickname
        
        let tmpCategory = self.getStoS( (self.memberInfoFollowingReservation[ indexPath.row ].r_category )!)
        cell.followingDetailCategoryLabel.text = "# \(tmpCategory)"
        
        let tmpDate = String( memberInfoFollowingReservation[ indexPath.row ].r_date )
        //            let tmpYear : String = String(tmpDate[ tmpDate.startIndex ..< tmpDate.index(tmpDate.startIndex , offsetBy: 4) ])
        let tmpMonth : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 4) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 6) ] )
        let tmpDay : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 6) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 8) ] )
        
        cell.followingDetailDateLabel.text = "\(tmpMonth) / \(tmpDay)"
        cell.followingDetailTimeLabel.text = "\(gino( memberInfoFollowingReservation[ indexPath.row ].r_startTime )) : 00 - \(gino( memberInfoFollowingReservation[ indexPath.row ].r_endTime )) : 00"
        cell.followingDetailZoneNameLabel.text = memberInfoFollowingReservation[ indexPath.row ].sbz_name

        
        //  cell 안의 버튼 설정
        cell.followingDetailSetBtn.tag = indexPath.row
        cell.followingDetailSetBtn.addTarget(self , action: #selector(self.btnInCell(_:)) , for: UIControlEvents.touchUpInside )
        
        return cell
    }
    
    //  cell 안의 버튼 눌렀을 때
    @objc func btnInCell( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.memberInfo = self.memberInfo
        memberInfoVC.selectMemberNickname = memberInfoFollowingReservation[ sender.tag ].member_nickname
        
        self.present( memberInfoVC , animated: true , completion: nil )
        
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 375 * self.view.frame.width/375 , height: 114 * self.view.frame.height/667 )
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
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
