//
//  BuskingZoneListViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 23..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit
import Kingfisher

class BuskingZoneListViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //  넘어온 정보
    var memberInfo : Member?            //  유저 정보
    var selectedBoroughIndex : Int?     //  선택한 자치구 index
    var selectedBoroughName : String?   //  선택한 자치구 name
    var selectedBoroughLongitude : Double?             //  멤버가 선택한 경도
    var selectedBoroughLatitude : Double?              //  멤버가 선택한 위도
    var selectedZoneIndex : Int?        //  멤버가 선택한 존 index
    var selectedZoneName : String?      //  멤버가 선택한 존 name
    var selectedZoneImage : String?     //  멤버가 선택한 존 ImageString
    var selectedTmpDate : String?       //  멤버가 선택한 날짜.
    var selectedDate : Int?          //  멤버가 선택한 날짜
    var selectedTmpTime : String?                   //  멤버가 선택한 시간 글
    var selectedTimeCnt : Int?                      //  멤버가 선택한 시간 개수
    var selectedStartTime : [Int] = [ -1 , -1 ]     //  멤버가 선택한 시간 시작 시간
    var selectedEndTime : [Int] = [ -1 , -1 ]       //  멤버가 선택한 시간 끝나는 시간
    var selectedCategory : String?              //  멤버가 선택한 장르
    
    //  네비게이션 바
    @IBOutlet weak var reservationBackBtn: UIButton!
    @IBOutlet weak var zoneSearchMapBtn: UIButton!
    
    //  내용
    
    @IBOutlet weak var buskingZoneCollectionView: UICollectionView!
    var buskingZoneList : [ BuskingZone ] = [ BuskingZone ]()  //  서버 버스킹 존 데이터
    var buskingZoneSelectedIndex:IndexPath?                     //  이동고려
    var memberShowZoneIndex : Int?      //  멤버가 현재 보고 있는 존 index
    var memberShowZoneName : String?    //  멤버가 현재 보고 있는 존 name
    var memberShowZoneImage : String?      //  멤버가 현재 보고 있는 존 imageString
    var memberShowZoneLongitude : Double?   //  멤버가 현재 보고 있는 존 경도 x
    var memberShowZoneLatitude : Double?    //  멤버가 현재 보고 있는 존 위도 y
    
    
    //  내용2( cnt )
    @IBOutlet weak var buskingZoneCntCollectionView: UICollectionView!
    var buskingZoneCntShowIndexPath:IndexPath? = IndexPath(row: 0, section: 0)  //  이동고려
    @IBOutlet weak var nothingZone: UILabel!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        buskingZoneInit()
    }
    
    //  등장 애니메이션
    func showAnimate() {
        
        self.view.frame = CGRect(x: self.view.frame.width , y: 0 , width: self.view.frame.width , height: self.view.frame.height )
        
        UIView.animate(withDuration: 0.3 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.view.frame.origin.x = 0
            
        }, completion: nil )
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
    }
    
    func setDelegate() {
        
        buskingZoneCollectionView.delegate = self
        buskingZoneCollectionView.dataSource = self
        
        buskingZoneCntCollectionView.delegate = self
        buskingZoneCntCollectionView.dataSource = self
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
        
        //  지도 버튼
        zoneSearchMapBtn.addTarget(self, action: #selector(self.pressedBuskingZoneMapBtn(_:)), for: UIControlEvents.touchUpInside)
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
            
            self.view.frame.origin.x = self.view.frame.width
            
        }) { ( finished ) in
            
            if( finished ) {
                
                guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
                
                reservationVC.memberInfo = self.memberInfo
                reservationVC.uiviewX = self.uiviewX
                
                reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
                reservationVC.selectedBoroughName = self.selectedBoroughName
                reservationVC.selectedBoroughLongitude = self.selectedBoroughLongitude
                reservationVC.selectedBoroughLatitude = self.selectedBoroughLatitude
                reservationVC.selectedZoneIndex = self.selectedZoneIndex
                reservationVC.selectedZoneName = self.selectedZoneName
                reservationVC.selectedZoneImage = self.selectedZoneImage
                reservationVC.selectedTmpDate = self.selectedTmpDate
                reservationVC.selectedDate = self.selectedDate
                reservationVC.selectedTmpTime = self.selectedTmpTime
                reservationVC.selectedTimeCnt = self.selectedTimeCnt
                reservationVC.selectedStartTime = self.selectedStartTime
                reservationVC.selectedEndTime = self.selectedEndTime
                reservationVC.selectedCategory = self.selectedCategory
                
                self.present( reservationVC , animated: false , completion: nil )
                
                self.view.removeFromSuperview()
            }
        }
    }
    
    //  지도 버튼 액션
    @objc func pressedBuskingZoneMapBtn( _ sender : UIButton ) {

        guard let buskingZoneMapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuskingZoneMapViewController") as? BuskingZoneMapViewController else { return }
        
        buskingZoneMapVC.buskingZoneList = self.buskingZoneList
        buskingZoneMapVC.selectedBoroughName = self.selectedBoroughName
        
        buskingZoneMapVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        buskingZoneMapVC.memberInfo = self.memberInfo
        buskingZoneMapVC.selectedBoroughIndex = self.selectedBoroughIndex
        buskingZoneMapVC.selectedBoroughName = self.selectedBoroughName
        buskingZoneMapVC.selectedBoroughLongitude = self.selectedBoroughLongitude
        buskingZoneMapVC.selectedBoroughLatitude = self.selectedBoroughLatitude
        buskingZoneMapVC.selectedZoneIndex = self.selectedZoneIndex
        buskingZoneMapVC.selectedZoneName = self.selectedZoneName
        buskingZoneMapVC.selectedZoneImage = self.selectedZoneImage
        buskingZoneMapVC.selectedTmpDate = self.selectedTmpDate
        buskingZoneMapVC.selectedDate = self.selectedDate
        buskingZoneMapVC.selectedTmpTime = self.selectedTmpTime
        buskingZoneMapVC.selectedTimeCnt = self.selectedTimeCnt
        buskingZoneMapVC.selectedStartTime = self.selectedStartTime
        buskingZoneMapVC.selectedEndTime = self.selectedEndTime
        buskingZoneMapVC.selectedCategory = self.selectedCategory
        
        self.present( buskingZoneMapVC , animated: true , completion: nil )
        
    }
    
    //  서버에서 해당하는 존 리스트 가져오기
    func buskingZoneInit() {
        
        Server.reqBuskingZoneListType(sb_id: selectedBoroughIndex! ) { ( buskingZoneListData , rescode ) in
            
            if rescode == 200 {
                
                self.buskingZoneList = buskingZoneListData
                self.buskingZoneCollectionView.reloadData()
                self.buskingZoneCntCollectionView.reloadData()
                
                if( self.buskingZoneList.count != 0 ) {
                    self.nothingZone.isHidden = true
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
    }
    
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return buskingZoneList.count
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if( collectionView == buskingZoneCollectionView ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectBuskingZoneCollectionViewCell", for: indexPath ) as! SelectBuskingZoneCollectionViewCell
            
            cell.buskingZoneUIView.layer.cornerRadius = 5 * self.view.frame.width / 375       //  둥근정도
            
            cell.buskingZoneUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
            cell.buskingZoneUIView.layer.shadowOpacity = 0.3                            //  그림자 투명도
            cell.buskingZoneUIView.layer.shadowOffset = CGSize(width: 0 , height: 2 )    //  그림자 x y
            cell.buskingZoneUIView.layer.shadowRadius = 5                                //  그림자 둥근정도
            //  그림자의 블러는 5 정도 이다
            
            cell.buskingZoneImageView.kf.setImage( with: URL( string:gsno(buskingZoneList[indexPath.row].sbz_photo ) ) )
            cell.buskingZoneImageView.layer.cornerRadius = 5 * self.view.frame.width / 375
            cell.buskingZoneImageView.layer.maskedCorners = [ .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
            
            cell.buskingZoneImageView.clipsToBounds = true
            cell.buskingZoneNameLabel.text = buskingZoneList[ indexPath.row ].sbz_name
            cell.buskingZoneAddress.text = buskingZoneList[ indexPath.row ].sbz_address
            
            if( self.memberShowZoneIndex == nil ) { //  처음에 들어왔을 때만 0으로 설정
             
                self.memberShowZoneIndex = buskingZoneList[ 0 ].sbz_id
                self.memberShowZoneName = buskingZoneList[ 0 ].sbz_name
                self.memberShowZoneImage = buskingZoneList[ 0 ].sbz_photo
                self.memberShowZoneLongitude = buskingZoneList[ 0 ].sbz_longitude
                self.memberShowZoneLatitude = buskingZoneList[ 0 ].sbz_latitude
            }
            
//            //  cell 안의 버튼 설정
//            cell.buskingZoneMapBtn.tag = indexPath.row
//            cell.buskingZoneMapBtn.addTarget(self, action: #selector(self.pressedBuskingZoneMapBtn(_:)), for: UIControlEvents.touchUpInside)
            
            
            //cell.buskingZoneMapBtn.isEnabled = false
            
            return cell

        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectBuskingZoneCntCollectionViewCell", for: indexPath ) as! SelectBuskingZoneCntCollectionViewCell
            
            cell.buskingZoneCntUIView.layer.cornerRadius = ( cell.buskingZoneCntUIView.layer.frame.width/2 ) * self.view.frame.width / 375
            
            if( indexPath == buskingZoneCntShowIndexPath ) {
                
                cell.buskingZoneCntUIView.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                
            } else {
                
                cell.buskingZoneCntUIView.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
            }
            
            return cell
            
        }
        
        
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if( collectionView == buskingZoneCollectionView ) {
            
            UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseIn , animations: {
                
                self.view.frame.origin.x = self.view.frame.width
                
            }) { ( finished ) in
                
                if( finished ) {
                    
                    guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
                    
                    reservationVC.memberInfo = self.memberInfo
                    reservationVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
                    reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
                    reservationVC.selectedBoroughName = self.selectedBoroughName
                    reservationVC.selectedBoroughLongitude = self.selectedBoroughLongitude
                    reservationVC.selectedBoroughLatitude = self.selectedBoroughLatitude
                    
                    reservationVC.selectedZoneIndex = self.memberShowZoneIndex
                    reservationVC.selectedZoneName = self.memberShowZoneName
                    reservationVC.selectedZoneImage = self.memberShowZoneImage
                    
                    
                    self.present( reservationVC , animated: false , completion: nil )
                    
                    self.view.removeFromSuperview()
                }
            }
            
        }
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if( collectionView == buskingZoneCollectionView ) {
         
            return CGSize(width: self.view.frame.width , height: 425 * self.view.frame.height/667 )
            
        } else {
            
            return CGSize(width: 8 * self.view.frame.width/375 , height: 8 * self.view.frame.height/667 )
        }
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if( collectionView == buskingZoneCollectionView ) {
         
            return 0
            
        } else {
            return 10
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if( collectionView == buskingZoneCollectionView ) {
            return 0
        } else {
            return 10
        }
    }

//    //  스크롤 할 때마다 호출
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        buskingZoneMapBtn.isHidden = true
//    }
//
    //  스크롤 끝났을 때
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        var visibleRect = CGRect()

        visibleRect.origin = buskingZoneCollectionView.contentOffset
        visibleRect.size = buskingZoneCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = buskingZoneCollectionView.indexPathForItem(at: visiblePoint) else { return }

        memberShowZoneIndex = buskingZoneList[ indexPath.row ].sbz_id
        memberShowZoneName = buskingZoneList[ indexPath.row ].sbz_name
        memberShowZoneImage = buskingZoneList[ indexPath.row ].sbz_photo
        memberShowZoneLongitude = buskingZoneList[ indexPath.row ].sbz_longitude
        memberShowZoneLatitude = buskingZoneList[ indexPath.row ].sbz_latitude

        buskingZoneCntShowIndexPath = indexPath
        buskingZoneCntCollectionView.reloadData()

    }
    
    //  가로세로 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if(collectionView == buskingZoneCollectionView ) {
            
            return UIEdgeInsetsMake(0, 0, 0, 0)
        } else {

            let totalCellWidth = 8 * buskingZoneList.count
            let totalSpacingWidth = 8 * ( buskingZoneList.count - 1)
            
            let leftInset = ( 260 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
            
        }
    }
    
}






