//
//  MapViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 15..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit
import Kingfisher

//  NMapViewDelegate                네이버 앱 키 등록
//  NMapPOIdataOverlayDelegate      네이버 지도 설정
//  NMapLocationManagerDelegate     네이버 현재위치 이용

class MapViewController: UIViewController , NMapViewDelegate , NMapPOIdataOverlayDelegate , NMapLocationManagerDelegate {

    //  넘어온 정보
    var memberInfo : Member?
    var findBuskingZoneIndex : Int = -1
    var findBuskingZoneLongitude : Double?
    var findBuskingZoneLatitude : Double?
    var tmpFindIndex : Int = -1
    
    //  서버 데이터
    var memberRepresentativeBorough : MemberRepresentativeBorough?  //  회원 대표 자치구 index & name
    
    
    //  네비게이션 바
    @IBOutlet weak var navigationBarUIView: UIView!
    @IBOutlet weak var mapBackBtn: UIButton!
    
    
    //  내용( 자치구 )
    @IBOutlet weak var mapRepresentativeBoroughLabel: UILabel!
    var mapSelectedBoroughIndex : Int?                           //  현재 선택된 자치구 index        select 해야 값 있다
    var mapSelectedBoroughName : String?                         //  현재 선택된 자치구 name
    var mapSelectedLongitude : Double?                           //  현재 선택된 logitude
    var mapSelectedLatitude : Double?                            //  현재 선택된 latitude
    
    //  내용( 서버 존 )
    var buskingZoneListAll : [ BuskingZoneAll ] = [ BuskingZoneAll ]()  //  서버 버스킹 존 전부 데이터
    
    //  내용( 서버 현재 예약 )
    var currentReservationListAll : [ CurrentReservationAll ] = [ CurrentReservationAll ]() //  서버 현재 예약 데이터
    
    //  내용( 버튼 )
    var mapSearchBtn : UIButton?        //  맵 검색 버튼
    var currentLocationBtn : UIButton?  //  현재위치 버튼
    var currentState: state = .disabled //  현재 state 값 설정
    
    //  내용( 존 설명 )
    @IBOutlet weak var zoneCurrentInfoUIView: UIView!
    @IBOutlet weak var zoneCurrentInfoNothingUIView: UIView!
    @IBOutlet weak var zoneCurrentInfoNothingNameLabel: UILabel!
    @IBOutlet weak var zoneCurrentInfoNameLebel: UILabel!
    @IBOutlet weak var zoneCurrentInfoTimeLabel: UILabel!
    @IBOutlet weak var zoneCurrentInfoNickname: UILabel!
    @IBOutlet weak var zoneCurrentInfoCategory: UILabel!
    @IBOutlet weak var zoneCurrentInfoProfileImageView: UIImageView!
    @IBOutlet weak var zoneCurrentInfoStar1: UIImageView!
    @IBOutlet weak var zoneCurrentInfoStar2: UIImageView!
    @IBOutlet weak var zoneCurrentInfoStar3: UIImageView!
    @IBOutlet weak var zoneCurrentInfoStar4: UIImageView!
    @IBOutlet weak var zoneCurrentInfoStar5: UIImageView!
    
    var year = calendar.component(.year, from: date)
    var month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let hour = calendar.component(.hour, from: date)
    var todayDateTime : Int?    //  선택한년월일 ex ) 2018815
    
    
    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ지도설정ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    var navermapView : NMapView?    //  네이버지도
    var isFirst : Bool? = true
    
    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ현재위치 , 헤더ㅡㅡㅡㅡㅡㅡ
    //  현재위치 눌렀는지 state 표시
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ마커ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    @IBOutlet var calloutView: UIView!  //  마커뷰
    @IBOutlet weak var calloutImageView: UIImageView!   //  마커 이미지
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hyunho")
        print( findBuskingZoneIndex )
        
