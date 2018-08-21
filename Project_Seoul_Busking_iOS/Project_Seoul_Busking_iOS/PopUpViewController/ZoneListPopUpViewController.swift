//
//  ZoneListPopUpViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 21..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ZoneListPopUpViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {

    //  유저 정보
    var memberInfo : Member?
    
    @IBOutlet weak var zoneListCollectionView: UICollectionView!
    var buskingZoneList : [ BuskingZone ] = [ BuskingZone ]()  //  서버 버스킹 존 데이터
    var selectedBoroughIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimate()
        set()
        setDelegate()
        
        zoneInit()
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
        zoneListCollectionView.layer.cornerRadius = 5
    }
    
    func setDelegate() {
        
        zoneListCollectionView.delegate = self
        zoneListCollectionView.dataSource = self
    }
    
    func zoneInit() {
        
        Server.reqBuskingZoneList(sb_id: self.selectedBoroughIndex! ) { ( buskingZoneListData , rescode ) in
            
            if rescode == 200 {
                
                self.buskingZoneList = buskingZoneListData
                self.zoneListCollectionView.reloadData()
                
                if( self.buskingZoneList.count == 0 ) {
                    
                    //self.nothingZone.isHidden = false
                    
                } else {
                    
                    //self.nothingZone.isHidden = true
                   
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectBoroughCollectionViewCell", for: indexPath ) as! SelectBoroughCollectionViewCell
        
        //cell.boroughLabel.text = boroughList[ indexPath.row ].sb_name
        
        cell.boroughBackView.isHidden = true
        cell.boroughLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
        
//        reservationVC.selectBoroughIndex = self.boroughList[ indexPath.row ].sb_id
//        reservationVC.selectBoroughName = self.boroughList[ indexPath.row ].sb_name
//        reservationVC.memberInfo = self.memberInfo
        
        
        self.present( reservationVC , animated: false , completion: nil )
        
        self.view.removeFromSuperview()
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 72 * self.view.frame.width/375 , height: 39 * self.view.frame.height/667 )
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 13
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 14
    }



}
