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
    @IBOutlet weak var memberBackProfileImageView: UIImageView!
    @IBOutlet weak var memberProfileImageView: UIImageView!
    @IBOutlet weak var memberSetBtn: UIButton!
    @IBOutlet weak var memberNicknameLabel: UILabel!
    @IBOutlet weak var memberCategoryLabel: UILabel!
    @IBOutlet weak var memberIntroductionTextView: UITextView!
    @IBOutlet weak var memberFollowingBtn: UIButton!
    @IBOutlet weak var memberFollowingCntLabel: UILabel!
    @IBOutlet weak var memberFollowBtn: UIButton!
    @IBOutlet weak var memberFollowCntLabel: UILabel!
    @IBOutlet weak var memberStar1: UIImageView!
    @IBOutlet weak var memberStar2: UIImageView!
    @IBOutlet weak var memberStar3: UIImageView!
    @IBOutlet weak var memberStar4: UIImageView!
    @IBOutlet weak var memberStar5: UIImageView!
    @IBOutlet weak var memberScoreLabel: UILabel!
    @IBOutlet weak var scoreUIView: UIView!
    
    
    //  애니메이션바
    @IBOutlet weak var animationUIView: UIView!
    
    //  어느것 눌렀는지 확인
    var flag : Int = -1 //  처음에는 -1
    
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
    var memberReviewList : [ MemberReview ] = [ MemberReview ]()  //  멤버 리뷰 서버
    var memberScore : Double = 0
    var reviewTotalCnt : Int = 0    //  리뷰 전체 개수
    var reviewScoreCnt : [ Int ] = [ Int ]()    //  리뷰 각각 점수 개수
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
    var uiviewX : CGFloat?
    
    var year = calendar.component(.year, from: date)
    var month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let hour = calendar.component(.hour, from: date)
    var todayDateTime : Int?    //  선택한년월일 ex ) 2018815
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setTarget()
        setDelegate()
        setTapbarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        getMemberInfo()
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
            self.memberSetBtn.setImage( #imageLiteral(resourceName: "follow") , for: .normal)
            getisFollowing()
        }
        
        if( self.view.frame.height > 667 ) {
            animationUIView.frame = CGRect(x: 22 , y: 441, width: 121.67 , height: 3 )
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
        
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  백 버튼
        memberInfoBackBtn.addTarget(self, action: #selector(self.pressedMemberInfoBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  오른쪽 버튼
        memberInfoRightBtn.addTarget(self, action: #selector(self.pressedMemberInfoRightBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  배경화면 이미지
        let tapBackgroundImage = UITapGestureRecognizer(target: self , action: #selector( self.pressedMemberBackProfileImageView(_:) ))
        memberBackProfileImageView.isUserInteractionEnabled = true
        memberBackProfileImageView.addGestureRecognizer(tapBackgroundImage)
        
        //  프로필 이미지
        let tapProfileImage = UITapGestureRecognizer(target: self , action: #selector( self.pressedMemberProfileImageView(_:) ))
        memberProfileImageView.isUserInteractionEnabled = true
        memberProfileImageView.addGestureRecognizer(tapProfileImage)
        
        //  ( 프로필수정 , 팔로잉 ) 버튼 클릭
        memberSetBtn.addTarget(self, action: #selector(self.pressedMemberSetBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  팔로잉 리스트 버튼
        memberFollowingBtn.addTarget(self, action: #selector(self.pressedMemberFollowingBtn(_:)), for: UIControlEvents.touchUpInside)
        let tapFollowingList = UITapGestureRecognizer(target: self , action: #selector( self.pressedMemberFollowingBtn(_:) ))
        memberFollowingCntLabel.isUserInteractionEnabled = true
        memberFollowingCntLabel.addGestureRecognizer(tapFollowingList)
        
        //  팔로워 리스트 버튼
        memberFollowBtn.addTarget(self, action: #selector(self.pressedMemberFollowBtn(_:)), for: UIControlEvents.touchUpInside)
        let tapFollowList = UITapGestureRecognizer(target: self , action: #selector( self.pressedMemberFollowBtn(_:) ))
        memberFollowCntLabel.isUserInteractionEnabled = true
        memberFollowCntLabel.addGestureRecognizer(tapFollowList)
        
        //  스타 , 점수
        let tapReviewStar = UITapGestureRecognizer(target: self , action: #selector( self.pressedScoreUIView(_:) ))
        scoreUIView.isUserInteractionEnabled = true
        scoreUIView.addGestureRecognizer(tapReviewStar)
        
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
        
        //  리뷰 없을때 누를경우 버튼
        let tapNothingReviewLabel = UITapGestureRecognizer(target: self , action: #selector( self.pressedReviewNothingLabel(_:) ))
        reviewNothingLabel.isUserInteractionEnabled = true
        reviewNothingLabel.addGestureRecognizer(tapNothingReviewLabel)
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
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        memberInfoVC.memberInfo = self.memberInfo
        
        self.present( memberInfoVC , animated: false , completion: nil )
        
    }
    
    //  오른쪽 버튼
    @objc func pressedMemberInfoRightBtn( _ sender : UIButton ) {
        
        if( self.memberInfoRightBtn.image(for: .normal ) == #imageLiteral(resourceName: "setting") ) {
            
            guard let settingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return }
            
            settingVC.memberInfo = self.memberInfo
            
            settingVC.selectMemberNickname = self.selectMemberNickname
            settingVC.uiviewX = self.tapbarMemberInfoBtn.frame.origin.x
            
            self.present( settingVC , animated: true , completion: nil )
            
        } else {
            
            guard let reportVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController else { return }
            
            reportVC.memberInfo = self.memberInfo
            reportVC.selectMemberNickname = self.selectMemberNickname
            reportVC.uiviewX = self.tapbarMemberInfoBtn.frame.origin.x
            
            self.present( reportVC , animated: true , completion: nil )
        }
    }
    
    //  배경화면 이미지 액션
    @objc func pressedMemberBackProfileImageView( _ sender : UIImageView ) {
        
        guard let profileDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileDetailViewController") as? ProfileDetailViewController else { return }
        
        profileDetailVC.detailImage = memberBackProfileImageView.image
        
        self.present( profileDetailVC , animated: false , completion: nil )
    }
    
    //  프로필 이미지 액션
    @objc func pressedMemberProfileImageView( _ sender : UIImageView ) {
        
        guard let profileDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileDetailViewController") as? ProfileDetailViewController else { return }
        
        profileDetailVC.detailImage = memberProfileImageView.image
        
        self.present( profileDetailVC , animated: false , completion: nil )
    }
    
    //  ( 프로필 수정 , 팔로잉 ) 버튼 액션
    @objc func pressedMemberSetBtn( _ sender : UIButton ) {
        
        print(1111)
        if( memberInfo?.member_nickname == memberInfoBasic?.member_nickname ) {
            print(22)
            guard let modifyProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModifyProfileViewController") as? ModifyProfileViewController else { return }
            
            modifyProfileVC.memberInfo = self.memberInfo
            modifyProfileVC.memberInfoBasic = self.memberInfoBasic
            modifyProfileVC.uiviewX = self.tapbarMemberInfoBtn.frame.origin.x
            print(33)
            self.present( modifyProfileVC , animated: false , completion: nil )
            
        } else {
            
            Server.reqFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)!, member_following_nickname: self.selectMemberNickname! ) { (rescode , flag ) in
                
                if( rescode == 201 ) {
                    
                    if( flag == 1 ) {
                        
                        guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                        
                        defaultPopUpVC.content = "팔로잉 완료"
                        
                        self.addChildViewController( defaultPopUpVC )
                        defaultPopUpVC.view.frame = self.view.frame
                        self.view.addSubview( defaultPopUpVC.view )
                        defaultPopUpVC.didMove(toParentViewController: self )
                        
                        sender.setImage(#imageLiteral(resourceName: "following") , for: .normal )
                        self.memberFollowCntLabel.text = String( Int( self.memberFollowCntLabel.text! )! + 1 )
                        
                    } else if( flag == 0 ) {
                        
                        guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                        
                        defaultPopUpVC.content = "언팔로우 완료"
                        
                        self.addChildViewController( defaultPopUpVC )
                        defaultPopUpVC.view.frame = self.view.frame
                        self.view.addSubview( defaultPopUpVC.view )
                        defaultPopUpVC.didMove(toParentViewController: self )
                        
                        sender.setImage(#imageLiteral(resourceName: "follow")  , for: .normal )
                        self.memberFollowCntLabel.text = String( Int( self.memberFollowCntLabel.text! )! - 1 )
                    }
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
        }
    }
    
    //  멤버 팔로잉 리스트 버튼 액션
    @objc func pressedMemberFollowingBtn( _ sender : UIButton ) {
        
        if( memberFollowingCntLabel.text != "0" ) {
            
            guard let followingMemberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowingMemberViewController") as? FollowingMemberViewController else { return }
            
            followingMemberVC.memberInfo = self.memberInfo
            followingMemberVC.selectMemberNickname = self.selectMemberNickname
            followingMemberVC.type = 0
            
            self.present( followingMemberVC , animated: false , completion: nil )
            
        } else {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "팔로잉 멤버가 없습니다"
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
        }
    }
    
    //  멤버 팔로워 리스트 버튼 액션
    @objc func pressedMemberFollowBtn( _ sender : UIButton ) {
        
        if( memberFollowCntLabel.text != "0" ) {
            
            guard let followingMemberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowingMemberViewController") as? FollowingMemberViewController else { return }
            
            followingMemberVC.memberInfo = self.memberInfo
            followingMemberVC.selectMemberNickname = self.selectMemberNickname
            followingMemberVC.type = 1
            
            self.present( followingMemberVC , animated: false , completion: nil )
            
        } else {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "팔로워 멤버가 없습니다"
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
        }
        
    }
    
    //  스타 & 점수 뷰 액션
    @objc func pressedScoreUIView( _ sender : UIView ) {
        
        if( memberInfoBasic?.member_type == "1" ) {
            
            guard let reviewDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewDetailViewController") as? ReviewDetailViewController else { return }
            
            reviewDetailVC.memberInfo = self.memberInfo
            reviewDetailVC.selectMemberNickname = self.selectMemberNickname
            
            self.present( reviewDetailVC , animated: false , completion: nil )
            
        } else {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "버스커가 아닙니다"
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
        }
    }
    
    //  공연 신청 현황 버튼 액션
    @objc func pressedReservationInfoBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            self.animationUIView.frame.origin.x = self.reservationInfoBtn.frame.origin.x
            
            
        }, completion: nil )
        
        self.animationUIView.layoutIfNeeded()
        selectMenu( self.reservationInfoBtn )
        self.flag = 0
    }
    
    //  팔로잉 일정 버튼 액션
    @objc func pressedFollowingScheduleBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.animationUIView.frame.origin.x = self.followingScheduleBtn.frame.origin.x
            
        }, completion: nil )
        
        self.animationUIView.layoutIfNeeded()
        selectMenu( self.followingScheduleBtn )
        self.flag = 1
    }
    
    //  공연 후기 버튼 액션
    @objc func pressedReviewBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.animationUIView.frame.origin.x = self.reviewBtn.frame.origin.x
            
        }, completion: nil )
        
        self.animationUIView.layoutIfNeeded()
        selectMenu( self.reviewBtn )
        self.flag = 2
    }
    
    //  더보기 버튼 액션
    @objc func pressedMoreImageBtn( _ sender : UIButton ) {
        
        if( reservationUIView.isHidden == false ) { //  공연 신청 현황
            
            if( reservationNothingLabel.isHidden == true  ) {
                
                guard let reservationDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationDetailViewController") as? ReservationDetailViewController else { return }
                
                reservationDetailVC.memberInfo = self.memberInfo
                reservationDetailVC.selectMemberNickname = self.selectMemberNickname
                
                self.present( reservationDetailVC , animated: false , completion: nil )
                
            } else {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "공연 신청 현황이 없습니다"
                
                self.addChildViewController( defaultPopUpVC )
                defaultPopUpVC.view.frame = self.view.frame
                self.view.addSubview( defaultPopUpVC.view )
                defaultPopUpVC.didMove(toParentViewController: self )
                
            }
            
            
        } else if( followingScheduleUIView.isHidden == false ) { //  팔로잉 일정
            
            if( followingNothingLabel.isHidden == true  ) {
                
                guard let followingDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowingDetailViewController") as? FollowingDetailViewController else { return }
                
                followingDetailVC.memberInfo = self.memberInfo
                followingDetailVC.memberInfoBasic = self.memberInfoBasic
                
                self.present( followingDetailVC , animated: false , completion: nil )
                
            } else {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "팔로잉 일정이 없습니다"
                
                self.addChildViewController( defaultPopUpVC )
                defaultPopUpVC.view.frame = self.view.frame
                self.view.addSubview( defaultPopUpVC.view )
                defaultPopUpVC.didMove(toParentViewController: self )
                
            }

        } else {    //  공연 후기
            
            if( memberInfoBasic?.member_type == "1" ) {
                
                guard let reviewDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewDetailViewController") as? ReviewDetailViewController else { return }
                
                reviewDetailVC.memberInfo = self.memberInfo
                reviewDetailVC.selectMemberNickname = self.selectMemberNickname
                
                self.present( reviewDetailVC , animated: false , completion: nil )
                
            } else {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "버스커가 아닙니다"
                
                self.addChildViewController( defaultPopUpVC )
                defaultPopUpVC.view.frame = self.view.frame
                self.view.addSubview( defaultPopUpVC.view )
                defaultPopUpVC.didMove(toParentViewController: self )
            }
        }
    }
    
    //  리뷰 없을때 버튼 액션
    @objc func pressedReviewNothingLabel( _ sender : UIButton ) {
        
        if( memberInfoBasic?.member_type == "1" ) {
            
            guard let reviewDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewDetailViewController") as? ReviewDetailViewController else { return }
            
            reviewDetailVC.memberInfo = self.memberInfo
            reviewDetailVC.selectMemberNickname = self.selectMemberNickname
            
            self.present( reviewDetailVC , animated: false , completion: nil )
            
        } else {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "버스커가 아닙니다"
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
        }
    }
    
    //  멤버 정보 memberInfo 업데이트
    func getMemberInfo() {
        
        if( self.memberInfo?.member_nickname == self.selectMemberNickname ) {
            
            Server.reqMemberInfoRe(member_ID: (self.memberInfo?.member_ID)!) { (memberInfoReData , rescode ) in
                
                if( rescode == 201 ) {
                    
                    self.memberInfo = memberInfoReData
                    self.selectMemberNickname = self.getStoS( (self.memberInfo?.member_nickname)! )
                    
                    self.getShowMemberInfo()
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
            
        } else {
            self.getShowMemberInfo()
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
                
                
                //  수정 -> 배경화면
                if( self.memberInfoBasic?.member_backProfile != nil ) {
                    
                    let tmpProfile = self.getStoS( (self.memberInfoBasic?.member_backProfile)! )
                    
                    self.memberBackProfileImageView.kf.setImage(with: URL( string: tmpProfile ) )
                    
                } else {
                    self.memberBackProfileImageView.backgroundColor = #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1)
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
                
                if( self.memberInfoBasic?.member_type != "1" ) { //  관람객 디폴트 설정
                    
                    self.scoreUIView.isHidden = true
                    
                    if( self.flag == -1 ) {
                        
                        UIView.animate(withDuration: 1.5 , delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .curveEaseOut , animations: {
                            
                            self.animationUIView.frame.origin.x = self.followingScheduleBtn.frame.origin.x
                            
                        }, completion: nil )
                        self.animationUIView.layoutIfNeeded()
                        
                        //  배경사진 적용 서버에서 배경사진 가져오기 수정해야함
                        
                        self.followingScheduleBtn.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
                        self.followingScheduleUIView.isHidden = false
                        self.flag = 1
                    }
                } else {
                    
                    self.scoreUIView.isHidden = false
                    
                    if( self.flag == -1 ) {
                        
                        self.reservationInfoBtn.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
                        self.reservationUIView.isHidden = false
                        self.flag = 0
                    }
                    
                    self.getMemberInfoReservation()
                    self.getReviewList()
                    
                    //  버스커 사진 서버 연동
                    
                }
                
                //  공통
                self.getMemberInfoFollowingReservation()
                
                if( self.flag == 0 ) {
                    
                    self.reservationInfoBtn.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
                    self.reservationUIView.isHidden = false
                    
                } else if( self.flag == 1 ) {
                    
                    self.followingScheduleBtn.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
                    self.followingScheduleUIView.isHidden = false
                    
                } else {
                    
                    self.reviewBtn.setTitleColor( #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1) , for: .normal )
                    self.reviewUIView.isHidden = false
                }
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
                self.memberSetBtn.setImage(#imageLiteral(resourceName: "following") , for: .normal)
            } else if( rescode == 401 ) {   //  팔로잉 안함
                self.memberSetBtn.setImage( #imageLiteral(resourceName: "follow") , for: .normal)
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
                    self.reservationNothingLabel.isHidden = true
                } else {
                    self.reservationNothingLabel.text = "예약된 공연 일정이 없습니다"
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
                    self.followingNothingLabel.isHidden = true
                } else {
                    self.followingNothingLabel.text = "예약된 공연 일정이 없습니다"
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
    
    //  리뷰 가져오기
    func getReviewList() {
        
        Server.reqMemberReviewList(review_toNickname: self.selectMemberNickname!) { ( memberReviewData , score  , totalCnt , scoreCnt , rescode ) in
            
            if( rescode == 200 ) {
                
                self.memberReviewList = memberReviewData
                self.memberScore = score
                self.reviewTotalCnt = totalCnt
                self.reviewScoreCnt = scoreCnt
                
                self.reviewCollectionView.reloadData()
                
                if( self.memberReviewList.count != 0 ) {
                    
                    self.reviewNothingLabel.isHidden = true
                    
                } else {
                    
                    self.reviewNothingLabel.text = "리뷰가 없습니다( 첫 리뷰를 남겨보세요 )"
                    self.reviewNothingLabel.isHidden = false
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

            return memberInfoReservation.count
//            if( memberInfoReservation.count >= 3 ) {
//                return 3
//            } else {
//                return memberInfoReservation.count
//            }
        } else if( collectionView == followingScheduleCollectionView ) {
            
            return memberInfoFollowingReservation.count
//            if( memberInfoFollowingReservation.count >= 3 ) {
//                return 3
//            } else {
//                return memberInfoFollowingReservation.count
//            }
        } else {
            
            return memberReviewList.count
//            if( memberReviewList.count >= 2 ) {
//                return 2
//            } else {
//                return memberReviewList.count
//            }
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
            
            cell.myReservationTimeLabel.text = "\(gino( memberInfoReservation[ indexPath.row ].r_startTime )) : \(resultStartMin) - \(gino( memberInfoReservation[ indexPath.row ].r_endTime )) : \(resultEndMin)"
            
            cell.myReservationZoneNameLabel.text = memberInfoReservation[ indexPath.row ].sbz_name
            
            return cell
            
        } else if( collectionView == followingScheduleCollectionView ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowingScheduleCollectionViewCell", for: indexPath ) as! FollowingScheduleCollectionViewCell
            
            let tmpDate = String( memberInfoFollowingReservation[ indexPath.row ].r_date )
            //            let tmpYear : String = String(tmpDate[ tmpDate.startIndex ..< tmpDate.index(tmpDate.startIndex , offsetBy: 4) ])
            let tmpMonth : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 4) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 6) ] )
            let tmpDay : String = String(tmpDate[ tmpDate.index(tmpDate.startIndex, offsetBy: 6) ..< tmpDate.index(tmpDate.startIndex, offsetBy: 8) ] )
            
            cell.followingFirstUIView.layer.cornerRadius = cell.followingFirstUIView.layer.frame.width/2
            cell.followingDateLabel.text = "\(tmpMonth)/\(tmpDay)"

            var resultStartMin : String = "0"
            var resultEndMin : String = "0"
            let startmin : Int = gino( memberInfoFollowingReservation[ indexPath.row ].r_startMin )
            let tmpStartMin = String( startmin )
            let endMin : Int = gino( memberInfoFollowingReservation[ indexPath.row ].r_endMin )
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
            
            cell.followingTimeLabel.text = "\(gino( memberInfoFollowingReservation[ indexPath.row ].r_startTime )) : \(resultStartMin) - \(gino( memberInfoFollowingReservation[ indexPath.row ].r_endTime )) : \(resultEndMin)"
            
            if( memberInfoFollowingReservation[ indexPath.row ].member_profile != nil ) {
                
                cell.followingProfileImageView.kf.setImage( with: URL( string:gsno(memberInfoFollowingReservation[ indexPath.row ].member_profile ) ) )
                cell.followingProfileImageView.layer.cornerRadius = cell.followingProfileImageView.layer.frame.width/2
                cell.followingProfileImageView.clipsToBounds = true
                
            } else {
                
                cell.followingProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
            
            cell.followingNicknameLabel.text = memberInfoFollowingReservation[ indexPath.row ].member_nickname
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath ) as! ReviewCollectionViewCell
            
            cell.reviewTitleLabel.text = memberReviewList[ indexPath.row ].review_title
            cell.reviewDateLabel.text = memberReviewList[ indexPath.row ].review_uploadtime
            
            let starArr = [ cell.reviewStar1 , cell.reviewStar2 , cell.reviewStar3 , cell.reviewStar4 , cell.reviewStar5 ]
            let starCnt = memberReviewList[ indexPath.row ].review_score
            
            for i in 0 ..< 5 {
                starArr[i]?.image = #imageLiteral(resourceName: "nonStar")
            }
            for i in 0 ..< starCnt! {
                starArr[i]?.image = #imageLiteral(resourceName: "star")
            }
            
            cell.reviewNicknameLabel.text = memberReviewList[ indexPath.row ].review_fromNickname
            
            if( memberReviewList[ indexPath.row ].member_profile != nil ) {
                
                cell.reviewProfileImageView.kf.setImage( with: URL( string:gsno(memberReviewList[ indexPath.row ].member_profile ) ) )
                cell.reviewProfileImageView.layer.cornerRadius = cell.reviewProfileImageView.layer.frame.width/2
                cell.reviewProfileImageView.clipsToBounds = true
                
            } else {
                
                cell.reviewProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
            
            return cell
        }
    }

    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if( collectionView == reservationCollectionView ) {
            
            if( reservationNothingLabel.isHidden == true  ) {
                
                guard let reservationDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationDetailViewController") as? ReservationDetailViewController else { return }
                
                reservationDetailVC.memberInfo = self.memberInfo
                reservationDetailVC.selectMemberNickname = self.selectMemberNickname
                
                self.present( reservationDetailVC , animated: false , completion: nil )
                
            } else {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "공연 신청 현황이 없습니다"
                
                self.addChildViewController( defaultPopUpVC )
                defaultPopUpVC.view.frame = self.view.frame
                self.view.addSubview( defaultPopUpVC.view )
                defaultPopUpVC.didMove(toParentViewController: self )
                
            }
        } else if( collectionView == followingScheduleCollectionView ) {
            
            if( followingNothingLabel.isHidden == true  ) {
                
                guard let followingDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowingDetailViewController") as? FollowingDetailViewController else { return }
                
                followingDetailVC.memberInfo = self.memberInfo
                followingDetailVC.memberInfoBasic = self.memberInfoBasic
                
                self.present( followingDetailVC , animated: false , completion: nil )
                
            } else {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "팔로잉 일정이 없습니다"
                
                self.addChildViewController( defaultPopUpVC )
                defaultPopUpVC.view.frame = self.view.frame
                self.view.addSubview( defaultPopUpVC.view )
                defaultPopUpVC.didMove(toParentViewController: self )
                
            }
        } else {
            
            if( memberInfoBasic?.member_type == "1" ) {
                
                guard let reviewDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewDetailViewController") as? ReviewDetailViewController else { return }
                
                reviewDetailVC.memberInfo = self.memberInfo
                reviewDetailVC.selectMemberNickname = self.selectMemberNickname
                
                self.present( reviewDetailVC , animated: false , completion: nil )
                
            } else {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "버스커가 아닙니다"
                
                self.addChildViewController( defaultPopUpVC )
                defaultPopUpVC.view.frame = self.view.frame
                self.view.addSubview( defaultPopUpVC.view )
                defaultPopUpVC.didMove(toParentViewController: self )
            }
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
    
    func getItoI( _ sender : Int ) -> Int {
        
        let result = gino( sender )
        return result
        
    }
    
    func getStoS( _ sender : String ) -> String {
        
        let result = gsno( sender )
        return result
    }
}















