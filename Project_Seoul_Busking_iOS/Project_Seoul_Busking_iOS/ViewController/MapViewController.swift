//
//  MapViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 15..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

//  NMapViewDelegate                네이버 앱 키 등록
//  NMapPOIdataOverlayDelegate      네이버 지도 설정
//  NMapLocationManagerDelegate     네이버 현재위치 이용

class MapViewController: UIViewController , NMapViewDelegate , NMapPOIdataOverlayDelegate , NMapLocationManagerDelegate {

    //  넘어온 정보
    var memberInfo : Member?
    var memberRepresentativeBorough : MemberRepresentativeBorough?  //  회원 대표 자치구 index & name
    var todayDateTime : Int?    //  선택한년월일 ex ) 2018815
    
    
    //  네비게이션 바
    @IBOutlet weak var navigationBarUIView: UIView!
    @IBOutlet weak var mapBackBtn: UIButton!
    
    
    //  내용( 자치구 )
    @IBOutlet weak var mapRepresentativeBoroughLabel: UILabel!
    var mapSelectBoroughIndex : Int?                           //  현재 선택된 자치구 index        select 해야 값 있다
    var mapSelectBoroughName : String?                        //   현재 선택된 자치구 name
    
    //  내용( 존 )
    var buskingZoneList : [ BuskingZone ] = [ BuskingZone ]()  //  서버 버스킹 존 데이터
    
    
    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ지도설정ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    var navermapView : NMapView?    //  네이버지도
    
    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ현재위치 , 헤더ㅡㅡㅡㅡㅡㅡ
    //  현재위치 눌렀는지 state 표시
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    var currentLocationBtn : UIButton?  //  현재위치 버튼
    var currentState: state = .disabled //  현재 state 값 설정
    
//    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ마커ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
//    @IBOutlet var calloutView: UIView!  //  마커뷰
//    var calloutIndex : String?  //  callout index 번호 저장해서 다음뷰에 넘길때 알수있도록 한다.
//    @IBOutlet weak var calloutImageView: UIImageView!   //  마커 이미지
//    @IBOutlet weak var calloutTitleLabel: UILabel!  //  마커 제목
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naverMapSetting()
        setTarget()
        
    }
    
    func setTarget() {
        
        //  홈 백 버튼
        mapBackBtn.addTarget(self, action: #selector(self.pressedMapBackBtn(_:)), for: UIControlEvents.touchUpInside)
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
                
                var tmp : Int?
                if( self.mapSelectBoroughIndex == nil ) {
                    
                    tmp = self.memberRepresentativeBorough?.sb_id
                    
                    self.mapRepresentativeBoroughLabel.text = self.memberRepresentativeBorough?.sb_name
                    self.mapSelectBoroughIndex = self.memberRepresentativeBorough?.sb_id
                    self.mapSelectBoroughName = self.memberRepresentativeBorough?.sb_name
                    
                } else {
                    
                    tmp = self.mapSelectBoroughIndex
                    
                    self.mapRepresentativeBoroughLabel.text = self.mapSelectBoroughName
                    
                }
                
                Server.reqBuskingZoneList(sb_id: ( tmp )! ) { ( buskingZoneListData , rescode ) in
                    
                    if rescode == 200 {
                        
                        self.buskingZoneList = buskingZoneListData
                        
                        if( self.buskingZoneList.count != 0 ) {
                            //self.nothingZone.isHidden = true
                            
                            if let mapOverlayManager = self.navermapView?.mapOverlayManager {
                                
                                // create POI data overlay
                                if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                                    
                                    poiDataOverlay.initPOIdata( Int32(self.buskingZoneList.count) )
                                    
                                    for i in 0 ..< self.buskingZoneList.count {
                                        
                                        let index = self.buskingZoneList[i].sbz_id
                                        let tmpX = self.buskingZoneList[i].sbz_longitude
                                        let tmpY = self.buskingZoneList[i].sbz_latitude
                                        let name = self.buskingZoneList[i].sbz_name
                                        
                                        poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: tmpX!, latitude: tmpY! ), title: name! , type: UserPOIflagTypeDefault, iconIndex: Int32(index!) , with: nil)
                                    }
                                    
                                    poiDataOverlay.endPOIdata()
                                    
                                    // show all POI data
                                    poiDataOverlay.showAllPOIdata()
                                    
                                    //  디폴트로 선택누르고 있는거
                                    //poiDataOverlay.selectPOIitem(at: 2, moveToCenter: false, focusedBySelectItem: true)
                                }
                            }
                        } else {
                           // self.nothingZone.isHidden = false
                        }
                        
                        
                        //  지도 중심위치 대표자치구로 설정
                        if let mapView = self.navermapView {
                            
                            mapView.setMapCenter(NGeoPoint(longitude: (self.memberRepresentativeBorough?.sb_longitude)! , latitude: (self.memberRepresentativeBorough?.sb_latitude)! ), atLevel:12)
                        }
                    
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
        currentLocationBtn = createButton()
        
        if let button = currentLocationBtn {
            self.view.addSubview(button)
        }
        
        self.view.addSubview(navigationBarUIView)
        
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
        
        navermapView?.viewDidAppear()
        getMemberRepresentativeBoroughData()
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
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 15, y: 30, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
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
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
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
            //mapView.setMapCenter(NGeoPoint(longitude: 126.924017 , latitude: 37.555752 ), atLevel:12)
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
    
    
//    //    //  마커 선택시 나타나는 뷰 설정
//    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
//
//        //  뷰 설정
//        calloutIndex = String(poiItem.iconIndex)        //  index 설정해서 다음뷰에 넘길때 알려준다
//        calloutTitleLabel.text = poiItem.title
//        calloutImageView.image = #imageLiteral(resourceName: "2_1.png")
//
//        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1
//
//        return calloutView
//    }
    
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
