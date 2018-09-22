//
//  BuskingZoneMapViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 1..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit
import Kingfisher

class BuskingZoneMapViewController: UIViewController , NMapViewDelegate , NMapPOIdataOverlayDelegate , NMapLocationManagerDelegate  {

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
    
    //  넘어온 정보
    var buskingZoneList : [ BuskingZone ] = [ BuskingZone ]()  //  서버 버스킹 존 데이터

    
    var memberShowZoneName : String?    //  멤버가 현재 보고 있는 존 name
    var memberShowZoneLongitude : Double?   //  멤버가 현재 보고 있는 존 경도 x
    var memberShowZoneLatitude : Double?    //  멤버가 현재 보고 있는 존 위도 y
    
    
    //  네비게이션 바
    @IBOutlet weak var navigationBarUIView: UIView!
    @IBOutlet weak var mapDetailBackBtn: UIButton!
    @IBOutlet weak var navigationBarZoneName: UILabel!
    
    //  내용
    @IBOutlet weak var zoneCurrentInfoUIView: UIView!
    @IBOutlet weak var zoneCurrentInfoImageView: UIImageView!
    @IBOutlet weak var zoneCurrentInfoNameLebel: UILabel!
    @IBOutlet weak var zoneCurrentInfoAddressTextField: UITextView!
    @IBOutlet weak var zoneCurrentInfoCommitBtn: UIButton!
    var selectZoneIndex : Int?  //  선택한 존 index
    var selectZoneImage : String?   //  선택한 존 image
    var selectZoneName : String?    //  선택한 존 name
    
    
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
    
    //  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ마커ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    @IBOutlet var calloutView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naverMapSetting()
        set()
        setTarget()
    }
    
    func naverMapSetting() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        //  네이버지도 생성
        navermapView = NMapView(frame: self.view.frame )
        
        if let mapView = navermapView {
            
            //  delegate 설정
            mapView.delegate = self
            
            //  네이버 앱 키 설정
            mapView.setClientId("BE4DT6u49CwTPGjPqqik")
            
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(mapView)
        }
        
        // 현재위치 표시 버튼 생성
        currentLocationBtn = createLoactionBtn()
        if let button = currentLocationBtn {
            self.view.addSubview(button)
        }
        
        self.view.addSubview(navigationBarUIView)
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigationBarZoneName.text = self.selectedBoroughName
        
        zoneCurrentInfoUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        zoneCurrentInfoUIView.layer.shadowOpacity = 0.39                            //  그림자 투명도
        zoneCurrentInfoUIView.layer.shadowOffset = CGSize(width: 0 , height: 0 )    //  그림자 x y
    }
    
    func setTarget() {
        
        //  디테일 존 지도 백 버튼
        mapDetailBackBtn.addTarget(self, action: #selector(self.pressedMapDetailBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  디테일 존 지도 선택 버튼
        zoneCurrentInfoCommitBtn.addTarget(self, action: #selector(self.pressedZoneCurrentInfoCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func pressedMapDetailBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pressedZoneCurrentInfoCommitBtn( _ sender : UIButton ) {
        
        guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
        
        reservationVC.memberInfo = self.memberInfo
        reservationVC.uiviewX = self.uiviewX
        reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
        reservationVC.selectedBoroughName = self.selectedBoroughName
        reservationVC.selectedBoroughLongitude = self.selectedBoroughLongitude
        reservationVC.selectedBoroughLatitude = self.selectedBoroughLatitude
        reservationVC.selectedZoneIndex = self.selectZoneIndex
        reservationVC.selectedZoneName = self.selectZoneName
        reservationVC.selectedZoneImage = self.selectZoneImage
        
        
        self.present( reservationVC , animated: false , completion: nil )
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
        
        showMarkers()   //  maker 보이게 설정
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
    
    func createLoactionBtn() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 303 * self.view.frame.width / 375 , y: 84 * self.view.frame.height / 667 , width: 65 * self.view.frame.width / 375 , height: 65 * self.view.frame.height / 667 )
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
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "mylocationDeActiveBtn"), for: .normal)
        case .tracking:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "mylocationActiveBtn"), for: .normal)
        case .trackingWithHeading:
            currentLocationBtn?.setImage(#imageLiteral(resourceName: "mylocationWayActiveBtn"), for: .normal)
        }
    }
    
    // MARK : Marker
    
    func showMarkers() {
        
        if let mapOverlayManager = navermapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
//                poiDataOverlay.initPOIdata(1)
//
//                let tmpX = self.memberShowZoneLongitude
//                let tmpY = self.memberShowZoneLatitude
//                let tmpName = self.memberShowZoneName
//
//                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: tmpX! , latitude: tmpY! ) , title: tmpName , type: UserPOIflagTypeDefault, iconIndex: 0 , with: nil)
//
//                poiDataOverlay.endPOIdata()
//
//                // show all POI data
//                poiDataOverlay.showAllPOIdata()
                
                poiDataOverlay.initPOIdata( Int32(self.buskingZoneList.count) )

                for i in 0 ..< self.buskingZoneList.count {
                    
                    let tmpX = self.buskingZoneList[i].sbz_longitude
                    let tmpY = self.buskingZoneList[i].sbz_latitude
                    let name = self.buskingZoneList[i].sbz_name
                    
                    poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: tmpX!, latitude: tmpY! ), title: name! , type: UserPOIflagTypeDefault, iconIndex: Int32(i) , with: nil)
                }
                
                poiDataOverlay.endPOIdata()
                
                // show all POI data
                poiDataOverlay.showAllPOIdata()
                
            }
            
            //  지도 중심위치 선택한 자치구 위치로 설정
            if let mapView = self.navermapView {
                mapView.setMapCenter(NGeoPoint(longitude: self.selectedBoroughLongitude! , latitude: self.selectedBoroughLatitude! ), atLevel: 10)
            }
        }
    }
    
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
            //mapView.setMapCenter(NGeoPoint(longitude: self.buskingZoneList[0].sbz_longitude! , latitude: self.buskingZoneList[0].sbz_latitude! ), atLevel:12)
