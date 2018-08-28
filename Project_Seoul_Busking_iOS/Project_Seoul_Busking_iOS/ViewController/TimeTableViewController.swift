//
//  TimeTableViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 26..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class TimeTableViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    //  넘어온 정보
    var memberInfo : Member?            //  유저 정보
    var selectedBoroughIndex : Int?     //  선택한 자치구 index
    var selectedBoroughName : String?   //  선택한 자치구 name
    var selectedZoneIndex : Int?        //  멤버가 선택한 존 index
    var selectedZoneName : String?      //  멤버가 선택한 존 name
    var selectedZoneImage : String?     //  멤버가 선택한 존 ImageString
    var selectedTmpDate : String?       //  멤버가 선택한 날짜.
    var selectedDate : Int?          //  멤버가 선택한 날짜
    var selectedTmpTime : String?                   //  멤버가 선택한 시간 글
    var selectedTimeCnt : Int?                      //  멤버가 선택한 시간 개수
    var selectedStartTime : [Int] = [ -1 , -1 ]     //  멤버가 선택한 시간 시작 시간
    var selectedEndTime : [Int] = [ -1 , -1 ]       //  멤버가 선택한 시간 끝나는 시간
    
    var selectStartTimeArr : [Int] = [ -1 , -1 ]    //  멤버가 선택한 시작 시간
    var selectCnt : Int = 0                         //  멤버가 선택한 시간 수
    
    
    //  네비게이션 바
    @IBOutlet weak var reservationBackBtn: UIButton!
    
    //  내용
    @IBOutlet weak var timeTableCollectionView: UICollectionView!
    var reservationPossibility : ReservationPossibility?  //  서버 버스킹 존 데이터
    
    //  선택 완료
    @IBOutlet weak var selectTimeCommitBtn: UIButton!
    
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var uiviewX : CGFloat?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimate()
        set()
        setDelegate()
        setTarget()
        setTapbarAnimation()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getReservationPossibilityInit()
    }
    
    func getReservationPossibilityInit() {
        
        Server.reqReservationPossibility(r_date: selectedDate! , sb_id: selectedBoroughIndex! , sbz_id: selectedZoneIndex!) { ( reservationPossibilityData , rescode ) in
            
            if( rescode == 200 ) {
                
                self.reservationPossibility = reservationPossibilityData
                self.timeTableCollectionView.reloadData()
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    //  등장 애니메이션
    func showAnimate() {
        
        self.view.frame = CGRect(x: 375 , y: 0 , width: 375, height: 667)
        
        UIView.animate(withDuration: 0.3 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.view.frame.origin.x = 0
            
        }, completion: nil )
    }
    
    func set() {
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        selectTimeCommitBtn.layer.cornerRadius = 25
        timeTableCollectionView.allowsMultipleSelection = true
    }
    
    func setDelegate() {
        
        timeTableCollectionView.delegate = self
        timeTableCollectionView.dataSource = self
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
        
        //  선택완료 버튼
        selectTimeCommitBtn.addTarget(self, action: #selector(self.pressedSelectTimeCommitBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setTapbarAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            
            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.tapbarUIView.frame.origin.x = self.tapbarHomeBtn.frame.origin.x
                
            }, completion: nil )
        })
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        
        mapVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
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
        
        UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseIn , animations: {
            
            self.view.frame.origin.x = 375
            
        }) { ( finished ) in
            
            if( finished ) {
                
                guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
                
                reservationVC.memberInfo = self.memberInfo
                reservationVC.uiviewX = self.uiviewX
                
                reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
                reservationVC.selectedBoroughName = self.selectedBoroughName
                reservationVC.selectedZoneIndex = self.selectedZoneIndex
                reservationVC.selectedZoneName = self.selectedZoneName
                reservationVC.selectedZoneImage = self.selectedZoneImage
                reservationVC.selectedTmpDate = self.selectedTmpDate
                reservationVC.selectedDate = self.selectedDate
                reservationVC.selectedTmpTime = self.selectedTmpTime
                reservationVC.selectedTimeCnt = self.selectedTimeCnt
                reservationVC.selectedStartTime = self.selectedStartTime
                reservationVC.selectedEndTime = self.selectedEndTime
                
                self.present( reservationVC , animated: false , completion: nil )
                
                self.view.removeFromSuperview()
            }
        }
        
    }
    
    //  선택완료 버튼 액션
    @objc func pressedSelectTimeCommitBtn( _ sender : UIButton ) {
        
        //  선택 했을경우
        if( selectCnt == 1  ) {
            
            UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseIn , animations: {
                
                self.view.frame.origin.x = 375
                
            }) { ( finished ) in
                
                if( finished ) {
                    
                    guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
                    
                    reservationVC.memberInfo = self.memberInfo
                    reservationVC.uiviewX = self.uiviewX
                    
                    reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
                    reservationVC.selectedBoroughName = self.selectedBoroughName
                    reservationVC.selectedZoneIndex = self.selectedZoneIndex
                    reservationVC.selectedZoneName = self.selectedZoneName
                    reservationVC.selectedZoneImage = self.selectedZoneImage
                    reservationVC.selectedTmpDate = self.selectedTmpDate
                    reservationVC.selectedDate = self.selectedDate
                    
                    var tmpStartTime : Int = -1
                    
                    for i in 0 ..< 2 {
                        if( self.selectStartTimeArr[i] != -1 ) {
                            tmpStartTime = self.selectStartTimeArr[i]
                            break
                        }
                    }
                    
                    reservationVC.selectedTmpTime = "\(tmpStartTime) : 00 - \(tmpStartTime + 1) : 00"
                    reservationVC.selectedTimeCnt = 1
                    reservationVC.selectedStartTime[0] = tmpStartTime
                    reservationVC.selectedEndTime[0] = tmpStartTime + 1
                    
                    self.present( reservationVC , animated: false , completion: nil )
                    
                    self.view.removeFromSuperview()
                }
            }
        } else if( selectCnt == 2 ) {       //  2개 선택했을 경우
            
            UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseIn , animations: {
                
                self.view.frame.origin.x = 375
                
            }) { ( finished ) in
                
                if( finished ) {
                    
                    guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
                    
                    reservationVC.memberInfo = self.memberInfo
                    reservationVC.uiviewX = self.uiviewX
                    
                    reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
                    reservationVC.selectedBoroughName = self.selectedBoroughName
                    reservationVC.selectedZoneIndex = self.selectedZoneIndex
                    reservationVC.selectedZoneName = self.selectedZoneName
                    reservationVC.selectedZoneImage = self.selectedZoneImage
                    reservationVC.selectedTmpDate = self.selectedTmpDate
                    reservationVC.selectedDate = self.selectedDate
                    
                    //  작은시간이 앞으로 오도록 변환
                    if( self.selectStartTimeArr[0] > self.selectStartTimeArr[1] ) {
                        let tmpTime = self.selectStartTimeArr[0]
                        self.selectStartTimeArr[0] = self.selectStartTimeArr[1]
                        self.selectStartTimeArr[1] = tmpTime
                    }
                    
                    let tmpStartTime1 = self.selectStartTimeArr[0]
                    let tmpStartTIme2 = self.selectStartTimeArr[1]
                    
                    //  연속 2시간 경우
                    if( ( tmpStartTime1 + 1 ) == tmpStartTIme2 ) {
                        
                        reservationVC.selectedTmpTime = "\(tmpStartTime1) : 00 - \(tmpStartTIme2 + 1) : 00"
                        reservationVC.selectedTimeCnt = 1
                        reservationVC.selectedStartTime[0] = tmpStartTime1
                        reservationVC.selectedEndTime[0] = tmpStartTIme2 + 1
                        
                    } else {    //  연속 아닌 2시간 경우
                        
                        reservationVC.selectedTmpTime = "\(tmpStartTime1) : 00 - \(tmpStartTime1 + 1) : 00  //  \(tmpStartTIme2) : 00 - \(tmpStartTIme2 + 1) : 00"
                        reservationVC.selectedTimeCnt = 2
                        reservationVC.selectedStartTime[0] = tmpStartTime1
                        reservationVC.selectedStartTime[1] = tmpStartTIme2
                        reservationVC.selectedEndTime[0] = tmpStartTime1 + 1
                        reservationVC.selectedEndTime[1] = tmpStartTIme2 + 1
                    }
                    
                    self.present( reservationVC , animated: false , completion: nil )
                    
                    self.view.removeFromSuperview()
                }
            }
        } else {    //  선택 안했을 경우
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "시간을 선택해 주세요."
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
            
        }

    }

