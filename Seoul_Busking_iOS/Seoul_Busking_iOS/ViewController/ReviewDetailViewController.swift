//
//  ReviewDetailViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 15..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //  유저 정보
    var memberInfo : Member?
    var selectMemberNickname : String?      //  선택한 타인 닉네임
    
    //  네비게이션 바
    @IBOutlet weak var navigationBackBtn: UIButton!
    
    //  후기 작성 버튼
    @IBOutlet weak var reviewCreateBtn: UIButton!
    @IBOutlet weak var reviewCreateImageBtn: UIButton!
    
    //  별점
    @IBOutlet weak var starScore: UILabel!
    @IBOutlet weak var starTotalCntLabel: UILabel!
    @IBOutlet weak var starPercentileBackUIView5: UIView!
    @IBOutlet weak var starPercentileUIView5: UIView!
    @IBOutlet weak var starPercentileBackUIView4: UIView!
    @IBOutlet weak var starPercentileUIView4: UIView!
    @IBOutlet weak var starPercentileBackUIView3: UIView!
    @IBOutlet weak var starPercentileUIView3: UIView!
    @IBOutlet weak var starPercentileBackUIView2: UIView!
    @IBOutlet weak var starPercentileUIView2: UIView!
    @IBOutlet weak var starPercentileBackUIView1: UIView!
    @IBOutlet weak var starPercentileUIView1: UIView!
    
    //  내용
    var memberReviewList : [ MemberReview ] = [ MemberReview ]()  //  멤버 리뷰 서버
    var memberScore : Double = 0
    var reviewTotalCnt : Int = 0    //  리뷰 전체 개수
    var reviewScoreCnt : [ Int ] = [ Int ]()    //  리뷰 각각 점수 개수
    @IBOutlet weak var reviewDetailCollectionView: UICollectionView!
    var refresher : UIRefreshControl?
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    var uiviewX : CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setDelegate()
        setTarget()
        reloadTarget()
        setTapbarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getReviewList()
    }
    
    func getReviewList() {
        
        Server.reqMemberReviewList(review_toNickname: self.selectMemberNickname!) { ( memberReviewData , score  , totalCnt , scoreCnt , rescode ) in
            
            if( rescode == 200 ) {
                
                self.memberReviewList = memberReviewData
                self.memberScore = score
                self.reviewTotalCnt = totalCnt
                self.reviewScoreCnt = scoreCnt
                
                self.reviewDetailCollectionView.reloadData()
                
                if( self.memberReviewList.count == 0 ) {
                    
                    //  없음 표시
                }
                
                self.starScore.text = String( self.memberScore )
                self.starTotalCntLabel.text = "총 \(self.reviewTotalCnt)개"
                
                let starPercentileUIViewArr = [ self.starPercentileUIView5 , self.starPercentileUIView4 , self.starPercentileUIView3 , self.starPercentileUIView2 , self.starPercentileUIView1 ]
                
                let width = Double(self.starPercentileBackUIView1.frame.width)
                
                for i in 0 ..< 5 {
                    starPercentileUIViewArr[i]?.frame.size.width = CGFloat(( ( Double(self.reviewScoreCnt[i]) / Double(self.reviewTotalCnt) ) * width))
                }
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
        
    }
    
    func reloadTarget() {
        
        refresher = UIRefreshControl()
        refresher?.tintColor = #colorLiteral(red: 0.4470588235, green: 0.3137254902, blue: 0.8941176471, alpha: 1)
        refresher?.addTarget( self , action : #selector( reloadData ) , for : .valueChanged )
        reviewDetailCollectionView.alwaysBounceVertical = true
        reviewDetailCollectionView.addSubview( refresher! )
    }
    
    @objc func reloadData() {
        
        self.getReviewList()
        stopRefresher()
    }
    
    func stopRefresher() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            self.refresher?.endRefreshing()
        })
    }
    
    func set() {
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        let starPercentileBackUIViewArr = [ starPercentileBackUIView5 , starPercentileBackUIView4 , starPercentileBackUIView3 , starPercentileBackUIView2 , starPercentileBackUIView1 ]
        
        let starPercentileUIView = [ starPercentileUIView5 , starPercentileUIView4 , starPercentileUIView3 , starPercentileUIView2 , starPercentileUIView1 ]
        
        for i in 0 ..< 5 {
            starPercentileBackUIViewArr[i]?.layer.cornerRadius = 1    //  둥근정도
            starPercentileBackUIViewArr[i]?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ]
            starPercentileUIView[i]?.layer.cornerRadius = 1    //  둥근정도
            starPercentileUIView[i]?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ]
            
        }
        
        //  초기화
        for _ in 0 ..< 5 {
            self.reviewScoreCnt.append(0)
        }
    }
    
    func setDelegate() {
        
        reviewDetailCollectionView.delegate = self
        reviewDetailCollectionView.dataSource = self
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  뒤로가기 버튼
        navigationBackBtn.addTarget(self, action: #selector(self.pressedNavigationBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  후기 작성 버튼
        reviewCreateBtn.addTarget(self, action: #selector(self.pressedReviewCreateBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  후기 작성 이미지 버튼
        reviewCreateImageBtn.addTarget(self, action: #selector(self.pressedReviewCreateBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func setTapbarAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            
            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.tapbarUIView.frame.origin.x = self.tapbarMemberInfoBtn.frame.origin.x
                
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
    @objc func pressedNavigationBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true , completion: nil )
    }
    
    //  후기 작성 버튼 액션
    @objc func pressedReviewCreateBtn( _ sender : UIButton ) {
        
        guard let reviewCreateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewCreateViewController") as? ReviewCreateViewController else { return }
        
        reviewCreateVC.memberInfo = self.memberInfo
        reviewCreateVC.selectMemberNickname = self.selectMemberNickname
        
        self.present( reviewCreateVC , animated: true , completion: nil )
    }

//  Mark -> delegate
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memberReviewList.count
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewDetailCollectionViewCell", for: indexPath ) as! ReviewDetailCollectionViewCell
        
        let borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        let borderOpacity : CGFloat = 0.3
        cell.reviewDetailUIView.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
        cell.reviewDetailUIView.layer.borderWidth = 2
        cell.reviewDetailUIView.layer.cornerRadius = 6
        cell.reviewDetailUIView.layer.shadowColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        cell.reviewDetailUIView.layer.shadowOpacity = 0.5
        cell.reviewDetailUIView.layer.shadowOffset = CGSize( width: 0 , height: 2 )
        cell.reviewDetailUIView.layer.shadowRadius = 5
        
        
        cell.reviewDetailTitleLabel.text = memberReviewList[ indexPath.row ].review_title
        cell.reviewDetailDateLabel.text = memberReviewList[ indexPath.row ].review_uploadtime

        let starArr = [ cell.reviewDetailStar1 , cell.reviewDetailStar2 , cell.reviewDetailStar3 , cell.reviewDetailStar4 , cell.reviewDetailStar5 ]
        let starCnt = memberReviewList[ indexPath.row ].review_score

        for i in 0 ..< 5 {
            starArr[i]?.image = #imageLiteral(resourceName: "nonStar")
        }
        for i in 0 ..< starCnt! {
            starArr[i]?.image = #imageLiteral(resourceName: "star")
        }

        cell.reviewDetailNicknameLabel.text = memberReviewList[ indexPath.row ].review_fromNickname

        if( memberReviewList[ indexPath.row ].member_profile != nil ) {

            cell.reviewDetailProfileImageView.kf.setImage( with: URL( string:gsno(memberReviewList[ indexPath.row ].member_profile ) ) )
            cell.reviewDetailProfileImageView.layer.cornerRadius = cell.reviewDetailProfileImageView.layer.frame.width/2
            cell.reviewDetailProfileImageView.clipsToBounds = true

        } else {

            cell.reviewDetailProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
        }

        cell.reviewDetailTextView.text = memberReviewList[ indexPath.row ].review_content

        return cell
    }

    
    //  cell 선택 했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 375 * self.view.frame.width/375 , height: 216 * self.view.frame.height/667 )
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

}




















