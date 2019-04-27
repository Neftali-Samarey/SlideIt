//
//  MasterViewControllerExtension.swift
//  SlideIt
//
//  Created by Neftali Samarey on 4/27/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//
// This class contains all the code that will handle the sliding in & sliding out of the master view controller

import Foundation
import UIKit


extension MasterViewController {
    
    // Adding the slide to the hosting view controller
    func addSliderToParentView() {
        
        visualEffectsView = UIVisualEffectView() // Starting it here (was optional in the non-extended class
        visualEffectsView.frame = self.view.frame // Its bounds are equal to that of the parent bounds
        self.view.addSubview(visualEffectsView)
        
        // Initialize the XIB file
        cardController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardController) // Adding the XIB as a child to the view
        self.view.addSubview(cardController.view) // Now adding it as a subview
        
        // Laying the card out in place in this next section
        
        cardController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        // Add Shadowing
        cardController.addShadowing()
        
        // Clips to bounds
        cardController.view.clipsToBounds = true
        
        // Pan Gesture initializations
        
    }
    
    
    
}
