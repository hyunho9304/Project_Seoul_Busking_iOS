//
//  RankingViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 5..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //  유저 info
    var memberInfo : Member?            //  회원정보
    
    //  네비게이션 바
    @IBOutlet weak var rankingBackBtn: UIButton!
    @IBOutlet weak var searchMemberBtn: UIButton!
    
    //  선택1
    @IBOutlet weak var selectBtn1: UIButton!
    @IBOutlet weak var selectLabel1: UILabel!
    var isWorking1 : Bool = false
    
    //  선택2
    @IBOutlet weak var selectBtn2: UIButton!
    @IBOutlet weak var selectLabel2: UILabel!
    var isWorking2 : Bool = false
    
    //  선택1 내용
    @IBOutlet weak var selectUIView1: UIView!
    @IBOutlet weak var selectCollectionView1: UICollectionView!
    var select1Arr : [String] = [ "전체" , "노래" , "댄스" , "연주" , "마술" , "미술" , "기타" ]
    var select1IndexPath = IndexPath( row: 0, section: 0 )
    var selected1 : String?                                 //  선택1 고른거
    
    //  선택2 내용
    @IBOutlet weak var selectUIView2: UIView!
    @IBOutlet weak var selectCollectionView2: UICollectionView!
    var select2Arr : [String] = [ "팔로우 순" , "별점 순" ]
    var select2IndexPath = IndexPath( row: 0, section: 0 )
    var selected2 : String?                                 //  선택2 고른거
    
    //  멤버 리스트
    @IBOutlet weak var memberListUIView: UIView!
    @IBOutlet weak var memberCollectionView: UICollectionView!
    var rankingList : [ Ranking ] = [ Ranking ]()  //  서버 랭킹 리스트
    var isFollowingList : [ Int ] = [ Int ]()   //  팔로잉 리스트
    var tapHeartIndex : Int?                    //  누른 하트 인덱스
    var flag : Bool?                 //  isFollowingList 가져왔는지 true , false 에 따라 enable 시킨다.

    var refresher : UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setTarget()
        reloadTarget()
        setDelegate()
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        memberCollectionView.alwaysBounceVertical = true
        
        for _ in 0 ..< 100 {
            self.isFollowingList.append(-1)
        }
    }
    
    func reloadTarget() {
        
        refresher = UIRefreshControl()
        refresher?.tintColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
        refresher?.addTarget( self , action : #selector( reloadData ) , for : .valueChanged )
        memberCollectionView.addSubview( refresher! )
    }
    
    @objc func reloadData() {
        
        self.getMemberList()
        stopRefresher()
    }
    
    func stopRefresher() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            self.refresher?.endRefreshing()
        })
    }
    
    func setTarget() {
        
        //  랭킹 백 버튼
        rankingBackBtn.addTarget(self, action: #selector(self.pressedRankingBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  멤버 전체 이름으로 검색 버튼
        searchMemberBtn.addTarget(self, action: #selector(self.pressedSearchMemberBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  선택1 버튼
        selectBtn1.addTarget(self, action: #selector(self.pressedSelectBtn1(_:)), for: UIControlEvents.touchUpInside)
        let selectLabel1Tap = UITapGestureRecognizer(target: self , action: #selector( self.pressedSelectBtn1(_:) ))
        selectLabel1.isUserInteractionEnabled = true
        selectLabel1.addGestureRecognizer(selectLabel1Tap)
        
        //  선택2 버튼
        selectBtn2.addTarget(self, action: #selector(self.pressedSelectBtn2(_:)), for: UIControlEvents.touchUpInside)
        let selectLabel2Tap = UITapGestureRecognizer(target: self , action: #selector( self.pressedSelectBtn2(_:) ))
        selectLabel2.isUserInteractionEnabled = true
        selectLabel2.addGestureRecognizer(selectLabel2Tap)
        
    }
    
    func setDelegate() {
        
        selectCollectionView1.delegate = self
        selectCollectionView1.dataSource = self
        
        selectCollectionView2.delegate = self
        selectCollectionView2.dataSource = self
        
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        
        collectionView( self.selectCollectionView1, didSelectItemAt: select1IndexPath )
        collectionView( self.selectCollectionView2, didSelectItemAt: select2IndexPath )
    }
    
    @objc func pressedRankingBackBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        let containerView = self.view.superview
        
        containerView?.addSubview(homeVC.view )
        containerView?.sendSubview(toBack: homeVC.view)
        
        homeVC.memberInfo = self.memberInfo
        
        UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            self.view.frame.origin.x = self.view.frame.width
            
        }) { (finished ) in
            
            self.present( homeVC , animated: false , completion:  nil)
        }
    }
    
    //  멤버 전체 이름으로 검색 버튼 액션
    @objc func pressedSearchMemberBtn( _ sender : UIButton ) {
        
        guard let searchMemberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchMemberViewController") as? SearchMemberViewController else { return }
        
        searchMemberVC.memberInfo = self.memberInfo
        
        self.addChildViewController( searchMemberVC )
        searchMemberVC.view.frame = self.view.frame
        self.view.addSubview( searchMemberVC.view )
        searchMemberVC.didMove(toParentViewController: self )
    }
    
    //  선택1 버튼 액션
    @objc func pressedSelectBtn1( _ sender : UIButton ) {
        
        if( isWorking1 == false ) {
            
            self.selectUIView1.isHidden = false
            self.selectUIView2.isHidden = true
            
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.selectBtn2.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 )
                self.selectBtn1.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                self.memberListUIView.frame.origin.y = 229 * self.view.frame.height / 667
                
            }) { (finished ) in
                
                self.isWorking1 = true
                self.isWorking2 = false
            }
            
        } else {
            
            self.selectUIView1.isHidden = true
            self.selectUIView2.isHidden = true
            
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.selectBtn1.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 )
                self.memberListUIView.frame.origin.y = 123 * self.view.frame.height / 667
                
            }) { (finished ) in
                
                self.isWorking1 = false
            }
        }
        
        self.selectBtn1.layoutIfNeeded()
        self.memberListUIView.layoutIfNeeded()
    }
    
    //  선택2 버튼 액션
    @objc func pressedSelectBtn2( _ sender : UIButton ) {
        
        if( isWorking2 == false ) {
            
            self.selectUIView1.isHidden = true
            self.selectUIView2.isHidden = false
            
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.selectBtn1.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 )
                self.selectBtn2.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                self.memberListUIView.frame.origin.y = 183 * self.view.frame.height / 667
                
            }) { (finished ) in
                
                self.isWorking1 = false
                self.isWorking2 = true
            }
            
        } else {
            
            self.selectUIView1.isHidden = true
            self.selectUIView2.isHidden = true
            
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.selectBtn2.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 )
                self.memberListUIView.frame.origin.y = 123 * self.view.frame.height / 667
                
            }) { (finished ) in
                
                self.isWorking2 = false
            }
        }
        
        self.selectBtn2.layoutIfNeeded()
        self.memberListUIView.layoutIfNeeded()
    }
    
    func getMemberList() {
        
        if( selected1 != nil && selected2 != nil ) {
            
            Server.reqRankingList( select1: self.selected1! , select2: self.selected2!) { (rankingData , rescode) in
                
                if( rescode == 201 ) {
                    
                    self.flag = false
                    self.rankingList = rankingData
                    self.memberCollectionView.reloadData()
                    
                    self.getFollowingList()
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
        }
    }
    
    func getFollowingList() {
        
        //  초기화
        for i in 0 ..< 100 {
            self.isFollowingList[i] = 0
        }
        
        if( self.rankingList.count == 0 ) {
            self.memberCollectionView.reloadData()
        }
        
        for i in 0 ..< self.rankingList.count {
            
            Server.reqIsFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)!, member_following_nickname: self.rankingList[i].member_nickname! , completion: { ( rescode ) in
                
                if( rescode == 201 ) {
                    
                    self.isFollowingList[i] = 1
                    
//                    if( i == self.rankingList.count - 1 ) {
//                        self.memberCollectionView.reloadData()
//                    }
                    
                } else if( rescode == 401 ) {
                    
                    self.isFollowingList[i] = 0
                    
//                    if( i == self.rankingList.count - 1 ) {
//                        self.memberCollectionView.reloadData()
//                    }
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
                
            })
            
            if( i == self.rankingList.count - 1 ) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                    // Put your code which should be executed with a delay here
                    self.flag = true
                    self.memberCollectionView.reloadData()
                })
            }
        }

    }
    
    @objc func heartTap( _ sender : UIButton ) {
       
        Server.reqFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)!, member_following_nickname: self.rankingList[ sender.tag ].member_nickname!) { (rescode , flag ) in
            
            if( rescode == 201 ) {
                
                if( flag == 1 ) {
                    
                    guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                    
                    defaultPopUpVC.content = "팔로잉 완료"
                    
                    self.addChildViewController( defaultPopUpVC )
                    defaultPopUpVC.view.frame = self.view.frame
                    self.view.addSubview( defaultPopUpVC.view )
                    defaultPopUpVC.didMove(toParentViewController: self )
                    
                    sender.setImage(#imageLiteral(resourceName: "heart") , for: .normal )

                } else if( flag == 0 ) {
                    
                    guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                    
                    defaultPopUpVC.content = "언팔로우 완료"
                    
                    self.addChildViewController( defaultPopUpVC )
                    defaultPopUpVC.view.frame = self.view.frame
                    self.view.addSubview( defaultPopUpVC.view )
                    defaultPopUpVC.didMove(toParentViewController: self )
                    
                    sender.setImage(#imageLiteral(resourceName: "heartEmpty")  , for: .normal )
                    
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
        
        if( collectionView == selectCollectionView1 ) {
            return select1Arr.count
        } else if( collectionView == selectCollectionView2 ) {
            return select2Arr.count
        } else {
            return rankingList.count
        }
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if( collectionView == selectCollectionView1 ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingSelect1CollectionViewCell", for: indexPath ) as! RankingSelect1CollectionViewCell
            
            cell.select1CategoryNameLabel.text = self.select1Arr[ indexPath.row ]
            
            if( indexPath == self.select1IndexPath ) {
                
                cell.select1CategoryNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.select1BackImage.isHidden = false
                
                selectLabel1.text = self.select1Arr[ indexPath.row ]
                
                selected1 = self.select1Arr[ indexPath.row ]
                getMemberList()
                
            } else {
                
                cell.select1CategoryNameLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.select1BackImage.isHidden = true
                
            }
            
            return cell
            
        } else if( collectionView == selectCollectionView2 ) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingSelect2CollectionViewCell", for: indexPath ) as! RankingSelect2CollectionViewCell
            
            cell.select2Label.text = self.select2Arr[ indexPath.row ]
            
            if( indexPath == self.select2IndexPath ) {
                
                cell.select2Label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.select2BackImage.isHidden = false
                
                selectLabel2.text = self.select2Arr[ indexPath.row ]
                selected2 = self.select2Arr[ indexPath.row ]
                
                getMemberList()
                
            } else {
                
                cell.select2Label.textColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
                cell.select2BackImage.isHidden = true
                
            }
            
            return cell
            
        } else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingMemberCollectionViewCell", for: indexPath ) as! RankingMemberCollectionViewCell
            
            if( isFollowingList[ indexPath.row ] == 1 ) {
                
                cell.memberHeartImageBtn.setImage(#imageLiteral(resourceName: "heart") , for: .normal )
            } else {
                
                cell.memberHeartImageBtn.setImage(#imageLiteral(resourceName: "heartEmpty") , for: .normal )
            }
            
            if( self.flag == true ) {
                cell.memberHeartImageBtn.isEnabled = true
            } else {
                cell.memberHeartImageBtn.isEnabled = false
            }
            
            cell.memberBottomUIView.layer.opacity = 0.2
            
            if( rankingList[ indexPath.row ].member_profile != nil ) {
                
                cell.memberProfileImage.kf.setImage(with: URL( string:gsno( rankingList[ indexPath.row ].member_profile)) )
                cell.memberProfileImage.layer.cornerRadius = cell.memberProfileImage.layer.frame.width/2
                cell.memberProfileImage.clipsToBounds = true
                
            } else {
                
                cell.memberProfileImage.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
            
            if let tmpNum = self.rankingList[ indexPath.row ].member_num {
                cell.memberNumLabel.text = String( tmpNum )
            }
            
            cell.memberNicknameLabel.text = self.rankingList[ indexPath.row ].member_nickname
            cell.memberCategoryLabel.text = "# \(gsno(rankingList[ indexPath.row ].member_category))"

            
            //  cell 안의 버튼 설정
            cell.memberHeartImageBtn.tag = indexPath.row
            cell.memberHeartImageBtn.addTarget(self , action: #selector(self.heartTap(_:)) , for: UIControlEvents.touchUpInside )
            
            return cell
        }
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if( collectionView == selectCollectionView1 ) {
            
            select1IndexPath = indexPath
            collectionView.reloadData()
            
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.selectBtn1.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 )
                self.memberListUIView.frame.origin.y = 140 * self.view.frame.height / 667
                
            }) { (finished ) in
                
                self.isWorking1 = false
            }
            
            self.selectBtn1.layoutIfNeeded()
            self.memberListUIView.layoutIfNeeded()
            
        } else if( collectionView == selectCollectionView2 ) {
            
            select2IndexPath = indexPath
            collectionView.reloadData()
            
            UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.selectBtn2.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 )
                self.memberListUIView.frame.origin.y = 140 * self.view.frame.height / 667
                
            }) { (finished ) in
                
                self.isWorking2 = false
            }
            
            self.selectBtn2.layoutIfNeeded()
            self.memberListUIView.layoutIfNeeded()
            
        } else {
            
            guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
            
            memberInfoVC.memberInfo = self.memberInfo
            memberInfoVC.selectMemberNickname = rankingList[ indexPath.row ].member_nickname
            
            self.present( memberInfoVC , animated: true , completion: nil )
        }
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if( collectionView == selectCollectionView1 ) {
            return CGSize(width: 70 * self.view.frame.width/375 , height: 42 * self.view.frame.height/667 )
        } else if( collectionView == selectCollectionView2 ) {
            return CGSize(width: 110 * self.view.frame.width/375 , height: 50 * self.view.frame.height/667 )
        } else {
            return CGSize(width: 375 * self.view.frame.width/375 , height: 77 * self.view.frame.height/667 )
        }
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if( collectionView == selectCollectionView1 ) {
            return 5
        } else if( collectionView == selectCollectionView2 ) {
            return 10
        } else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if( collectionView == selectCollectionView1 ) {
            return 0
        } else if( collectionView == selectCollectionView2 ) {
            return 5
        } else {
            return 0
        }
    }

    
    
}