//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTableCollectionViewCell", for: indexPath ) as! TimeTableCollectionViewCell
        
        cell.isUserInteractionEnabled = false
        
        let borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        let borderOpacity : CGFloat = 0.3
        cell.timeTableUIView.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
        cell.timeTableUIView.layer.borderWidth = 1
        
        cell.timeTableUIView.layer.cornerRadius = 6    //  둥근정도
        cell.timeTableUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        cell.timeTableUIView.layer.shadowColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)             //  그림자 색
        cell.timeTableUIView.layer.shadowOpacity = 0.5                            //  그림자 투명도
        cell.timeTableUIView.layer.shadowOffset = CGSize(width: 0 , height: 5 )    //  그림자 x y
        cell.timeTableUIView.layer.shadowRadius = 5
        
        cell.timeTableContentsLabel.text = "\(indexPath.row + 17) : 00 - \(indexPath.row + 18) : 00"
        
        if( reservationPossibility?.possibility[ indexPath.row ] == 1 ) {
         
            cell.isUserInteractionEnabled = true
            
            cell.timeTableCircleImageView.image = #imageLiteral(resourceName: "checkO")
            cell.timeTableReservInfoImageView.image = #imageLiteral(resourceName: "reser.png")
        }
        
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath ) as! TimeTableCollectionViewCell

        if( self.selectCnt >= 0 && self.selectCnt < 2 ) {
         
            if( self.selectStartTimeArr[0] == -1 ) {
                self.selectStartTimeArr[0] = indexPath.row + 17
            } else {
                self.selectStartTimeArr[1] = indexPath.row + 17
            }
            self.selectCnt += 1
            cell.timeTableCircleImageView.image = #imageLiteral(resourceName: "checkSuccess")
        }
        
    }

    //  cell 선택 해제 했을 때
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath ) as! TimeTableCollectionViewCell
        
        for i in 0 ..< 2 {
            
            if( indexPath.row + 17 == selectStartTimeArr[i] ) {
                self.selectStartTimeArr[i] = -1
                self.selectCnt -= 1
                cell.timeTableCircleImageView.image = #imageLiteral(resourceName: "checkO")
                break
            }
        }
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 340 * self.view.frame.width/375 , height: 70 * self.view.frame.height/667 )
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
