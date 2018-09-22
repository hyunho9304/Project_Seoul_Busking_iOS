//
//  SelectCategoryViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 22..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //  넘어온 정보
    var memberInfo : Member?
    
    //  네비게이션 바
    @IBOutlet weak var selectCategoryBackBtn: UIButton!
    
    
    //  내용
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    var categoryArr : [String] = [ "노래" , "미술" , "댄스" , "연주" , "마술" , "기타" ]
    var categoryImageArr = [ #imageLiteral(resourceName: "rectangle6.jpg") , #imageLiteral(resourceName: "rectangle6Copy.jpg") , #imageLiteral(resourceName: "rectangle6Copy2.jpg") , #imageLiteral(resourceName: "rectangle6Copy4.jpg") , #imageLiteral(resourceName: "rectangle6Copy3.jpg") , #imageLiteral(resourceName: "rectangle6Copy5.jpg") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTarget()
        setDelegate()
    }
    
    func setTarget() {
        
        //  백 버튼
        selectCategoryBackBtn.addTarget(self, action: #selector(self.pressedSelectCategoryBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    //  백 버튼 액션
    @objc func pressedSelectCategoryBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: false , completion: nil )
    }
    
    func setDelegate() {
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self
    }
    
// Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryImageArr.count
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCategoryCollectionViewCell", for: indexPath ) as! ReservationCategoryCollectionViewCell
        
        cell.categoryImageView.image = categoryImageArr[ indexPath.row ]
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Server.reqMemberUpdateType(member_ID: (self.memberInfo?.member_ID)! , member_category: categoryArr[ indexPath.row ]) { ( memberData , rescode ) in
            
            if( rescode == 201 ) {
                
                guard let changeWelcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangeWelcomeViewController") as? ChangeWelcomeViewController else { return }
                
                changeWelcomeVC.memberInfo = memberData
                
                self.present( changeWelcomeVC , animated: false , completion: nil )
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
                
            }
        }
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 170 * self.view.frame.width/375 , height: 170 * self.view.frame.height/667 )
    }
    
    //  cell 섹션 내부 여백( default 는 0 보다 크다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    //  cell 간 가로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }



}
