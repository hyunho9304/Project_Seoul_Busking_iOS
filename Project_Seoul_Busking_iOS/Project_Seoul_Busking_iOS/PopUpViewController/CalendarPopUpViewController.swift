//
//  CalendarPopUpViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 22..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation
import UIKit

class CalendarPopUpViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {

    //  넘어온 정보
    var memberInfo : Member?    //  유저 정보
    var selectedBoroughIndex : Int?   //  선택한 자치구 index
    var selectedBoroughName : String? //  선택한 자치구 name
    var selectedZoneIndex : Int?      //  멤버가 현재 보고 있는 존 index
    var selectedZoneName : String?    //  멤버가 현재 보고 있는 존 name
    var selectedZoneImage : String?      //  멤버가 현재 보고 있는 존 ImageString
    
    @IBOutlet weak var calendarPopUpUIView: UIView!
    @IBOutlet weak var popUpViewBackBtn: UIButton!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarBackBtn: UIButton!
    @IBOutlet weak var calendarNextBtn: UIButton!
    @IBOutlet weak var calendarSelectCommitBtn: UIButton!
    
    
    let Months = [ "01" , "02" , "03" , "04" , "05" , "06" , "07" , "08" , "09" , "10" , "11" , "12" ]
    let daysOfMonth = [ "월" , "화" , "수" , "목" , "금" , "토" , "일" ]
    var daysInMonths = [ 31 , 28 , 31 , 30 , 31 , 30 , 31 , 31 , 30 , 31 , 30 , 31 ]
    
    var year = calendar.component(.year, from: date)
    var month = calendar.component(.month, from: date) - 1
    let weekday = calendar.component(.weekday, from: date)
    let day = calendar.component(.day, from: date)
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int()            //  현재 보여주는 달의 1일전 빈 공간 개수
    var NextNumberOfEmptyBox = Int()        //  다음달 빈공간
    var PreviousNumberOfEmptyBox = 0        //  전달 빈공간
    var Direction = 0                       //  =0 현재 , =1 미래 , =-1 과거
    var PositionIndex = 0                   //  빈공간 저장
   
    var calendarSelectedIndex:IndexPath?    //  선택고려
    var selectYear : String?        //  선택한 년도
    var selectMonth : String?       //  선택한 월
    var selectDate : String?        //  선택한 일
    var selectDateTime : String?    //  선택한년월일 ex ) 2018815
    
