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
    @IBOutlet weak var homeRepresentativeBoroughLabel: UILabel!      //  멤버 대표 자치구
    @IBOutlet weak var homeBoroughBtn: UIButton!                //  자치구 선택 버튼
    @IBOutlet weak var homeBuskingReservationBtn: UIButton!     //  버스킹예약 버튼
    
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

        dateTimeInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getMemberRepresentativeBoroughData()
    }
    
    func getMemberRepresentativeBoroughData() {
        
        print( memberInfo )
        
        Server.reqMemberRepresentativeBorough(member_nickname: (memberInfo?.member_nickname)!) { ( memberRepresentativeBoroughData , rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberRepresentativeBorough = memberRepresentativeBoroughData
                
                self.homeRepresentativeBoroughLabel.text = self.memberRepresentativeBorough?.sb_name
                
                Server.reqBuskingZoneList(sb_id: (self.memberRepresentativeBorough?.sb_id)! ) { ( buskingZoneListData , rescode ) in
                    
                    if rescode == 200 {
                        
                        self.buskingZoneList = buskingZoneListData
                        self.homeBuskingZoneCollectionView.reloadData()
                        
                        if( self.buskingZoneList.count != 0 ) {
                            print(111111)
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
        
        //  그림자의 블러는 5 정도 이다
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
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
    }
    
    //  텝바 움직임 애니메이션
    func setTapbarAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            
            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.tapbarUIView.frame.origin.x = self.tapbarHomeBtn.frame.origin.x
                
            }, completion: nil )
        })
    }
    
//    //  디폴트 정보 첫번째 선택
//    func selectedFirstInform() {
//
//        //auto selected 1st item
//        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
//
//        collectionView( homeCalendarCollectionView, didSelectItemAt: indexPathForFirstRow )
//
//        if( buskingZoneList.count != 0 ) {
//
//            collectionView( homeBuskingZoneCollectionView, didSelectItemAt: indexPathForFirstRow )
//        }
//    }
//
    //  로그아웃 버튼 액션
    @objc func pressedGoFirstBtn( _ sender : UIButton ) {
        
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        
        searchVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        searchVC.memberInfo = self.memberInfo
        
        self.present( searchVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        memberInfoVC.memberInfo = self.memberInfo
        
        self.present( memberInfoVC , animated: false , completion: nil )
        
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
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == homeCalendarCollectionView {
            
            return 14
        } else {
            
            if( buskingZoneList.count == 0 ) {
                nothingZone.isHidden = false
            } else {
                nothingZone.isHidden = true
            }
            
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






