        naverMapSetting()
        set()
        setTarget()
        
    }
    
    func set() {
        
        let yearString : String = String(year)
        var monthString : String = String( month )
        var dayString : String = String( day )
        
        
        if( monthString.count == 1 ) {
            monthString.insert("0", at: monthString.startIndex )
        }
        if( dayString.count == 1 ) {
            dayString.insert("0", at: dayString.startIndex )
        }
        
        let tmpDate : String = yearString + monthString + dayString
        todayDateTime = Int( tmpDate )
        
    }
    
    func setTarget() {
        
        //  홈 백 버튼
        mapBackBtn.addTarget(self, action: #selector(self.pressedMapBackBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func getItoI( _ sender : Int ) -> Int {
        
        let result = gino( sender )
        return result
        
    }
    
    func getStoS( _ sender : String ) -> String {
        
        let result = gsno( sender )
        return result
    }
    
    @objc func pressedMapBackBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        homeVC.memberInfo = self.memberInfo
        
        self.present( homeVC , animated: false , completion: nil )
    }
    
    
    func getMemberRepresentativeBoroughData() {
        
        Server.reqMemberRepresentativeBorough(member_nickname: (memberInfo?.member_nickname)!) { ( memberRepresentativeBoroughData , rescode ) in
            
            if( rescode == 201 ) {
                
                self.memberRepresentativeBorough = memberRepresentativeBoroughData
                
                if( self.mapSelectedBoroughIndex == nil ) {
                    
                    self.mapRepresentativeBoroughLabel.text = self.memberRepresentativeBorough?.sb_name
                    self.mapSelectedBoroughIndex = self.memberRepresentativeBorough?.sb_id
                    self.mapSelectedBoroughName = self.memberRepresentativeBorough?.sb_name
                    
                    self.mapSelectedLongitude = self.memberRepresentativeBorough?.sb_longitude
                    self.mapSelectedLatitude = self.memberRepresentativeBorough?.sb_latitude
                    
                } else {
                    self.mapRepresentativeBoroughLabel.text = self.mapSelectedBoroughName
                }
                
                Server.reqBuskingZoneListAll { ( buskingZoneListAllData, rescode ) in
                    
                    if rescode == 200 {
                        
                        self.buskingZoneListAll = buskingZoneListAllData
                        
                        Server.reqCurrentReservationListAll(r_date: self.todayDateTime! , r_time: 18 , completion: { ( currentReservationAllData , rescode ) in
                            
                            if( rescode == 200 ) {
                                
                                self.currentReservationListAll = currentReservationAllData
                                
                                if let mapOverlayManager = self.navermapView?.mapOverlayManager {
                                    
                                    // create POI data overlay
                                    if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                                        
                                        poiDataOverlay.initPOIdata( Int32(self.buskingZoneListAll.count) )
                                        
                                        var index : Int = -1
                                        
                                        for i in 0 ..< self.buskingZoneListAll.count {
                                            
                                            let tmpX = self.buskingZoneListAll[i].sbz_longitude
                                            let tmpY = self.buskingZoneListAll[i].sbz_latitude
                                            let name = self.buskingZoneListAll[i].sbz_name
                                            
                                            poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: tmpX!, latitude: tmpY! ), title: name! , type: UserPOIflagTypeDefault, iconIndex: Int32(i) , with: nil)
                                            
                                            if( self.mapSelectedBoroughName == self.buskingZoneListAll[i].sb_name && index == -1 ) {
                                                index = i
                                            }
                                            
                                            if( self.findBuskingZoneIndex == self.buskingZoneListAll[i].sbz_id ) {
                                                self.tmpFindIndex = i
                                            }
                                        }
                                        
                                        poiDataOverlay.endPOIdata()
                                        
                                        // show all POI data
                                        poiDataOverlay.showAllPOIdata()
                                        
                                        self.zoneCurrentInfoNameLebel.text = self.buskingZoneListAll[ index ].sbz_name
                                        self.zoneCurrentInfoNothingNameLabel.text = self.buskingZoneListAll[ index ].sbz_name
                                        
                                        if( self.buskingZoneListAll[ index ].sbz_id == self.currentReservationListAll[ index ].sbz_id ) {     //  예약 있음
                                            
                                            self.zoneCurrentInfoUIView.isHidden = false
                                            self.zoneCurrentInfoNothingUIView.isHidden = true
                                            
                                            let tmpStartTime = self.getItoI( self.currentReservationListAll[ index ].r_startTime! )
                                            let tmpEndTime = self.getItoI( self.currentReservationListAll[ index ].r_endTime! )
                                            let tmpCategory = self.getStoS( self.currentReservationListAll[ index ].r_category! )
                                            let IntScore = Int( self.currentReservationListAll[ index ].member_score! )
                                            
                                            
                                            var starArr : [ UIImageView ] = [ self.zoneCurrentInfoStar1 , self.zoneCurrentInfoStar2 , self.zoneCurrentInfoStar3 , self.zoneCurrentInfoStar4 , self.zoneCurrentInfoStar5 ]
                                            
                                            self.zoneCurrentInfoTimeLabel.text = "\(tmpStartTime) : 00 - \(tmpEndTime) : 00"
                                            
                                            self.zoneCurrentInfoNickname.text = self.currentReservationListAll[ index ].member_nickname
                                            self.zoneCurrentInfoCategory.text = "# \(tmpCategory)"
                                            
                                            for i in 0 ..< 5 {
                                                
                                                starArr[i].image = #imageLiteral(resourceName: "nonStar")
                                            }
                                            for i in 0 ..< IntScore {
                                                
                                                starArr[i].image = #imageLiteral(resourceName: "star")
                                            }
                                            
                                            
                                            if( self.currentReservationListAll[ index ].member_profile != nil ) {
                                                
                                                let tmpProfile = self.getStoS( self.currentReservationListAll[ index ].member_profile! )
                                                
                                                self.zoneCurrentInfoProfileImageView.kf.setImage(with: URL( string: tmpProfile ) )
                                                self.zoneCurrentInfoProfileImageView.layer.cornerRadius = self.zoneCurrentInfoProfileImageView.layer.frame.width/2
                                                self.zoneCurrentInfoProfileImageView.clipsToBounds = true
                                                
                                            } else {
                                                
                                                self.zoneCurrentInfoProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
                                            }
                                            
                                        } else {    //  예약 없음
                                            
                                            self.zoneCurrentInfoUIView.isHidden = true
                                            self.zoneCurrentInfoNothingUIView.isHidden = false
                                        }
                                        
                                        if( self.findBuskingZoneIndex == -1 ){
                                        
                                            //  디폴트로 선택누르고 있는거
                                            poiDataOverlay.selectPOIitem(at: Int32(index) , moveToCenter: false , focusedBySelectItem: false)
                                        } else {
                                            
                                            //  고른거
                                            poiDataOverlay.selectPOIitem(at: Int32(self.tmpFindIndex) , moveToCenter: false , focusedBySelectItem: false)
                                        }
                                        self.isFirst = false
                                    }
                                    
                                }
                                
                                if( self.findBuskingZoneIndex == -1 ) {
                                    
                                    //  지도 중심위치 선택한 자치구 위치로 설정
                                    if let mapView = self.navermapView {
                                        mapView.setMapCenter(NGeoPoint(longitude: self.mapSelectedLongitude! , latitude: self.mapSelectedLatitude! ), atLevel: 12)
                                    }
                                } else {
                                    
                                    //  지도 중심위치 선택한 존 위치로 설정
                                    if let mapView = self.navermapView {
                                        mapView.setMapCenter(NGeoPoint(longitude: self.findBuskingZoneLongitude! , latitude: self.findBuskingZoneLatitude! ), atLevel: 12)
                                    }
                                }
                                

                            } else {
                                
                                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                                alert.addAction( ok )
                                self.present(alert , animated: true , completion: nil)
                                
                            }
                        })
                        
                    } else {
                        
                        let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
                    }
                }
                
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    
// naver map ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    
    func naverMapSetting() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        //  네이버지도 생성
        navermapView = NMapView(frame: self.view.frame )
        
        if let mapView = navermapView {
            
            //  delegate 설정
            mapView.delegate = self
            
            //  네이버 앱 키 설정
            mapView.setClientId("1nj12HfHWHhoIcw1DdmR")
            
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(mapView)
        }
        
        // 현재위치 표시 버튼 생성
        currentLocationBtn = createLoactionBtn()
        if let button = currentLocationBtn {
            self.view.addSubview(button)
        }
        mapSearchBtn = createMapSearchBtn()
        if let button = mapSearchBtn {
            self.view.addSubview(button)
        }
        
        self.view.addSubview(navigationBarUIView)
        
        zoneCurrentInfoUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        zoneCurrentInfoUIView.layer.shadowOpacity = 0.39                            //  그림자 투명도
        zoneCurrentInfoUIView.layer.shadowOffset = CGSize(width: 0 , height: 0 )    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        self.view.addSubview(zoneCurrentInfoUIView)
        zoneCurrentInfoNothingUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        zoneCurrentInfoNothingUIView.layer.shadowOpacity = 0.39                            //  그림자 투명도
        zoneCurrentInfoNothingUIView.layer.shadowOffset = CGSize(width: 0 , height: 0 )    //  그림자 x y
        self.view.addSubview(zoneCurrentInfoNothingUIView)
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if view.frame.size.width != size.width {
            if let mapView = navermapView, mapView.isAutoRotateEnabled {
                mapView.setAutoRotateEnabled(false, animate: false)
                
                coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                    if let mapView = self.navermapView {
                        mapView.setAutoRotateEnabled(true, animate: false)
                    }
                }, completion: nil)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        navermapView?.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navermapView?.viewWillAppear()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navermapView?.viewDidDisappear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getMemberRepresentativeBoroughData()
        
        
        
        navermapView?.viewDidAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navermapView?.viewWillDisappear()
        
        stopLocationUpdating()  //  현재위치 err 시
    }
    
    
    //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    
    func onMapViewIsGPSTracking(_ mapView: NMapView!) -> Bool {
        return NMapLocationManager.getSharedInstance().isTrackingEnabled()
    }
    
    func findCurrentLocation() {
        enableLocationUpdate()
    }
    
    func setCompassHeadingValue(_ headingValue: Double) {
        
        if let mapView = navermapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    // MARK: - My Location
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        navermapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                navermapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        navermapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    // MARK: - Button Control
    
    func createMapSearchBtn() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 303 * self.view.frame.width / 375 , y: 84 * self.view.frame.height / 667 , width: 65 * self.view.frame.width / 375 , height: 65 * self.view.frame.height / 667 )
        button.setImage(#imageLiteral(resourceName: "mapSearch"), for: .normal)
        
        button.addTarget(self, action: #selector(mapSearchBtnClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    func createLoactionBtn() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 303 * self.view.frame.width / 375 , y: 148.5 * self.view.frame.height / 667 , width: 65 * self.view.frame.width / 375 , height: 65 * self.view.frame.height / 667 )
        button.setImage(#imageLiteral(resourceName: "mylocationDeActiveBtn"), for: .normal)
        
        button.addTarget(self, action: #selector(myLocationBtnClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func myLocationBtnClicked(_ sender: UIButton!) {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
        }
    }
    
    @objc func mapSearchBtnClicked( _ sender : UIButton! ) {
        
        guard let mapSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapSearchViewController") as? MapSearchViewController else { return }
        
        mapSearchVC.memberInfo = self.memberInfo
        
        self.present( mapSearchVC , animated: true , completion: nil )
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "mylocationDeActiveBtn") , for: .normal)
        case .tracking:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "mylocationActiveBtn") , for: .normal)
        case .trackingWithHeading:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "mylocationWayActiveBtn") , for: .normal)
        }
    }
    
    // MARK : Marker
    
    func clearOverlays() {
        if let mapOverlayManager = navermapView?.mapOverlayManager {
            mapOverlayManager.clearOverlays()
        }
    }
    
    
    //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡdelegateㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    
    //  NMapViewDelegate Methods
    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        
        if (error == nil) { // success
            //  지도의 디폴드 위치 , 레벨 단계 **레벨단계 test 해야함
            //mapView.setMapCenter(NGeoPoint(longitude: 126.981405 , latitude: 37.509803 ), atLevel:12)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // 모드설정 : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    //  NMapPOIdataOverlayDelegate Methods
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        
        return CGPoint(x: 0.5, y: 0.0)
    }
    

    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, didDeselectPOIitemAt index: Int32, with object: Any!) -> Bool {
        
        
        self.zoneCurrentInfoUIView.isHidden = true
        self.zoneCurrentInfoNothingUIView.isHidden = true
        
        return true
    }

    //    //  마커 선택시 나타나는 뷰 설정
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
        
        //  pinActive 뷰 설정
        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1.8
        calloutPosition.pointee.y = calloutView.bounds.size.height
        
        var index : Int = 0
        index = Int(poiItem.iconIndex )
        
        mapRepresentativeBoroughLabel.text = buskingZoneListAll[ index ].sb_name
        zoneCurrentInfoNameLebel.text = buskingZoneListAll[ index ].sbz_name
        zoneCurrentInfoNothingNameLabel.text = buskingZoneListAll[ index ].sbz_name
        
        if( buskingZoneListAll[ index ].sbz_id == currentReservationListAll[ index ].sbz_id ) {     //  예약 있음
            
            self.zoneCurrentInfoUIView.isHidden = false
            self.zoneCurrentInfoNothingUIView.isHidden = true
            
            zoneCurrentInfoTimeLabel.text = "\(gino(currentReservationListAll[ index ].r_startTime )) : 00 - \(gino(currentReservationListAll[ index ].r_endTime)) : 00"
            
            zoneCurrentInfoNickname.text = currentReservationListAll[ index ].member_nickname
            zoneCurrentInfoCategory.text = "# \(gsno( currentReservationListAll[ index ].r_category))"
            
            let IntScore = Int( self.currentReservationListAll[ index ].member_score! )
            var starArr : [ UIImageView ] = [ self.zoneCurrentInfoStar1 , self.zoneCurrentInfoStar2 , self.zoneCurrentInfoStar3 , self.zoneCurrentInfoStar4 , self.zoneCurrentInfoStar5 ]
            self.zoneCurrentInfoNickname.text = self.currentReservationListAll[ index ].member_nickname
            for i in 0 ..< 5 {
                starArr[i].image = #imageLiteral(resourceName: "nonStar")
            }
            for i in 0 ..< IntScore {
                starArr[i].image = #imageLiteral(resourceName: "star")
            }
            
            if( currentReservationListAll[ index ].member_profile != nil ) {
                
                zoneCurrentInfoProfileImageView.kf.setImage(with: URL( string:gsno( currentReservationListAll[ index ].member_profile)) )
                zoneCurrentInfoProfileImageView.layer.cornerRadius = zoneCurrentInfoProfileImageView.layer.frame.width/2
                zoneCurrentInfoProfileImageView.clipsToBounds = true
                
            } else {
                
                zoneCurrentInfoProfileImageView.image = #imageLiteral(resourceName: "defaultProfile.png")
            }
        } else {    //  예약 없음
            
            self.zoneCurrentInfoUIView.isHidden = true
            self.zoneCurrentInfoNothingUIView.isHidden = false
        }
        
        if( tmpFindIndex != -1 ) {
            
            print("ha")
            //  지도 중심위치 선택한 존 위치로 설정
            if let mapView = self.navermapView {
                mapView.animate(to: NGeoPoint(longitude: self.findBuskingZoneLongitude! , latitude: self.findBuskingZoneLatitude! ))
                
            }
        }
        
        if( isFirst == false ) {
            
            //  지도 중심위치 선택한 존 위치로 설정
            if let mapView = self.navermapView {
                mapView.animate(to: NGeoPoint(longitude: buskingZoneListAll[ index ].sbz_longitude! , latitude: buskingZoneListAll[ index ].sbz_latitude! ))
                
            }
        }
        
        return calloutView
    }
    
    // 마커 선택??????????????????????
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, didSelectCalloutOfPOIitemAt index: Int32, with object: Any!) -> Bool {
        
        //        let buskingDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuskingDetailViewController") as? BuskingDetailViewController
        //
        //        buskingDetailVC?.tempText = String(index)
        //
        //        self.present( buskingDetailVC! , animated: true , completion: nil )
        //
        return true
    }
    
    
    //  NMapLocationManagerDelegate Methods
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        //  현재 위치 변경 시 호출된다. location객체에 변경된 위치 정보가 전달된다.
        let coordinate = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        navermapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        navermapView?.setMapCenter(myLocation)
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        //  현재 위치 탐색 실패 시 호출된다. 실패 원인은 errorType으로 전달된다.
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = navermapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        //  나침반 각도 변경 시 호출된다. heading 객체에 각도 정보가 전달된다.
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
}
