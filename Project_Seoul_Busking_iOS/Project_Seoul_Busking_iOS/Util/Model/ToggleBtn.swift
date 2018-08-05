//
//  ToggleBtn.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation
import UIKit

class ToggleBtn : UIButton {
    
    var otherBtn : ToggleBtn?
    var checked : Bool?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settingTarget()
        setting()
    }
    
    func settingTarget() {
        
        self.addTarget(self, action: #selector( ToggleBtn.touchBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setting() {
        
        self.checked = false
    }
    
    //  클릭시 일어나는것 여기서 정의
    @objc func touchBtn( _ sender : ToggleBtn ) {
        
        if( sender.tag == 0 ) {     // 버스커

            sender.setImage(  #imageLiteral(resourceName: "2_3_2") , for: .normal )
            sender.otherBtn?.setImage( #imageLiteral(resourceName: "2_4_1") , for: .normal )
        } else {
            
            sender.setImage( #imageLiteral(resourceName: "2_4_2") , for: .normal )
            sender.otherBtn?.setImage( #imageLiteral(resourceName: "2_3_1")  , for: .normal )
        }
        
        sender.checked = true
        sender.otherBtn?.checked = false
    }
}
