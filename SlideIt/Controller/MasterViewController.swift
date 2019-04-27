//
//  ViewController.swift
//  SlideIt
//
//  Created by Neftali Samarey on 4/27/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    enum SliderState {
        case Expanded
        case Collapsed
    }
    
    // Child porperty reference of the card view that will be loaded
    var cardController : CardViewController!
    var visualEffectsView: UIVisualEffectView!
    
    // Constants for card height
    let cardHeight : CGFloat = 345
    let cardHandleAreaHeight:CGFloat = 86
    
    // Card Control Boolean
    var cardIsVisible = false
    
    // Property Observer
    var nextState : SliderState {
        return cardIsVisible ? .Expanded : .Collapsed
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    
    var animatorProgressWhenInterrupted:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // CALLING THE METHOD FROM THE EXTENSION TO INITIATE THE CARD HERE
        addSliderToParentView()
    }


}

