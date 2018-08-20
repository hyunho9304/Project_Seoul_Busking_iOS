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
    var homeSelectBoroughIndex : Int?                           //  현재 선택된 자치구 index        select 해야 값 있다
    var homeSelectBoroughName : String?                        //   현재 선택된 자치구 name
    
    //  달력
    @IBOutlet weak var homeCalendarUIView: UIView!
    @IBOutlet weak var homeCalendarCollectionView: UICollectionView!
    var calendar : Calendar?        //  서버 달력 데이터
    var calendarSelectedIndex:IndexPath?    //  선택고려
    var selectYear : String?        //  선택한 년도
    var selectMonth : String?       //  선택한 월
    var selectDate : String?        //  선택한 일
    var selectDay : String?         //  선택한 요일
    var selectDateTime : String?    //  선택한년월일 ex ) 2018815
    
    //  버스킹 존
    @IBOutlet weak var homeBuskingZoneCollectionView: UICollectionView!
    var buskingZoneList : [ BuskingZone ] = [ BuskingZone ]()  //  서버 버스킹 존 데이터
    var busingZoneSelectedIndex:IndexPath?                     //  선택고려
    var selectZoneIndex : Int?                                 //  선택한 버스킹 존 인덱스
    @IBOutlet weak var nothingZone: UILabel!
    
    //  tap bar
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    var uiviewX : CGFloat?                              //  텝바 선택 애니메이션 위한 x 좌표
    
    
    @IBOutlet weak var goFirstBtn: UIButton!        //  로그아웃버튼
    
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
                        
                        if( self.buskingZoneList.count == 0 ) {
                            
                            self.nothingZone.isHidden = false
                            
                        } else {
                            
                            self.nothingZone.isHidden = true
                            
                            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                            self.collectionView( self.homeBuskingZoneCollectionView, didSelectItemAt: indexPathForFirstRow )
                            
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

        if( memberInfo?.member_type == "0" ) {
            
            homeBuskingReservationBtn.isHidden = true
        }
        
        setShadow()
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        let tap = UITapGestureRecognizer(target: self , action: #selector( HomeViewController.pressedHomeBoroughBtn(_:) ))
        homeRepresentativeBoroughLabel.isUserInteractionEnabled = true
        homeRepresentativeBoroughLabel.addGestureRecognizer(tap)
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
    }
    
    func setTarget() {
        
        //  로그아웃 버튼
        goFirstBtn.addTarget(self, action: #selector(self.pressedGoFirstBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  자치구 선택 버튼
        homeBoroughBtn.addTarget(self, action: #selector(self.pressedHomeBoroughBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  버스킹 예약 버튼
        homeBuskingReservationBtn.addTarget(self, action: #selector(self.pressedHomeBuskingReservationBtn(_:)), for: UIControlEvents.touchUpInside)
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

    //  로그아웃 버튼 액션
    @objc func pressedGoFirstBtn( _ sender : UIButton ) {
        
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        
        mapVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        mapVC.memberInfo = self.memberInfo
        
        self.present( mapVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        memberInfoVC.memberInfo = self.memberInfo
        
        self.present( memberInfoVC , animated: false , completion: nil )
        
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
    
    //  버스킹 예약 버튼 액션
    @objc func pressedHomeBuskingReservationBtn( _ sender : UIButton ) {
        
        guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
        
        let containerView = self.view.superview
        
        reservationVC.view.frame = CGRect(x: 375, y: 0, width: 375, height: 667 )
        reservationVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        reservationVC.memberInfo = self.memberInfo
        
        containerView?.addSubview(reservationVC.view )
        
        
        UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            reservationVC.view.frame.origin.x = 0
            
        }) { (finished ) in
            
            self.present( reservationVC , animated: false , completion: nil )
        }
    }
    
    //  달력 데이터 서버연동
    func dateTimeInit() {
        
        Server.reqCalendar { (calendarData , rescode) in
            
            if rescode == 200 {
                
                self.calendar = calendarData
                self.homeCalendarCollectionView.reloadData()
                
                let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                self.collectionView( self.homeCalendarCollectionView, didSelectItemAt: indexPathForFirstRow )
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
        
        self.selectYear = self.calendar?.twoWeeksYear![ 0 ]
        self.selectMonth = self.calendar?.twoWeeksMonth![ 0 ]
        self.selectDate = self.calendar?.twoWeeksDate![ 0 ]
        self.selectDay = self.calendar?.twoWeeksDay![ 0 ]
    }
    
    
    //  예약 목록 가져오기 서버 연동
    func getReservationList() {
        
        //   도두다 nil 아닐경우만 접근
        
//        print( homeSelectBoroughIndex )
//        print( selectDateTime )
//        print( selectZoneIndex )
//        print()
    }
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == homeCalendarCollectionView {
            
            return 14
        } else {
            
            return buskingZoneList.count
        }
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == homeCalendarCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCalendarCollectionViewCell", for: indexPath ) as! HomeCalendarCollectionViewCell
            
            cell.calendarDayLabel.text = calendar?.twoWeeksDay![ indexPath.row ]
            cell.calendarDateLabel.text = calendar?.twoWeeksDate![ indexPath.row ]
            
            if indexPath == calendarSelectedIndex {
                
                cell.calendarDayLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.calendarDateLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.calendarCircleImageView.isHidden = false
                
                self.selectYear = self.calendar?.twoWeeksYear![ indexPath.row ]
                self.selectMonth = self.calendar?.twoWeeksMonth![ indexPath.row ]
                self.selectDate = self.calendar?.twoWeeksDate![ indexPath.row ]
                self.selectDay = self.calendar?.twoWeeksDay![ indexPath.row ]
                
                self.selectDateTime = gsno( selectYear ) + gsno( selectMonth ) + gsno( selectDate )
                
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
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBuskingZoneCollectionViewCell", for: indexPath ) as! HomeBuskingZoneCollectionViewCell
            
            cell.buskingZoneImageView.kf.setImage( with: URL( string:gsno(buskingZoneList[indexPath.row].sbz_photo ) ) )
            cell.buskingZoneImageView.layer.cornerRadius = cell.buskingZoneImageView.layer.frame.width/2
            cell.buskingZoneImageView.clipsToBounds = true
            
            cell.buskingZoneNameLabel.text = buskingZoneList[ indexPath.row ].sbz_name
            
            if indexPath == busingZoneSelectedIndex {
                
                
                cell.buskingZoneNameLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.buskingZoneNameLabel.font = UIFont(name:"NotoSansCJKkr-Bold", size: 12.0)
                self.selectZoneIndex = self.buskingZoneList[ indexPath.row ].sbz_id
                
                cell.buskingZoneImageView.layer.borderColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.buskingZoneImageView.layer.borderWidth = 3
                
                getReservationList()
                
            } else {
                
                cell.buskingZoneNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.buskingZoneNameLabel.font = UIFont(name:"NotoSansCJKkr-Regular", size: 12.0)
                cell.buskingZoneImageView.layer.borderWidth = 0
            }
            
            return cell
        }
    }

    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == homeCalendarCollectionView {
            
            calendarSelectedIndex = indexPath
            
        } else {
            
            busingZoneSelectedIndex = indexPath
        }
        
        collectionView.reloadData()
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == homeCalendarCollectionView {
            return CGSize(width: 56 * self.view.frame.width/375 , height: 70 * self.view.frame.height/667 )
        }
        else {
            return CGSize(width: 105 * self.view.frame.width/375 , height: 125 * self.view.frame.height/667 )
        }
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == homeCalendarCollectionView {
            
            return 0
            
        } else {
            
            return 0
        }
    }
}






















