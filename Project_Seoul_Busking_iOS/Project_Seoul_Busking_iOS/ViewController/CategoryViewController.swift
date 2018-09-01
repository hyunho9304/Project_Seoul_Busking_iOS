//
//  CategoryViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 30..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

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
    var uiviewX : CGFloat?
    
    //  내용
    @IBOutlet weak var popUpViewBackBtn: UIButton!
    @IBOutlet weak var selectCategoryUIView: UIView!
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    var categoryArr : [String] = [ "노래" , "댄스" , "연주" , "마술" , "캐리커쳐" , "기타" ]
    var selectedIndex : IndexPath?              //  버스커 카테고리 선택
    var selectCategory : String?              //  버스커 선택한 카테고리
    
    @IBOutlet weak var categoryCommitBtn: UIButton! //  카테고리 선택버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showAnimate()
        setDelegate()
        setTarget()
    }
    
    func showAnimate() {
        
        self.view.frame = CGRect(x: self.view.frame.width , y: 0, width: self.view.frame.width , height: self.view.frame.height )
        
        UIView.animate(withDuration: 0.3 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn , animations: {
            
            self.view.frame.origin.x = 0
            
        }, completion: nil )
    }
    
    func setDelegate() {
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self
    }
    
    func setTarget() {

        //  뷰 닫기 버튼
        popUpViewBackBtn.addTarget(self, action: #selector(self.pressedPopUpViewBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  카테고리 선택 버튼
        categoryCommitBtn.addTarget(self, action: #selector(self.pressedCategoryCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
        
    }
    
    //  뷰 닫기 버튼 액션
    @objc func pressedPopUpViewBackBtn( _ sender : UIButton ) {
        
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
    
    //  선택완료 버튼 액션
    @objc func pressedCategoryCommitBtn( _ sender : UIButton ) {
        
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
                reservationVC.selectedCategory = self.selectCategory
                
                self.present( reservationVC , animated: false , completion: nil )
                
                self.view.removeFromSuperview()            }
        }

    }
    
    
// Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArr.count
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCategoryCollectionViewCell", for: indexPath ) as! ReservationCategoryCollectionViewCell
        
        cell.categoryNameLabel.text = categoryArr[ indexPath.row ]
        
        if indexPath == selectedIndex {
            
            cell.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
            cell.categoryNameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.selectCategory = categoryArr[ indexPath.row ]
        }
        else {
            
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.categoryNameLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
        }
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        collectionView.reloadData()
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 115 * self.view.frame.width/375 , height: 90 * self.view.frame.height/667 )
    }
    
    //  cell 섹션 내부 여백( default 는 0 보다 크다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    //  cell 간 가로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    
}










