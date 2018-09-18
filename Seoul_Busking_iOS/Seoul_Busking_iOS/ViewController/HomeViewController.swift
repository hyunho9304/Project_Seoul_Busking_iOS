//
//  HomeViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 5..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    
    //  유저 info
    var memberInfo : Member?                                        //  회원정보
    var memberRepresentativeBorough : MemberRepresentativeBorough?  //  회원 대표 자치구 index & name
    
    
    //  네비게이션 바
    @IBOutlet weak var homeStarImageView: UIImageView!
    @IBOutlet weak var homeRepresentativeBoroughLabel: UILabel!      //  현재 띄우고 있는 자치구
    @IBOutlet weak var homeBoroughBtn: UIButton!                //  자치구 선택 버튼
    @IBOutlet weak var homeBuskingReservationBtn: UIButton!     //  버스킹예약 버튼
    @IBOutlet weak var homeRankingBtn: UIButton!    //  랭킹 버튼
    var homeSelectBoroughIndex : Int?                           //  현재 선택된 자치구 index        select 해야 값 있다
    var homeSelectBoroughName : String?                        //   현재 선택된 자치구 name
    var homeSelectedLongitude : Double?                           //  현재 선택된 logitude
    var homeSelectedLatitude : Double?                            //  현재 선택된 latitude
    
    //  달력
    @IBOutlet weak var homeCalendarUIView: UIView!
    @IBOutlet weak var homeCalendarCollectionView: UICollectionView!
    var calendar : CustomCalendar?        //  서버 달력 데이터
    var calendarSelectedIndex:IndexPath?    //  선택고려
    var selectYear : String?        //  선택한 년도
    var selectMonth : String?       //  선택한 월
    var selectDate : String?        //  선택한 일
    var selectDay : String?         //  선택한 요일
    var selectDateTime : Int?    //  선택한년월일 ex ) 2018815
    
    //  버스킹 존
    @IBOutlet weak var homeBuskingZoneCollectionView: UICollectionView!
    var buskingZoneList : [ BuskingZone ] = [ BuskingZone ]()  //  서버 버스킹 존 데이터
    var busingZoneSelectedIndex:IndexPath?                     //  선택고려
    var selectZoneIndex : Int?                                 //  선택한 버스킹 존 인덱스
    var selectZoneName : String?                               //  선택한 버스킹 존 이름
    var selectZoneImage : String?                              //  선택한 버스킹 존 이미지
    @IBOutlet weak var nothingZone: UILabel!
    
    
    @IBOutlet weak var reservationNowBtn: UIButton!
    
    
    //  예약 공연 목록
    @IBOutlet weak var homeReservationCollectionView: UICollectionView!
    var reservationList : [ Reservation ] = [ Reservation ]()   //  서버 예약 목록 데이터
    @IBOutlet weak var nothingReservation: UILabel!
    var refresher : UIRefreshControl?
    
    //  tap bar
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    var uiviewX : CGFloat?                              //  텝바 선택 애니메이션 위한 x 좌표
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        set()
        setDelegate()
        setTarget()
        setTapbarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        dateTimeInit()
        getMemberRepresentativeBoroughData()
    }
    
    
    func getMemberRepresentativeBoroughData() {
        
        Server.reqMemberRepresentativeBorough(member_nickname: (memberInfo?.member_nickname)!) { ( memberRepresentativeBoroughData , rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberRepresentativeBorough = memberRepresentativeBoroughData
                
                var tmp : Int?
                if( self.homeSelectBoroughIndex == nil ) {
                    
                    tmp = self.memberRepresentativeBorough?.sb_id
                    
                    self.homeRepresentativeBoroughLabel.text = self.memberRepresentativeBorough?.sb_name
                    self.homeSelectBoroughIndex = self.memberRepresentativeBorough?.sb_id
                    self.homeSelectBoroughName = self.memberRepresentativeBorough?.sb_name
                    self.homeSelectedLongitude = self.memberRepresentativeBorough?.sb_longitude
                    self.homeSelectedLatitude = self.memberRepresentativeBorough?.sb_latitude
                    
                    
                } else {
                    
                    tmp = self.homeSelectBoroughIndex
                    
                    self.homeRepresentativeBoroughLabel.text = self.homeSelectBoroughName
                    
                }
                
                if( self.memberRepresentativeBorough?.sb_id == self.homeSelectBoroughIndex ) {
                    
                    self.homeStarImageView.image = #imageLiteral(resourceName: "likeCopy.png")
                } else {
                    
                    self.homeStarImageView.image = #imageLiteral(resourceName: "likeCopy2")
                }
                
                Server.reqBuskingZoneList(sb_id: ( tmp )! ) { ( buskingZoneListData , rescode ) in
                    
                    if rescode == 200 {
                        
                        self.buskingZoneList = buskingZoneListData
                        self.homeBuskingZoneCollectionView.reloadData()
                        
                        if( self.buskingZoneList.count != 0 ) {
                            
                            self.nothingZone.isHidden = true
                            
                            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                            self.collectionView( self.homeBuskingZoneCollectionView, didSelectItemAt: indexPathForFirstRow )
                        } else {
                            
                            self.nothingZone.isHidden = false
                        }
                        
                    } else {
                        
                        let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
                    }
                }
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    func set() {
        
        //  바로 데이터 안와서 딜레이준다
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            
            if( self.memberInfo?.member_type == "0" ) {
                
                self.homeBuskingReservationBtn.isHidden = true
            }
            
        })

        
        setShadow()
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        reloadTarget()
    }
    
    func reloadTarget() {
        
        refresher = UIRefreshControl()
        homeReservationCollectionView.alwaysBounceVertical = true
        refresher?.tintColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
        refresher?.addTarget( self , action : #selector( reloadData ) , for : .valueChanged )
        homeReservationCollectionView.addSubview( refresher! )
    }
    
    @objc func reloadData() {
        
        self.getReservationList()
        stopRefresher()
    }
    
    func stopRefresher() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            self.refresher?.endRefreshing()
        })
    }
    
    func setShadow() {
 
        //  달력 뷰
        homeCalendarUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        homeCalendarUIView.layer.shadowOpacity = 0.08                            //  그림자 투명도
        homeCalendarUIView.layer.shadowOffset = CGSize(width: 0 , height: 1 )    //  그림자 x y
        
        //  탭바 뷰
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
    }
    
    func setDelegate() {
        
        homeCalendarCollectionView.delegate = self
        homeCalendarCollectionView.dataSource = self
        
        homeBuskingZoneCollectionView.delegate = self
        homeBuskingZoneCollectionView.dataSource = self
        
        homeReservationCollectionView.delegate = self
        homeReservationCollectionView.dataSource = self
    }
    
    func setTarget() {

        //  지도 검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  대표 자치구 설정 버튼
        let tapSetRepresentativeBorough = UITapGestureRecognizer(target: self , action: #selector( HomeViewController.pressedHomeStarImageView(_:) ))
        homeStarImageView.isUserInteractionEnabled = true
        homeStarImageView.addGestureRecognizer(tapSetRepresentativeBorough)
        
        //  자치구 선택 버튼
        homeBoroughBtn.addTarget(self, action: #selector(self.pressedHomeBoroughBtn(_:)), for: UIControlEvents.touchUpInside)
        let tapBorough = UITapGestureRecognizer(target: self , action: #selector( HomeViewController.pressedHomeBoroughBtn(_:) ))
        homeRepresentativeBoroughLabel.isUserInteractionEnabled = true
        homeRepresentativeBoroughLabel.addGestureRecognizer(tapBorough)
        
        //  지금 예약하기 버튼
        reservationNowBtn.addTarget(self, action: #selector(self.pressedReservationNowBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  버스킹 예약 버튼
        homeBuskingReservationBtn.addTarget(self, action: #selector(self.pressedHomeBuskingReservationBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  랭킹 버튼
        homeRankingBtn.addTarget(self, action: #selector(self.pressedHomeRankingBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //  텝바 움직임 애니메이션
    func setTapbarAnimation() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
//
//            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
//
//                self.tapbarUIView.frame.origin.x = self.tapbarHomeBtn.frame.origin.x
//
//            }, completion: nil )
//        })
        
        UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.tapbarUIView.frame.origin.x = self.tapbarHomeBtn.frame.origin.x
            
        }, completion: nil )
    }
    
    //  지도 검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        
        
        
        mapVC.memberInfo = self.memberInfo
        mapVC.mapSelectedBoroughIndex = self.homeSelectBoroughIndex
        mapVC.mapSelectedBoroughName = self.homeSelectBoroughName
        mapVC.mapSelectedLongitude = self.homeSelectedLongitude
        mapVC.mapSelectedLatitude = self.homeSelectedLatitude
        

        
        self.present( mapVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        memberInfoVC.memberInfo = self.memberInfo
        
        self.present( memberInfoVC , animated: false , completion: nil )
        
    }
    
    //  대표자치구 설정 액션
    @objc func pressedHomeStarImageView( _ sender : UIImageView ) {

        if( memberRepresentativeBorough?.sb_id != self.homeSelectBoroughIndex ) {   //  변경 가능
            
            Server.reqUpdateMemberBorough(member_nickname: (memberInfo?.member_nickname)! , sb_id: homeSelectBoroughIndex!) { (rescode) in
                
                let boroughName : String = self.homeSelectBoroughName!
                
                if( rescode == 201 ) {
                    
                    self.homeStarImageView.image = #imageLiteral(resourceName: "likeCopy")
                    self.memberRepresentativeBorough?.sb_id = self.homeSelectBoroughIndex
                    
                    guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                    
                    defaultPopUpVC.content = "대표 자치구 [\(boroughName)] 변경 완료"
                    
                    self.addChildViewController( defaultPopUpVC )
                    defaultPopUpVC.view.frame = self.view.frame
                    self.view.addSubview( defaultPopUpVC.view )
                    defaultPopUpVC.didMove(toParentViewController: self )
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
        } else {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "대표 자치구 입니다"
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
        }
        
    }
    
    //  자치구 선택 버튼 액션
    @objc func pressedHomeBoroughBtn( _ sender : UIButton ) {
        
        
        guard let selectBoroughVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectBoroughViewController") as? selectBoroughViewController else { return }

        selectBoroughVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        selectBoroughVC.memberInfo = self.memberInfo
        
        //  디폴트 선택일경우 데이터 가져왔으니 서버에서 가져온 index 전달
        if( homeSelectBoroughIndex == nil ) {
            
            selectBoroughVC.memberRepresentativeBoroughIndex = self.memberRepresentativeBorough?.sb_id
        } else {
            selectBoroughVC.memberRepresentativeBoroughIndex = self.homeSelectBoroughIndex
        }
        
        self.addChildViewController( selectBoroughVC )
        selectBoroughVC.view.frame = self.view.frame
        self.view.addSubview( selectBoroughVC.view )
        selectBoroughVC.didMove(toParentViewController: self )
        
        
    }
    
    //  지금 당장 예약하기 버튼 액션
    @objc func pressedReservationNowBtn( _ sender : UIButton ) {
        
        guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }

        reservationVC.view.frame = CGRect(x: self.view.frame.width , y: 0 , width: self.view.frame.width , height: self.view.frame.height )
        reservationVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        reservationVC.memberInfo = self.memberInfo

        let tmpString = " \(gsno( selectYear )) . \(gsno( selectMonth )) . \(gsno( selectDate ))"
        
        reservationVC.selectedBoroughIndex = self.homeSelectBoroughIndex
        reservationVC.selectedBoroughName = self.homeSelectBoroughName
        reservationVC.selectedBoroughLongitude = self.homeSelectedLongitude
        reservationVC.selectedBoroughLatitude = self.homeSelectedLatitude
        reservationVC.selectedZoneIndex = self.selectZoneIndex
        reservationVC.selectedZoneName = self.selectZoneName
        reservationVC.selectedZoneImage = self.selectZoneImage
        reservationVC.selectedTmpDate = tmpString
        reservationVC.selectedDate = self.selectDateTime

        UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            reservationVC.view.frame.origin.x = 0
            
        }) { (finished ) in
            
            self.present( reservationVC , animated: false , completion: nil )
        }
        
    }
    
    //  버스킹 예약 버튼 액션
    @objc func pressedHomeBuskingReservationBtn( _ sender : UIButton ) {
        
        guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }

        reservationVC.view.frame = CGRect(x: self.view.frame.width , y: 0 , width: self.view.frame.width , height: self.view.frame.height )
        reservationVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        reservationVC.memberInfo = self.memberInfo
 
        
        UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            reservationVC.view.frame.origin.x = 0
            
        }) { (finished ) in
            
            self.present( reservationVC , animated: false , completion: nil )
        }
    }
    
    //  랭킹 버튼 액션
    @objc func pressedHomeRankingBtn( _ sender : UIButton ) {
        
        guard let rankingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RankingViewController") as? RankingViewController else { return }
        
        let containerView = self.view.superview
        
        rankingVC.view.frame = CGRect(x: self.view.frame.width , y: 0 , width: self.view.frame.width , height: self.view.frame.height )
        rankingVC.memberInfo = self.memberInfo
        
        containerView?.addSubview(rankingVC.view )
        
        UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            rankingVC.view.frame.origin.x = 0
            
        }) { (finished ) in
            
            self.present( rankingVC , animated: false , completion: nil )
        }
    }
    
    //  달력 데이터 서버연동
    func dateTimeInit() {
        
        Server.reqCalendar { (calendarData , rescode) in
            
            if rescode == 200 {
                
                self.calendar = calendarData
                self.homeCalendarCollectionView.reloadData()
                
//                self.selectYear = self.calendar?.twoWeeksYear![ 0 ]
//                self.selectMonth = self.calendar?.twoWeeksMonth![ 0 ]
//                self.selectDate = self.calendar?.twoWeeksDate![ 0 ]
//                self.selectDay = self.calendar?.twoWeeksDay![ 0 ]
                
                let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                self.collectionView( self.homeCalendarCollectionView, didSelectItemAt: indexPathForFirstRow )
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    
    //  예약 목록 가져오기 서버 연동
    func getReservationList() {
        
        if( selectDateTime != nil && homeSelectBoroughIndex != nil && selectZoneIndex != nil ) {
         
            Server.reqReservationList(r_date: selectDateTime! , sb_id: homeSelectBoroughIndex! , sbz_id: selectZoneIndex!) { ( reservationListData , rescode ) in
                
                if( rescode == 200 ) {
                    
                    self.reservationList = reservationListData
                    self.homeReservationCollectionView.reloadData()
                    
                    if( self.reservationList.count != 0 ) {
                        
                        self.nothingReservation.isHidden = true
                        
                    } else {
                        
                        self.nothingReservation.isHidden = false
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
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if( collectionView == homeCalendarCollectionView ) {
            return 14
        } else if( collectionView == homeBuskingZoneCollectionView ) {
            return buskingZoneList.count
        } else {
            return reservationList.count
        }
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if( collectionView == homeCalendarCollectionView ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCalendarCollectionViewCell", for: indexPath ) as! HomeCalendarCollectionViewCell
            
            cell.calendarDayLabel.text = calendar?.twoWeeksDay![ indexPath.row ]
            cell.calendarDateLabel.text = calendar?.twoWeeksDate![ indexPath.row ]
            
            if indexPath == calendarSelectedIndex {
                
                cell.calendarDayLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.calendarDateLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.calendarCircleImageView.isHidden = false
                
                var tmpMonth : String = (self.calendar?.twoWeeksMonth![ indexPath.row ])!
                if( tmpMonth.count == 1 ) {
                    tmpMonth.insert("0", at: tmpMonth.startIndex )
                }
                var tmpDay : String = (self.calendar?.twoWeeksDate![ indexPath.row ])!
                if( tmpDay.count == 1 ) {
                    tmpDay.insert("0", at: tmpDay.startIndex )
                }
                
                self.selectYear = self.calendar?.twoWeeksYear![ indexPath.row ]
                self.selectMonth = tmpMonth
                self.selectDate = tmpDay
                self.selectDay = self.calendar?.twoWeeksDay![ indexPath.row ]
                
                let tmpDateTime : String = gsno( selectYear ) + gsno( selectMonth ) + gsno( selectDate )
                self.selectDateTime = Int( tmpDateTime )
                
                getReservationList()
                
            } else if ( cell.calendarDayLabel.text == "일" ) {
                
                cell.calendarDayLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                cell.calendarDateLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                cell.calendarCircleImageView.isHidden = true
                
            } else {
                
                cell.calendarDayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.calendarDateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.calendarCircleImageView.isHidden = true
            }
            
            return cell
            
        } else if( collectionView == homeBuskingZoneCollectionView ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuskingZoneCollectionViewCell", for: indexPath ) as! BuskingZoneCollectionViewCell
            
            cell.buskingZoneImageView.kf.setImage( with: URL( string:gsno(buskingZoneList[indexPath.row].sbz_photo ) ) )
            cell.buskingZoneImageView.layer.cornerRadius = cell.buskingZoneImageView.layer.frame.width/2
            cell.buskingZoneImageView.clipsToBounds = true
            
            cell.buskingZoneNameLabel.text = buskingZoneList[ indexPath.row ].sbz_name
            
            if indexPath == busingZoneSelectedIndex {
                
                
                cell.buskingZoneNameLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.buskingZoneNameLabel.font = UIFont(name:"NotoSansCJKkr-Bold", size: 12.0)
                self.selectZoneIndex = self.buskingZoneList[ indexPath.row ].sbz_id
                self.selectZoneName = self.buskingZoneList[ indexPath.row ].sbz_name
                self.selectZoneImage = self.buskingZoneList[ indexPath.row ].sbz_photo
                
                cell.buskingZoneImageView.layer.borderColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.buskingZoneImageView.layer.borderWidth = 3
                
                getReservationList()
                
            } else {
                
                cell.buskingZoneNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.buskingZoneNameLabel.font = UIFont(name:"NotoSansCJKkr-Regular", size: 12.0)
                cell.buskingZoneImageView.layer.borderWidth = 0
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCollectionViewCell", for: indexPath ) as! ReservationCollectionViewCell
            
            let borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
            let borderOpacity : CGFloat = 0.3
            cell.reservationUIView.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
            cell.reservationUIView.layer.borderWidth = 1
            
            cell.reservationUIView.layer.cornerRadius = 6    //  둥근정도
            cell.reservationUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
            cell.reservationUIView.layer.shadowColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)             //  그림자 색
            cell.reservationUIView.layer.shadowOpacity = 0.5                          //  그림자 투명도
            cell.reservationUIView.layer.shadowOffset = CGSize(width: 0 , height: 0 )    //  그림자 x y
            cell.reservationUIView.layer.shadowRadius = 4
            
            //var tmpStartTime = gino( reservationList[ indexPath.row ].r_startTime )
            
//            cell.reservationTimeLabel.text = "\(String(describing: reservationList[ indexPath.row ].r_startTime)) : \(String(describing: reservationList[ indexPath.row ].r_startMin)) - \(String(describing: reservationList[ indexPath.row ].r_endTime)) : \(String(describing: reservationList[ indexPath.row ].r_endMin))"
            
            var resultStartMin : String = "0"
            var resultEndMin : String = "0"
            let startmin : Int = gino( reservationList[ indexPath.row ].r_startMin )
            let tmpStartMin = String( startmin )
            let endMin : Int = gino( reservationList[ indexPath.row ].r_endMin )
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
            cell.reservationTimeLabel.text = "\(gino( reservationList[ indexPath.row ].r_startTime )) : \(resultStartMin) - \(gino( reservationList[ indexPath.row ].r_endTime )) : \(resultEndMin)"
            
            if( reservationList[ indexPath.row ].member_profile != nil ) {
                
                cell.reservationProfileImage.kf.setImage( with: URL( string:gsno(reservationList[ indexPath.row ].member_profile ) ) )
                cell.reservationProfileImage.layer.cornerRadius = cell.reservationProfileImage.layer.frame.width/2
                cell.reservationProfileImage.clipsToBounds = true
                
            } else {
                
                cell.reservationProfileImage.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
            
            cell.reservationNickname.text = reservationList[ indexPath.row ].member_nickname
            
            cell.reservationCategory.layer.cornerRadius = 10
            cell.reservationCategory.clipsToBounds = true
            cell.reservationCategory.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ]
            cell.reservationCategory.text = "# \(gsno( reservationList[ indexPath.row ].r_category))"
            
            return cell
        }
    }

    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if( collectionView == homeCalendarCollectionView ) {
            
            calendarSelectedIndex = indexPath
            collectionView.reloadData()
            
        } else if( collectionView == homeBuskingZoneCollectionView ) {
            
            busingZoneSelectedIndex = indexPath
            collectionView.reloadData()
            
        } else {
            
            guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
            
            memberInfoVC.memberInfo = self.memberInfo
            memberInfoVC.selectMemberNickname = reservationList[ indexPath.row ].member_nickname
            
            self.present( memberInfoVC , animated: true , completion: nil )
            
        }
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if( collectionView == homeCalendarCollectionView ) {
            return CGSize(width: 56 * self.view.frame.width/375 , height: 70 * self.view.frame.height/667 )
        }
        else if( collectionView == homeBuskingZoneCollectionView ) {
            return CGSize(width: 105 * self.view.frame.width/375 , height: 125 * self.view.frame.height/667 )
        } else {
            return CGSize(width: 340 * self.view.frame.width/375 , height: 70 * self.view.frame.height/667 )
        }
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if( collectionView == homeCalendarCollectionView ) {
            return 0
        } else if( collectionView == homeBuskingZoneCollectionView ) {
            return 0
        } else {
            return 3
        }
    }
}






















