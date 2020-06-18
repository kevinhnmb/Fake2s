//
//  AboutController.swift
//  assign3
//
//  Created by Kevin Nogales on 4/3/20.
//  Copyright © 2020 Kevin Nogales. All rights reserved.
//

import Foundation
import UIKit

class AboutView: UIView {
    
    lazy var animator = UIDynamicAnimator(referenceView: self)
    lazy var metaBehavior = MetaBehavior(animator: animator)
    
    override func layoutSubviews() {
        
        
        
        
        for button in subviews as! [UIButton] {
            
            if metaBehavior.childBehaviors.count == 0 {
                button.frame = CGRect(x: self.frame.width/2, y: self.frame.height/2, width: 150, height: 100)
                metaBehavior.addItem(in: button)
            } else {
                let newFrame = CGRect(x: self.frame.width/2, y: self.frame.height/2, width: 150, height: 100)
                
                if newFrame != button.frame {
                    metaBehavior.removeItem(in: button)
                    button.frame = newFrame
                    metaBehavior.addItem(in: button)
                }
            }
        }
    }
    
    @objc func startup() {
        print("Swipe!")
        if metaBehavior.childBehaviors.count == 0 {
            metaBehavior.addItem(in: subviews[0] as! UIButton)
        }
    }
}

class AboutController: UIViewController {
    

    @IBOutlet var aboutView: AboutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let byButton = UIButton()
        let str = "by Kevin Nogales"
        let attStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        byButton.setAttributedTitle(attStr, for: UIControl.State.normal)
        
        byButton.frame = CGRect(x: aboutView.frame.width/2, y: aboutView.frame.height/2, width: 150, height: 100)
        
        aboutView.addSubview(byButton)
    }

    
}



class MetaBehavior: UIDynamicBehavior {
    lazy var collisionBehavior : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        
        behavior.translatesReferenceBoundsIntoBoundary = true
        addChildBehavior(behavior)
        
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
       let behavior = UIDynamicItemBehavior()
        
        behavior.elasticity = 1.0
        behavior.resistance = 0
        behavior.friction = 0
        
        addChildBehavior(behavior)
        
        return behavior
    }()
    
    func push(item: UIDynamicItem) {
        let pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
        pushBehavior.angle = CGFloat.pi * CGFloat.random(in: 1..<3)
        pushBehavior.magnitude = CGFloat.random(in: 1..<4)
        pushBehavior.action = { [unowned pushBehavior, weak self] in
            self?.removeChildBehavior(pushBehavior)
        }
        addChildBehavior(pushBehavior)
    }
    
    func addItem(in item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item: item)
    }
    
    func removeItem(in item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        
    }
    
    override init() {
        super.init()
        
    }
    
    convenience init(animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

}
