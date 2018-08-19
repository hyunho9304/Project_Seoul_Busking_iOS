//
//  selectBoroughViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 16..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class selectBoroughViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    var memberInfo : Member?
    
    //  네비게이션 바
    @IBOutlet weak var selectBoroughBackBtn: UIButton!
    
    //  내용
    @IBOutlet weak var boroughCollectionView: UICollectionView!
    var memberRepresentativeBoroughIndex : Int?
    var boroughList : [ Borough ] = [ Borough ]()  //  서버 자치구 리스트
    var boroughSelectedIndexPath :IndexPath?    //  선택고려
    
    var selectIndex : Int?      //  선택한 index
    var selectName : String?    //  선택한 name
    
    //  선택완료 버튼
    @IBOutlet weak var selectCommitBtn: UIButton!
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var uiviewX : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 667, width: 375, height: 667)
        
        showAnimate()
        set()
        setDelegate()
        setTarget()
        setTapbarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        boroughInit()
    }
    
    func showAnimate() {
        
        
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            
            self.view.frame.origin.y = 0
            
        }, completion: nil )
    }
    
    func removeAnimate() {
        
        UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            self.view.frame.origin.y = 667
            
        }) { (finished ) in
            
            if( finished ) {
                self.view.removeFromSuperview()
            }
        }
    }
    
    func set() {
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        selectCommitBtn.layer.cornerRadius = 25
    }
    
    func setDelegate() {
        
        boroughCollectionView.delegate = self
        boroughCollectionView.dataSource = self
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 백 버튼
        selectBoroughBackBtn.addTarget(self, action: #selector(self.pressedSelectBoroughBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  선택완료 버튼
        selectCommitBtn.addTarget(self, action: #selector(self.pressedSelectCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
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
        
        guard let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        
        searchVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        searchVC.memberInfo = self.memberInfo
        
        self.present( searchVC , animated: false , completion: nil )
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
    
    //  백 홈 버튼 액션
    @objc func pressedSelectBoroughBackBtn( _ sender : UIButton ) {
        
    }
    
    //  선택완료 버튼 액션
    @objc func pressedSelectCommitBtn( _ sender : UIButton ) {
        
        
    }
    
    func boroughInit() {
        
        Server.reqBoroughList { (boroughData , rescode ) in
            
            if( rescode == 200 ) {
                
                self.boroughList = boroughData
                self.boroughCollectionView.reloadData()
  
                let indexPathForFirstRow = IndexPath(row: self.memberRepresentativeBoroughIndex! - 1 , section: 0)
                self.collectionView( self.boroughCollectionView , didSelectItemAt: indexPathForFirstRow )
                
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
        
        return boroughList.count
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectBoroughCollectionViewCell", for: indexPath ) as! SelectBoroughCollectionViewCell
        
        cell.boroughLabel.text = boroughList[ indexPath.row ].sb_name
        
        if( indexPath == boroughSelectedIndexPath ) {
            
            cell.boroughBackView.layer.cornerRadius = 20
            cell.boroughBackView.isHidden = false
            cell.boroughLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.selectIndex = boroughList[ indexPath.row ].sb_id
            self.selectName = boroughList[ indexPath.row ].sb_name
            
        } else {
            
            cell.boroughBackView.isHidden = true
            cell.boroughLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
            
        }
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        boroughSelectedIndexPath = indexPath
        collectionView.reloadData()
        
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
