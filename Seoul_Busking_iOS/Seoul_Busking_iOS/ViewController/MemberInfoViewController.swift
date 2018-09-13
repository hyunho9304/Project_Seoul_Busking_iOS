//
//  MemberInfoViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 15..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class MemberInfoViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //  넘어온 정보
    var memberInfo : Member?
    var selectMemberNickname : String?      //  선택한 타인 닉네임
    
    //  네비게이션 바
    @IBOutlet weak var memberInfoBackBtn: UIButton!
    @IBOutlet weak var memberInfoRightBtn: UIButton!
    
    //  내용
    var memberInfoBasic : MemberInfoBasic?  //  멤버 기본 정보 서버
    @IBOutlet weak var memberProfileImageView: UIImageView!
    @IBOutlet weak var memberSetBtn: UIButton!
    @IBOutlet weak var memberNicknameLabel: UILabel!
    @IBOutlet weak var memberCategoryLabel: UILabel!
    @IBOutlet weak var memberIntroductionTextView: UITextView!
    @IBOutlet weak var memberFollowingCntLabel: UILabel!
    @IBOutlet weak var memberFollowCntLabel: UILabel!
    @IBOutlet weak var memberStar1: UIImageView!
    @IBOutlet weak var memberStar2: UIImageView!
    @IBOutlet weak var memberStar3: UIImageView!
    @IBOutlet weak var memberStar4: UIImageView!
    @IBOutlet weak var memberStar5: UIImageView!
    @IBOutlet weak var memberScoreLabel: UILabel!
    
    
    //  애니메이션바
    @IBOutlet weak var animationUIView: UIView!
    
    //  공연 신청 현황
    var memberInfoReservation : [ MemberReservation ] = [ MemberReservation ]()  //  멤버 공연 신청 현황 서버
    @IBOutlet weak var reservationInfoBtn: UIButton!
    @IBOutlet weak var reservationUIView: UIView!
    @IBOutlet weak var reservationCollectionView: UICollectionView!
    @IBOutlet weak var reservationNothingLabel: UILabel!
    
    //  팔로잉 일정
    var memberInfoFollowingReservation : [ MemberFollowingReservation ] = [ MemberFollowingReservation ]()  //  멤버 팔로잉 멤버들의 공연 신청 현황 서버
    @IBOutlet weak var followingScheduleBtn: UIButton!
    @IBOutlet weak var followingScheduleUIView: UIView!
    @IBOutlet weak var followingScheduleCollectionView: UICollectionView!
    @IBOutlet weak var followingNothingLabel: UILabel!
    
    
    //  공연 후기
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var reviewUIView: UIView!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var reviewNothingLabel: UILabel!
    
    //  더보기 버튼
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var moreImageBtn: UIButton!
    
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var year = calendar.component(.year, from: date)
    var month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let hour = calendar.component(.hour, from: date)
    var todayDateTime : Int?    //  선택한년월일 ex ) 2018815
    
    var uiviewX : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setTarget()
        setDelegate()
        setTapbarAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        getShowMemberInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute: {
            
            if( self.memberInfoBasic?.member_type != "1" ) { //  관람객 디폴트 설정
                
                UIView.animate(withDuration: 1 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                    
                    self.animationUIView.frame.origin.x = self.followingScheduleBtn.frame.origin.x
                    
                }, completion: nil )
                
                self.animationUIView.layoutIfNeeded()
                
            }
        })
    }
    
    func getItoI( _ sender : Int ) -> Int {
        
        let result = gino( sender )
        return result
        
    }
    
    func getStoS( _ sender : String ) -> String {
        
        let result = gsno( sender )
        return result
    }
    
    func set() {

        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        //  자신프로필
        if( self.selectMemberNickname == nil || self.selectMemberNickname == self.memberInfo?.member_nickname ) {
            
            self.selectMemberNickname = self.memberInfo?.member_nickname
            self.memberInfoRightBtn.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
            self.memberSetBtn.setImage(#imageLiteral(resourceName: "modifyProfile"), for: .normal)
            
        } else {    //  타인 프로필
            
            self.memberInfoRightBtn.setImage(#imageLiteral(resourceName: "report"), for: .normal)
            self.memberSetBtn.setImage(#imageLiteral(resourceName: "followEmpty"), for: .normal)
            getisFollowing()
        }
        
        if( self.view.frame.height > 667 ) {
            animationUIView.frame = CGRect(x: 22 , y: 428, width: 121.67 , height: 3 )
        }

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

        reservationCollectionView.delegate = self
        reservationCollectionView.dataSource = self

        followingScheduleCollectionView.delegate = self
        followingScheduleCollectionView.dataSource = self
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  백 버튼
        memberInfoBackBtn.addTarget(self, action: #selector(self.pressedMemberInfoBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  공연 신청 현황 버튼
        reservationInfoBtn.addTarget(self, action: #selector(self.pressedReservationInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  팔로잉 일정 버튼
        followingScheduleBtn.addTarget(self, action: #selector(self.pressedFollowingScheduleBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  공연 후기 버튼
        reviewBtn.addTarget(self, action: #selector(self.pressedReviewBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  더보기 버튼
        moreImageBtn.addTarget(self, action: #selector(self.pressedMoreImageBtn(_:)), for: UIControlEvents.touchUpInside)
        let tapMore = UITapGestureRecognizer(target: self , action: #selector( self.pressedMoreImageBtn(_:) ))
        moreLabel.isUserInteractionEnabled = true
        moreLabel.addGestureRecognizer(tapMore)
        
        
        
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
        
        homeVC.uiviewX = self.tapbarMemberInfoBtn.frame.origin.x
        homeVC.memberInfo = self.memberInfo
        
        self.present( homeVC , animated: false , completion: nil )
    }
    
    //  백 버튼 액션
    @objc func pressedMemberInfoBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: false , completion: nil )
    }
    
    //  공연 신청 현황 버튼 액션
    @objc func pressedReservationInfoBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.4 , delay: 0, usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            self.animationUIView.frame.origin.x = self.reservationInfoBtn.frame.origin.x
            
            
        }, completion: nil )
        
        self.animationUIView.layoutIfNeeded()
        selectMenu( self.reservationInfoBtn )
    }
    
    //  팔로잉 일정 버튼 액션
    @objc func pressedFollowingScheduleBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.4 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.animationUIView.frame.origin.x = self.followingScheduleBtn.frame.origin.x
            
        }, completion: nil )
        
        self.animationUIView.layoutIfNeeded()
        selectMenu( self.followingScheduleBtn )
    }
    
    //  공연 후기 버튼 액션
    @objc func pressedReviewBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.4 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.animationUIView.frame.origin.x = self.reviewBtn.frame.origin.x
            
        }, completion: nil )
        
        self.animationUIView.layoutIfNeeded()
        selectMenu( self.reviewBtn )
    }
    
    //  더보기 버튼 액션
    @objc func pressedMoreImageBtn( _ sender : UIButton ) {
        
        if( reservationUIView.isHidden == false ) { //  공연 신청 현황
            
            guard let reservationDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationDetailViewController") as? ReservationDetailViewController else { return }
            
            reservationDetailVC.memberInfo = self.memberInfo
            reservationDetailVC.selectMemberNickname = self.selectMemberNickname
            reservationDetailVC.memberInfoReservation = self.memberInfoReservation
            
            self.present( reservationDetailVC , animated: false , completion: nil )
            
        } else if( followingScheduleUIView.isHidden == false ) { //  팔로잉 일정
            
        } else {    //  공연 후기
            
            
        }
    }
    
    //  멤버 정보 가져오기
    func getShowMemberInfo() {
        
        Server.reqMemberInfoBasic(member_nickname: self.selectMemberNickname!) { ( memberInfoBasicData, rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberInfoBasic = memberInfoBasicData
                
                if( self.memberInfoBasic?.member_profile != nil ) {
                    
                    let tmpProfile = self.getStoS( (self.memberInfoBasic?.member_profile)! )
                    
                    self.memberProfileImageView.kf.setImage(with: URL( string: tmpProfile ) )
                    self.memberProfileImageView.layer.cornerRadius = self.memberProfileImageView.layer.frame.width/2
                    self.memberProfileImageView.clipsToBounds = true
                    
                } else {
                    self.memberProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
                }
                
                self.memberNicknameLabel.text = self.memberInfoBasic?.member_nickname
                
                if( self.memberInfoBasic?.member_category != "" ) {
                    let tmpCategory = self.getStoS( (self.memberInfoBasic?.member_category)! )
                    self.memberCategoryLabel.text = "# \(tmpCategory)"
                } else {
                    self.memberCategoryLabel.text = "# 관람객"
                }
                
                self.memberIntroductionTextView.text = self.memberInfoBasic?.member_introduction
                
                if let tmpFollowCnt = self.memberInfoBasic?.member_followCnt {
                    self.memberFollowCntLabel.text = String( tmpFollowCnt )
                }
                if let tmpFollowingCnt = self.memberInfoBasic?.member_followingCnt {
                    self.memberFollowingCntLabel.text = String( tmpFollowingCnt )
                }
                
                var starArr : [ UIImageView ] = [ self.memberStar1 , self.memberStar2 , self.memberStar3 , self.memberStar4 , self.memberStar5 ]
                let intScore : Int = Int( (self.memberInfoBasic?.member_score)! )

                for i in 0 ..< 5 {
                    
                    starArr[i].image = #imageLiteral(resourceName: "nonStar")
                }
                for i in 0 ..< intScore {
                    
                    starArr[i].image = #imageLiteral(resourceName: "star")
                }
                
                if let tmpScore = self.memberInfoBasic?.member_score {
                    self.memberScoreLabel.text = String( tmpScore )
                }
                
                
                if( self.memberInfoBasic?.member_type != "1" ) { //  관람객

                    //  배경사진 적용 서버에서 배경사진 가져오기 수정해야함
                    
                    self.followingScheduleBtn.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
                    self.followingScheduleUIView.isHidden = false
                    
                } else {    //  버스커
                    //  공연 신청 현황 서버 연동
                    //  공연 후기 서버 연동
                    
                    //  버스커 사진 서버 연동
                    
                    self.getMemberInfoReservation()
                    
                    self.reservationInfoBtn.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
                    self.reservationUIView.isHidden = false
                }
                
                self.getMemberInfoFollowingReservation()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    //  팔로잉 하는지 확인
    func getisFollowing() {
        
        Server.reqIsFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)! , member_following_nickname: (self.selectMemberNickname)!) { (rescode ) in
            
            if( rescode == 201 ) {  //  팔로잉 하는중
                self.memberSetBtn.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            } else if( rescode == 401 ) {   //  팔로잉 안함
                self.memberSetBtn.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
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
        
        Server.reqMemberInfoReservation(member_nickname: (self.memberInfoBasic?.member_nickname)! , r_date: self.todayDateTime! ) { ( memberReservationData , rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberInfoReservation = memberReservationData
                self.reservationCollectionView.reloadData()
                
                if( self.memberInfoReservation.count != 0 ) {
                    self.reservationNothingLabel.text = "예약된 공연 일정이 없습니다"
                    self.reservationNothingLabel.isHidden = true
                } else {
                    self.reservationNothingLabel.isHidden = false
                }
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    //  팔로잉 멤버들의 공연 일정 가져오기
    func getMemberInfoFollowingReservation() {
        
        Server.reqMemberInfoFollowingReservation(member_nickname: (self.memberInfoBasic?.member_nickname)!, r_date: self.todayDateTime!) { ( memberFollowingReservationData , rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberInfoFollowingReservation = memberFollowingReservationData
                self.followingScheduleCollectionView.reloadData()
                
                if( self.memberInfoFollowingReservation.count != 0 ) {
                    self.followingNothingLabel.text = "예약된 공연 일정이 없습니다"
                    self.followingNothingLabel.isHidden = true
                } else {
                    self.followingNothingLabel.isHidden = false
                }
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
        
    }
    
    //  메뉴 디폴트 설정
    func selectMenu( _ sender : UIButton ) {
        
        reservationInfoBtn.setTitleColor( #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1) , for: .normal )
        followingScheduleBtn.setTitleColor( #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1) , for: .normal )
        reviewBtn.setTitleColor( #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1) , for: .normal )
        
        reservationUIView.isHidden = true
        followingScheduleUIView.isHidden = true
        reviewUIView.isHidden = true
        
        sender.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
        
        if( sender == self.reservationInfoBtn ) {
            reservationUIView.isHidden = false
            if( self.memberInfoBasic?.member_type == "0" ) {
                reservationNothingLabel.text = "버스커가 아닙니다"
                reservationNothingLabel.isHidden = false
            }
        } else if( sender == self.followingScheduleBtn ) {
            followingScheduleUIView.isHidden = false
        } else {
            reviewUIView.isHidden = false
            if( self.memberInfoBasic?.member_type == "0" ) {
                reviewNothingLabel.text = "버스커가 아닙니다"
                reviewNothingLabel.isHidden = false
            }
        }
        
    }
    
//  Mark -> delegate

    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if( collectionView == reservationCollectionView ) {
            
            if( memberInfoReservation.count >= 3 ) {
                return 3
            } else {
                return memberInfoReservation.count
            }
        } else if( collectionView == followingScheduleCollectionView ) {
            if( memberInfoFollowingReservation.count >= 3 ) {
                return 3
            } else {
                return memberInfoFollowingReservation.count
            }
        } else {
            return 0
        }
    }

    //  cell 의 내용

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if( collectionView == reservationCollectionView ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyReservationCollectionViewCell", for: indexPath ) as! MyReservationCollectionViewCell
            
            let tmpDate = String( memberInfoReservation[ indexPath.row ].r_date )
//            let tmpYear : String = String(tmpDate[ tmpDate.startIndex ..< tmpDate.index(tmpDate.startIndex , offsetBy: 4) ])
            let tmpMonth : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 4) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 6) ] )
            let tmpDay : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 6) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 8) ] )
            
            cell.myReservationFirstUIView.layer.cornerRadius = cell.myReservationFirstUIView.layer.frame.width/2
            cell.myReservationDateLabel.text = "\(tmpMonth)/\(tmpDay)"
            cell.myReservationTimeLabel.text = "\(gino( memberInfoReservation[ indexPath.row ].r_startTime )) : 00 - \(gino( memberInfoReservation[ indexPath.row ].r_endTime )) : 00"
            cell.myReservationZoneNameLabel.text = memberInfoReservation[ indexPath.row ].sbz_name
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowingScheduleCollectionViewCell", for: indexPath ) as! FollowingScheduleCollectionViewCell
            
            let tmpDate = String( memberInfoFollowingReservation[ indexPath.row ].r_date )
            //            let tmpYear : String = String(tmpDate[ tmpDate.startIndex ..< tmpDate.index(tmpDate.startIndex , offsetBy: 4) ])
            let tmpMonth : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 4) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 6) ] )
            let tmpDay : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 6) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 8) ] )
            
            cell.followingFirstUIView.layer.cornerRadius = cell.followingFirstUIView.layer.frame.width/2
            cell.followingDateLabel.text = "\(tmpMonth)/\(tmpDay)"
            cell.followingTimeLabel.text = "\(gino( memberInfoFollowingReservation[ indexPath.row ].r_startTime )) : 00 - \(gino( memberInfoFollowingReservation[ indexPath.row ].r_endTime )) : 00"
            
            if( memberInfoFollowingReservation[ indexPath.row ].member_profile != nil ) {
                
                cell.followingProfileImageView.kf.setImage( with: URL( string:gsno(memberInfoFollowingReservation[ indexPath.row ].member_profile ) ) )
                cell.followingProfileImageView.layer.cornerRadius = cell.followingProfileImageView.layer.frame.width/2
                cell.followingProfileImageView.clipsToBounds = true
                
            } else {
                
                cell.followingProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
            
            cell.followingNicknameLabel.text = memberInfoFollowingReservation[ indexPath.row ].member_nickname
            
            return cell
        }
    }

    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if( collectionView == reservationCollectionView ) {
            
        } else if( collectionView == followingScheduleCollectionView ) {
            
        } else {
            
        }
    }

    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if( collectionView == reservationCollectionView ) {
            return CGSize(width: 375 * self.view.frame.width/375 , height: 27 * self.view.frame.height/667 )
        } else if( collectionView == followingScheduleCollectionView ) {
            return CGSize(width: 375 * self.view.frame.width/375 , height: 27 * self.view.frame.height/667 )
        } else {
            return CGSize(width: 375 * self.view.frame.width/375 , height: 45 * self.view.frame.height/667 )
        }
    }

    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if( collectionView == reservationCollectionView ) {
            return 15 * self.view.frame.width/375
        } else if( collectionView == followingScheduleCollectionView ) {
            return 15 * self.view.frame.width/375
        } else {
            return 21 * self.view.frame.width/375
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if( collectionView == reservationCollectionView ) {
            return 15 * self.view.frame.height/667
        } else if( collectionView == followingScheduleCollectionView ) {
            return 15 * self.view.frame.height/667
        } else {
            return 21 * self.view.frame.height/667
        }
    }
}















