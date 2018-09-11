//
//  MapSearchViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 3..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class MapSearchViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    //  넘어온 정보
    var memberInfo : Member?
    
    @IBOutlet weak var mapSearchBoroughCollectionView: UICollectionView!
    var boroughList : [ Borough ] = [ Borough ]()  //  서버 자치구 리스트
    var boroughSelectedIndexPath :IndexPath?    //  선택고려
    var selectBoroughIndex : Int?
    
    
    @IBOutlet weak var mapSearchBuskingZoneCollectionView: UICollectionView!
    var buskingZoneList : [ BuskingZone ] = [ BuskingZone ]()  //  서버 버스킹 존 데이터
    var buskingZoneSelectedIndex:IndexPath?                     //  이동고려
    var selectBuskingZoneIndex : Int?
    var selectBuskingZoneLongitude : Double?
    var selectBuskingZoneLatitude : Double?
    
    @IBOutlet weak var mapSearchZoneUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setDelegate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        boroughInit()
    }
    
    func boroughInit() {
        
        Server.reqBoroughList { (boroughData , rescode ) in
            
            if( rescode == 200 ) {
                
                self.boroughList = boroughData
                self.mapSearchBoroughCollectionView.reloadData()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    //  서버에서 해당하는 존 리스트 가져오기
    func buskingZoneInit() {
        
        Server.reqBuskingZoneList(sb_id: selectBoroughIndex! ) { ( buskingZoneListData , rescode ) in
            
            if rescode == 200 {
                
                self.buskingZoneList = buskingZoneListData
                self.mapSearchBuskingZoneCollectionView.reloadData()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    func set() {
        
        mapSearchZoneUIView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)             //  그림자 색
        mapSearchZoneUIView.layer.shadowOpacity = 0.16                          //  그림자 투명도
        mapSearchZoneUIView.layer.shadowOffset = CGSize(width: -3 , height: 0 )    //  그림자 x y
        mapSearchZoneUIView.layer.shadowRadius = 6
        
        mapSearchBoroughCollectionView.alwaysBounceVertical = true
        mapSearchBuskingZoneCollectionView.alwaysBounceVertical = true
    }
    
    func setDelegate() {
        
        mapSearchBoroughCollectionView.delegate = self
        mapSearchBoroughCollectionView.dataSource = self
        
        mapSearchBuskingZoneCollectionView.delegate = self
        mapSearchBuskingZoneCollectionView.dataSource = self
    }
    
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if( collectionView == mapSearchBoroughCollectionView ) {
            return boroughList.count
        } else {
            return buskingZoneList.count
        }
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if( collectionView == mapSearchBoroughCollectionView ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapSearchBoroughCollectionViewCell", for: indexPath ) as! MapSearchBoroughCollectionViewCell
            
            cell.boroughNameLabel.text = boroughList[ indexPath.row ].sb_name
            
            if( indexPath == boroughSelectedIndexPath ) {
                
                cell.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.boroughNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                self.selectBoroughIndex = boroughList[ indexPath.row ].sb_id
                
                buskingZoneInit()
            } else {
                
                cell.backgroundColor = UIColor.clear
                cell.boroughNameLabel.textColor = #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1)
                
            }
            
            return cell
            
        } else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapSearchBuskingZoneCollectionViewCell", for: indexPath ) as! MapSearchBuskingZoneCollectionViewCell
            
            cell.buskingZoneNameLabel.text = buskingZoneList[ indexPath.row ].sbz_name
            
            return cell
        }
        
        
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if( collectionView == mapSearchBoroughCollectionView ) {
            boroughSelectedIndexPath = indexPath
            collectionView.reloadData()
        } else {
            
            selectBuskingZoneIndex = buskingZoneList[ indexPath.row ].sbz_id
            selectBuskingZoneLongitude = buskingZoneList[ indexPath.row ].sbz_longitude
            selectBuskingZoneLatitude = buskingZoneList[ indexPath.row ].sbz_latitude
            
            guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
            
            mapVC.memberInfo = self.memberInfo
            mapVC.findBuskingZoneIndex = self.selectBuskingZoneIndex!
            mapVC.findBuskingZoneLongitude = self.selectBuskingZoneLongitude
            mapVC.findBuskingZoneLatitude = self.selectBuskingZoneLatitude
            
            self.present( mapVC , animated: false , completion: nil )
        }
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 187.5 * self.view.frame.width/375 , height: 71 * self.view.frame.height/667 )
    }
    
    //  cell 섹션 내부 여백( default 는 0 보다 크다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

}