    var nextMonthIndex = 21
    
    
    var uiviewX : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimate()
        set()
        setDelegate()
        setTarget()
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.18) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
        }
    }
    
    func set() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent( 0.6 )
        calendarPopUpUIView.layer.cornerRadius = 15
        calendarBackBtn.isHidden = true
        
        //  윤년
        if( year % 4 == 0 && year % 100 != 0 || year % 400 == 0 ) {
            daysInMonths[1] = 29
        }
        
        currentMonth = Months[month]
        MonthLabel.text = "\(year). \(currentMonth)"
        
        NumberOfEmptyBox = (weekday - 1 )               //  이번달 빈공간
        PositionIndex = ( weekday - 1 )                 //  이번달 빈공간
        
        calendarSelectedIndex = IndexPath(row: -1, section: -1)     //  없는것
        
        calendarSelectCommitBtn.layer.cornerRadius = 20
    }
    
    func setDelegate() {
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }
    
    func setTarget() {
        
        //  달력 전달 버튼
        calendarBackBtn.addTarget(self, action: #selector(self.pressedCalendarBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  달력 다음달 버튼
        calendarNextBtn.addTarget(self, action: #selector(self.pressedCalendarNextBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  확인 버튼
        calendarSelectCommitBtn.addTarget(self, action: #selector(self.pressedCalendarSelectCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  뷰 닫기 버튼
        popUpViewBackBtn.addTarget(self, action: #selector(self.pressedPopUpViewBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    //  달력 전달 버튼 액션
    @objc func pressedCalendarBackBtn( _ sender : UIButton ) {
        
        calendarBackBtn.isHidden = true
        calendarNextBtn.isHidden = false
        
        
        switch currentMonth {
        case "01" :
            month = 11
            year -= 1
            Direction = -1
            nextMonthIndex = 21
            GetStartDateDayPosition()
            
            calendarSelectedIndex = IndexPath(row: -1, section: -1)     //  없는것
            
            currentMonth = Months[month]
            MonthLabel.text = "\(year). \(currentMonth)"
            calendarCollectionView.reloadData()
            
        default :
            month -= 1
            Direction = -1
            nextMonthIndex = 21
            GetStartDateDayPosition()
            
            calendarSelectedIndex = IndexPath(row: -1, section: -1)     //  없는것
            
            currentMonth = Months[month]
            MonthLabel.text = "\(year). \(currentMonth)"
            calendarCollectionView.reloadData()
        }
    }
    
    //  달력 다음달 버튼 액션
    @objc func pressedCalendarNextBtn( _ sender : UIButton ) {
        
        calendarBackBtn.isHidden = false
        calendarNextBtn.isHidden = true
        
        switch currentMonth {
        case "12" :
            month = 0
            year += 1
            Direction = 1
            
            GetStartDateDayPosition()
            
            calendarSelectedIndex = IndexPath(row: -1, section: -1)     //  없는것
            
            currentMonth = Months[month]
            MonthLabel.text = "\(year). \(currentMonth)"
            calendarCollectionView.reloadData()
            
        default :
            Direction = 1
            
            GetStartDateDayPosition()
            
            calendarSelectedIndex = IndexPath(row: -1, section: -1)     //  없는것
            
            month += 1
            
            currentMonth = Months[month]
            MonthLabel.text = "\(year). \(currentMonth)"
            calendarCollectionView.reloadData()
        }
    }
    
    //  선택 확인 버튼 액션
    @objc func pressedCalendarSelectCommitBtn( _ sender : UIButton ) {
        
        //  선택 했을경우
        if( calendarSelectedIndex != IndexPath(row: -1, section: -1)  ) {
         
            guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
            
            let tmpString = " \(gsno( selectYear )) . \(gsno( selectMonth )) . \(gsno( selectDate ))"
            
            reservationVC.memberInfo = self.memberInfo
            reservationVC.uiviewX = self.uiviewX
            reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
            reservationVC.selectedBoroughName = self.selectedBoroughName
            reservationVC.selectedZoneIndex = self.selectedZoneIndex
            reservationVC.selectedZoneName = self.selectedZoneName
            reservationVC.selectedZoneImage = self.selectedZoneImage
            
            reservationVC.selectedDate = self.selectDateTime
            reservationVC.selectedTmpDate = tmpString
            
            self.present( reservationVC , animated: false , completion: nil )
            
            self.view.removeFromSuperview()
            
        } else {    //  선택 안했을 경우
            self.view.removeFromSuperview()
        }
    }
    
    //  뷰 닫기 버튼 액션
    @objc func pressedPopUpViewBackBtn( _ sender : UIButton ) {
        
        self.view.removeFromSuperview()
    }
    
    func GetStartDateDayPosition() {
        
        //  윤년
        if( year % 4 == 0 && year % 100 != 0 || year % 400 == 0 ) {
            daysInMonths[1] = 29
        }
        
        switch Direction {
            
        case 0 :
            switch day {
                
            case 1...7 :
                NumberOfEmptyBox = weekday - day
            case 8...14 :
                NumberOfEmptyBox = weekday - day - 7
            case 15...21 :
                NumberOfEmptyBox = weekday - day - 14
            case 22...28 :
                NumberOfEmptyBox = weekday - day - 21
            case 29...31 :
                NumberOfEmptyBox = weekday - day - 28
            default :
                break
            }
            PositionIndex = NumberOfEmptyBox
            
        case 1... :
            NextNumberOfEmptyBox = ( PositionIndex + daysInMonths[ month] ) % 7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1 :
            PreviousNumberOfEmptyBox = ( 7 - ( daysInMonths[month] - PositionIndex) % 7 )
            if( PreviousNumberOfEmptyBox == 7 ) {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
            
        default :
            fatalError()
        }
    }

    
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch Direction {
        case 0 :
            return daysInMonths[month] + NumberOfEmptyBox
        case 1... :
            return daysInMonths[month] + NextNumberOfEmptyBox
        case -1 :
            return daysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
        
        return daysInMonths[month]
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath ) as! CalendarCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = #colorLiteral(red: 0.6712639928, green: 0.6712799668, blue: 0.6712713838, alpha: 1)
        cell.isUserInteractionEnabled = false
        
        if( cell.isHidden ) {
            cell.isHidden = false
        }
        
        switch Direction {
        case 0 :
            cell.dateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1 :
            cell.dateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1 :
            cell.dateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int( cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        //  오늘 날짜 색칠
        if currentMonth == Months[ calendar.component(.month, from: date) - 1 ] && year == calendar.component(.year, from: date) && ( indexPath.row + 1 - NumberOfEmptyBox ) == day {
            cell.circleToday.isHidden = false
        } else {
            cell.circleToday.isHidden = true
        }
        
//        //  전 날짜 색칠
//        if( currentMonth == Months[ calendar.component(.month, from: date) - 1 ] && year == calendar.component(.year, from: date) && indexPath.row + 1 < day) {
//
//            //cell.dateLabel.textColor = UIColor.yellow
//        }
        
        
        //  이번달 예약가능 날짜 표시 21일가능
        if( currentMonth == Months[ calendar.component(.month, from: date) - 1 ] && year == calendar.component(.year, from: date) && ( ( indexPath.row + 1 - NumberOfEmptyBox ) >= day ) && ( indexPath.row + 1 - NumberOfEmptyBox ) < (day+21 ) ) {
            
            if( calendarSelectedIndex == IndexPath(row: -1, section: -1)  ) {       //  선택시 viewReload 될때 반복되서 카운트 하지 않도록 디폴트경우만 카운트 선택없을경우
             
                nextMonthIndex -= 1
            }
            
            cell.isUserInteractionEnabled = true
            cell.dateLabel.textColor = #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1)
        }
        
        //  다음달 예약가능 날짜 표시 21일가능
        if( currentMonth == Months[ calendar.component(.month, from: date) ] && year == calendar.component(.year, from: date) && (( indexPath.row - NextNumberOfEmptyBox ) < nextMonthIndex ) ) {
            
            cell.isUserInteractionEnabled = true
            cell.dateLabel.textColor = #colorLiteral(red: 0.5255666971, green: 0.4220638871, blue: 0.9160656333, alpha: 1)
        }
        
        //  주말날짜 색칠
        switch indexPath.row {
        case 0,7,14,21,28,35 :
            if Int( cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.red
            }
        default:
            break
        }
        
        
        if indexPath == calendarSelectedIndex {
            
            cell.dateLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.circleSelect.isHidden = false
            
            self.selectYear = String( year )
            self.selectMonth = String( month + 1 )
            self.selectDate = cell.dateLabel.text
            
            self.selectDateTime = gsno( selectYear ) + gsno( selectMonth ) + gsno( selectDate )
            
        } else {
            
            cell.circleSelect.isHidden = true
        }
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        calendarSelectedIndex = indexPath
        
        collectionView.reloadData()
        
    }

    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 40 * self.view.frame.width/375 , height: 40 * self.view.frame.height/667 )
    }

    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 5
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 5
    }
}
