//
//  NextSegue.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 21..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class NextSegue: UIStoryboardSegue {

    override func perform() {
        
        next()
    }
    
    func next() {
        
        let fromViewController = self.source
        let toViewController = self.destination
        
        let containerView = fromViewController.view.superview
        
        toViewController.view.frame = CGRect(x: 375 , y: 0 , width: 375, height: 667)
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            toViewController.view.frame.origin.x = 0
            
        }) { (success) in
            fromViewController.present(toViewController , animated: false , completion: nil)
        }
        
    }
}

class UnwindNextSegue: UIStoryboardSegue {
    
    override func perform() {
        
        next()
    }
    
    func next() {
        
        let fromViewController = self.source
        let toViewController = self.destination
 
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            fromViewController.view.frame.origin.x = 375
            
        }) { (success) in
            fromViewController.dismiss( animated: false , completion: nil)
        }
        
    }

}
