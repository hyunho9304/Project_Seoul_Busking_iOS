//
//  SearchMemberViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 6..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SearchMemberViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITextFieldDelegate {
    
    //  유저 info
    var memberInfo : Member?            //  회원정보
    
    //  네비게이션 바
    @IBOutlet weak var searchMemberBackBtn: UIButton!
    @IBOutlet weak var searchUIView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchEndBtn: UIButton!
    
    //  내용
    @IBOutlet weak var memberCollectionView: UICollectionView!
    var memberList : [ MemberList ] = [ MemberList ]()  //  서버 멤버 리스트
    var isFollowingList : [ Int ] = [ Int ]()   //  팔로잉 리스트
    var tapHeartIndex : Int?                    //  누른 하트 인덱스
    var flag : Bool?                 //  isFollowingList 가져왔는지 true , false 에 따라 enable 시킨다.
    
    //  검색( 팔로잉 )
    var filteredMemberList : [ MemberList ] = [ MemberList ]()  //  검색 결과
    var filteredFollowingList : [ Int ] = [ Int ]()             //  검색결과팔로잉 리스트
    var isFiltering : Bool = false                              //  검색하는지 체크
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showAnimate()
        set()
        setTarget()
        setDelegate()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getMemberList()
    }
    
    func showAnimate() {
        
        self.view.frame = CGRect(x: self.view.frame.width , y: 0, width: self.view.frame.width , height: self.view.frame.height )
        
        UIView.animate(withDuration: 0.3 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn , animations: {
            
            self.view.frame.origin.x = 0
            
        }, completion: nil )
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .default
        
        for _ in 0 ..< 10000 {
            self.isFollowingList.append(-1)
            self.filteredFollowingList.append(-1)
        }
        
        
        
        searchUIView.layer.cornerRadius = 23 * self.view.frame.width / 375    //  둥근정도
        searchUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        searchUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        searchUIView.layer.shadowOpacity = 0.16                            //  그림자 투명도
        searchUIView.layer.shadowOffset = CGSize(width: 0 , height: 2 )    //  그림자 x y
        searchUIView.layer.shadowRadius = 5                                //  그림자 블러
        
        //  작은창에서 설정 2개있음
        searchTextField.returnKeyType = UIReturnKeyType.search
        
        memberCollectionView.alwaysBounceVertical = true
    }
    
    func setTarget() {
        
        //  뒤로가기 버튼
        searchMemberBackBtn.addTarget(self, action: #selector(self.pressedSearchMemberBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  검색창 텍스트필드
        searchTextField.addTarget(self, action: #selector(findMember), for: .editingChanged)
        
        //  검색창 텍스트 지우기
        searchEndBtn.addTarget(self, action: #selector(self.pressedSearchEndBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setDelegate() {
        
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        
        searchTextField.delegate = self
    }

    //  뒤로가기 버튼 액션
    @objc func pressedSearchMemberBackBtn( _ sender : UIButton ) {
        
        UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseIn , animations: {
            
            self.view.frame.origin.x = self.view.frame.width
            
        }) { ( finished ) in
            
            if( finished ) {
                
                guard let rankingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RankingViewController") as? RankingViewController else { return }
                
                rankingVC.memberInfo = self.memberInfo
                
                self.present( rankingVC , animated: false , completion: nil )
                
                self.view.removeFromSuperview()
            }
        }
    }
    
    //  textfield 바뀔때마다 검색
    @objc func findMember() {
        
        if( searchTextField.text == nil || searchTextField.text == "" ) {
            
            self.searchEndBtn.isEnabled = false
            
            isFiltering = false
            view.endEditing(true)
            
            getMemberList()
            
        } else {
            
            self.searchEndBtn.isEnabled = true
            
            isFiltering = true
            
            filteredMemberList = memberList.filter({ (memberList) -> Bool in
                
                return (memberList.member_nickname?.localizedCaseInsensitiveContains( self.searchTextField.text! ))!
            })
            
            getSearchFollowingList()
        }
    }
    
    //  검색창 검색 글 지우기
    @objc func pressedSearchEndBtn( _ sender : UIButton ) {
        
        self.searchEndBtn.isEnabled = false
        
        searchTextField.text = nil
        
        isFiltering = false
        view.endEditing(true)
        
        getMemberList()
    }
    
    //  멤버리스트 가져오기
    func getMemberList() {
        
        Server.reqMemberList { ( memberListData , rescode ) in
            
            if( rescode == 200 ) {
                
                self.flag = false
                self.memberList = memberListData
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
    
    //  팔로잉 하는지 가져오기
    func getFollowingList() {
        
        //  초기화
        for i in 0 ..< 10000 {
            self.isFollowingList[i] = 0
        }
        
        for i in 0 ..< self.memberList.count {
            
            Server.reqIsFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)!, member_following_nickname: self.memberList[i].member_nickname! , completion: { ( rescode ) in
                
                if( rescode == 201 ) {
                    
                    self.isFollowingList[i] = 1
                    
                } else if( rescode == 401 ) {
                    
                    self.isFollowingList[i] = 0
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
                
            })
            
            if( i == self.memberList.count - 1 ) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
                    self.flag = true
                    self.memberCollectionView.reloadData()
                })
            }
        }
        
    }
    
    //  검색결과 팔로잉 하는지 확인
    func getSearchFollowingList() {
        
        //  초기화
        for i in 0 ..< 10 {
            self.filteredFollowingList[i] = 0
        }
        
        for i in 0 ..< self.filteredMemberList.count {
            
            Server.reqIsFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)!, member_following_nickname: self.filteredMemberList[i].member_nickname! , completion: { ( rescode2 ) in
                
                if( rescode2 == 201 ) {
                    
                    self.filteredFollowingList[i] = 1

                } else if( rescode2 == 401 ) {
                    
                    self.filteredFollowingList[i] = 0

                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
                
            })
            
            if( i == self.filteredMemberList.count - 1 ) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
                    
                    self.flag = true
                    self.memberCollectionView.reloadData()
                })
            }
        }
    }
    
    //  팔로잉 버튼 클릭
    @objc func heartTap( _ sender : UIButton ) {
        
        if( isFiltering ) {
            
            
            Server.reqFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)!, member_following_nickname: self.filteredMemberList[ sender.tag ].member_nickname!) { (rescode , flag ) in
                
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
            
            
        } else {
            
            
            Server.reqFollowing(member_follow_nickname: (self.memberInfo?.member_nickname)!, member_following_nickname: self.memberList[ sender.tag ].member_nickname!) { (rescode , flag ) in
                
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
    }
    
    
    
    
//  Mark -> delegate
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if( isFiltering ) {
            return filteredMemberList.count
        }else {
            return memberList.count
        }
    }
    
    //  cell 의 내용
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath ) as! MemberCollectionViewCell
        
        if( isFiltering ) {
            
            if( self.flag == true ) {
                cell.memberisFollowingBtn.isEnabled = true
            } else {
                cell.memberisFollowingBtn.isEnabled = false
            }
            
            if( filteredFollowingList[ indexPath.row ] == 1 ) {
                
                cell.memberisFollowingBtn.setImage(#imageLiteral(resourceName: "heart") , for: .normal )
            } else {
                
                cell.memberisFollowingBtn.setImage(#imageLiteral(resourceName: "heartEmpty") , for: .normal )
            }

            if( filteredMemberList[ indexPath.row ].member_profile != nil ) {
                
                cell.memberImageView.kf.setImage(with: URL( string:gsno( filteredMemberList[ indexPath.row ].member_profile)) )
                cell.memberImageView.layer.cornerRadius = ( cell.memberImageView.layer.frame.width/2 ) * self.view.frame.width / 375
                cell.memberImageView.clipsToBounds = true
                
            } else {
                
                cell.memberImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
            
            cell.memberNicknameLabel.text = self.filteredMemberList[ indexPath.row ].member_nickname
            
            if( memberList[ indexPath.row ].member_category != "" ) {
                cell.memberCategoryLabel.text = "# \(gsno(memberList[ indexPath.row ].member_category))"
            } else {
                cell.memberCategoryLabel.text = "# 관람객"
            }
            
            //  cell 안의 버튼 설정
            cell.memberisFollowingBtn.tag = indexPath.row
            cell.memberisFollowingBtn.addTarget(self , action: #selector(self.heartTap(_:)) , for: UIControlEvents.touchUpInside )
            
        } else {
            
            if( self.flag == true ) {
                cell.memberisFollowingBtn.isEnabled = true
            } else {
                cell.memberisFollowingBtn.isEnabled = false
            }
            
            if( isFollowingList[ indexPath.row ] == 1 ) {
                
                cell.memberisFollowingBtn.setImage(#imageLiteral(resourceName: "heart") , for: .normal )
            } else {
                
                cell.memberisFollowingBtn.setImage(#imageLiteral(resourceName: "heartEmpty") , for: .normal )
            }
            
            if( memberList[ indexPath.row ].member_profile != nil ) {
                
                cell.memberImageView.kf.setImage(with: URL( string:gsno( memberList[ indexPath.row ].member_profile)) )
                cell.memberImageView.layer.cornerRadius = ( cell.memberImageView.layer.frame.width/2 ) * self.view.frame.width / 375
                cell.memberImageView.clipsToBounds = true
                
            } else {
                
                cell.memberImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
            
            cell.memberNicknameLabel.text = self.memberList[ indexPath.row ].member_nickname
            
            if( memberList[ indexPath.row ].member_category != "" ) {
                cell.memberCategoryLabel.text = "# \(gsno(memberList[ indexPath.row ].member_category))"
            } else {
                cell.memberCategoryLabel.text = "# 관람객"
            }
            
            //  cell 안의 버튼 설정
            cell.memberisFollowingBtn.tag = indexPath.row
            cell.memberisFollowingBtn.addTarget(self , action: #selector(self.heartTap(_:)) , for: UIControlEvents.touchUpInside )
        }
        
        return cell
    }
    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.memberInfo = self.memberInfo
        
        if( self.isFiltering == true ) {
            memberInfoVC.selectMemberNickname = filteredMemberList[ indexPath.row ].member_nickname
        } else {
            memberInfoVC.selectMemberNickname = memberList[ indexPath.row ].member_nickname
        }
        
        self.present( memberInfoVC , animated: true , completion: nil )
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 375 * self.view.frame.width/375 , height: 40 * self.view.frame.height/667 )
    }
    
    //  cell 간 세로 간격 ( vertical 이라서 세로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
//  Mark -> UITextField Delegate
    //  키보드 확인 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    
    
    
    
    
}