//            mapView.setMapCenter(NGeoPoint(longitude: 126.936961 , latitude: 37.557207 ), atLevel:12)
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
        
        return true
    }
    
    
    //    //  마커 선택시 나타나는 뷰 설정
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {

        //  pinActive 뷰 설정
        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1.8
        calloutPosition.pointee.y = calloutView.bounds.size.height

        self.zoneCurrentInfoUIView.isHidden = false
        
        var index : Int = 0
        index = Int(poiItem.iconIndex )
        
        selectZoneIndex = self.buskingZoneList[ index ].sbz_id
        selectZoneImage = self.buskingZoneList[ index ].sbz_photo
        selectZoneName = self.buskingZoneList[ index ].sbz_name
        
        zoneCurrentInfoNameLebel.text = buskingZoneList[ index ].sbz_name
        zoneCurrentInfoImageView.kf.setImage(with: URL( string:gsno( buskingZoneList[ index ].sbz_photo ) ) )
        zoneCurrentInfoImageView.layer.cornerRadius = zoneCurrentInfoImageView.layer.frame.width/2
        zoneCurrentInfoImageView.clipsToBounds = true
        
        zoneCurrentInfoAddressTextField.text = buskingZoneList[ index ].sbz_address
        
        //  지도 중심위치 선택한 존 위치로 설정
        if let mapView = self.navermapView {

            mapView.animate(to: NGeoPoint(longitude: buskingZoneList[ index ].sbz_longitude! , latitude: buskingZoneList[ index ].sbz_latitude! ))
        }
        
        self.view.addSubview(zoneCurrentInfoUIView)
        
        return calloutView
    }
//
//    // 마커 선택??????????????????????
//    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, didSelectCalloutOfPOIitemAt index: Int32, with object: Any!) -> Bool {
//
//        //        let buskingDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuskingDetailViewController") as? BuskingDetailViewController
//        //
//        //        buskingDetailVC?.tempText = String(index)
//        //
//        //        self.present( buskingDetailVC! , animated: true , completion: nil )
//        //
//        return true
//    }
    
    
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
