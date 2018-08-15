//
//  HomeViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 5..
//  Copyright © 2018년 박현호. All rights reserved.
//

//  현재 회원가입시 -> member_type , member_nickname 저장
//  현재 로그인시 -> member_ID 저장
import UIKit

class HomeViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //  달력
    @IBOutlet weak var homeCalendarCollectionView: UICollectionView!
    var calendar : Calendar?        //  서버 달력 데이터
    var selectedIndex:IndexPath?    //  선택고려
    var selectYear : String?        //  선택한 년도
    var selectMonth : String?       //  선택한 월
    var selectDate : String?        //  선택한 일
    var selectDay : String?         //  선택한 요일
    var selectDateTime : String?    //  선택한년월일 ex ) 2018815
    
    //  tap bar
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    var uiviewX : CGFloat?                              //  텝바 선택 애니메이션 위한 x 좌표
    
    
    @IBOutlet weak var goFirstBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setTarget()
        setTapbarAnimation()

        dateTimeInit()
        selectedFirstInform()
    }
    
    func set() {
        
        homeCalendarCollectionView.delegate = self
        homeCalendarCollectionView.dataSource = self
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
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
    
    //  디폴트 정보 첫번째 선택
    func selectedFirstInform() {
        
        //auto selected 1st item
        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        
        collectionView(homeCalendarCollectionView, didSelectItemAt: indexPathForFirstRow)
    }
    
    //  로그아웃 버튼 액션
    @objc func pressedGoFirstBtn( _ sender : UIButton ) {
        
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        
        searchVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        
        self.present( searchVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        
        self.present( memberInfoVC , animated: false , completion: nil )
        
    }
    
    //  달력 데이터 서버연동
    func dateTimeInit() {
        
        Server.reqCalendar { (calendarData , rescode) in
            
            if rescode == 200 {
                
                self.calendar = calendarData
                self.homeCalendarCollectionView.reloadData()
                
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
        
        return 14   //  2주표현
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCalendarCollectionViewCell", for: indexPath ) as! HomeCalendarCollectionViewCell
        
        cell.calendarDayLabel.text = calendar?.twoWeeksDay![ indexPath.row ]
        cell.calendarDateLabel.text = calendar?.twoWeeksDate![ indexPath.row ]
        
        if indexPath == selectedIndex {
            
            cell.calendarDayLabel.textColor = UIColor( red: 255, green: 0, blue: 0, alpha: 1.0 )
            cell.calendarDateLabel.textColor = UIColor( red: 255 , green: 255 , blue: 255 , alpha: 1.0 )
            cell.calendarCircleImageView.isHidden = false
            
            self.selectYear = self.calendar?.twoWeeksYear![ indexPath.row ]
            self.selectMonth = self.calendar?.twoWeeksMonth![ indexPath.row ]
            self.selectDate = self.calendar?.twoWeeksDate![ indexPath.row ]
            self.selectDay = self.calendar?.twoWeeksDay![ indexPath.row ]
            
            self.selectDateTime = gsno( selectYear ) + gsno( selectMonth ) + gsno( selectDate )
            
        } else if ( cell.calendarDayLabel.text == "일" ) {
            
            cell.calendarDayLabel.textColor = UIColor( red: 255, green: 0, blue: 0, alpha: 1.0 )
            cell.calendarDateLabel.textColor = UIColor( red: 255, green: 0, blue: 0, alpha: 1.0)
            cell.calendarCircleImageView.isHidden = true
            
        } else {
            
            cell.calendarDayLabel.textColor = UIColor( red: 0, green: 0, blue: 0, alpha: 1.0 )
            cell.calendarDateLabel.textColor = UIColor( red: 0 , green: 0 , blue: 0 , alpha: 1.0 )
            cell.calendarCircleImageView.isHidden = true
        }
        
        return cell
        
    }

    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        collectionView.reloadData()
        
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
}






















