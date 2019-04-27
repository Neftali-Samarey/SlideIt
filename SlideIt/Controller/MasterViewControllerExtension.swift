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
        
        // Pan/tap Gesture initializations
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MasterViewController.handleTapGesture(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MasterViewController.handlePanGestureRecognizer(recognizer:)))
        
        
        // Adding thie recognizers to the handling defined areas (areas that should have this recognizer only)
        cardController.SBDragingView.addGestureRecognizer(tapGestureRecognizer)
        cardController.SBDragingView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    // MARK: - TAP GESTURE METHOD
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionViewPanned(cardState: nextState, duration: 0.3)
        default:
            break
        }
    }
    
    // MARK: - PAN GESTURE RECOGNIZER
    @objc func handlePanGestureRecognizer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .possible:
            print("Handle")
        case .began:
            handleInteractivePanningTransition(cardState: nextState, duration: 0.5)
        case .changed:
            let translation = recognizer.translation(in: self.cardController.SBDragingView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardIsVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continuesInteractiveTransition()
        case .cancelled:
            print("Handle")
        case .failed:
            //
            break
        default:
            break
        }
    }
    
    // MARK: - ANIMATION OF TRANSITION METHOD
    func animateTransitionViewPanned(cardState: SliderState, duration: TimeInterval) {
        
        // Checking the array of running animation, if empty, adding animations
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                // Rest of the code
                switch cardState {
                case .Expanded:
                    self.view.bringSubviewToFront(self.cardController.view)
                    //self.view.sendSubviewToBack(self.view)
                    
                    // Slide the card view up
                    self.cardController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    
                case .Collapsed:
                    self.cardController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            // Invoke completion handler for the frameAnimator constant
            frameAnimator.addCompletion { _ in
                self.cardIsVisible = !self.cardIsVisible
                self.runningAnimations.removeAll()
                
                /* Once card slides down, animation is finished, views pushed back will return to the front.
                 so bring back the pushed back hosting view, then the card itself last
                 */
                
                if self.cardIsVisible == false {
                   // self.view.bringSubviewToFront(self.view) //  Hosting view
                    self.view.bringSubviewToFront(self.cardController.view)
                    // Enable any other non-active controllers here
                }
                
            }
            
            
            // Start animation and append to the array
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            // MARK: = Animate the corner radius as the view is sliding up, form a 90 deg corner to a rounded slope
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch cardState{
                case .Expanded:
                    self.cardController.view.layer.cornerRadius = 12
                    
                case .Collapsed:
                    self.cardController.view.layer.cornerRadius = 0
                }
            }
            
            // Add the next animation to the queue
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            // MARK: - ANIMATING THE BLURRED VIEW
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch cardState{
                case .Expanded:
                    self.visualEffectsView.effect = UIBlurEffect(style: .dark)
                case .Collapsed:
                    self.visualEffectsView.effect = nil
                }
            }
            
            // Animate the top block next on queue
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            
            // end
            
        }
    }
    
    // MARK: - INTERACTIVE METHOD (ALLOWS THE PANNING OF THE VIEW)
    func handleInteractivePanningTransition(cardState: SliderState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionViewPanned(cardState: cardState, duration: duration)
        }
        
        // When the animation is paused, the animation progress completed takes the value of animator's fraction completed
        for animationOccurring in runningAnimations {
            animationOccurring.pauseAnimation()
            animatorProgressWhenInterrupted = animationOccurring.fractionComplete
        }

    }
    
    // MARK: -
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animation in runningAnimations {
            animation.fractionComplete = fractionCompleted + animatorProgressWhenInterrupted
        }
    }
    
    func continuesInteractiveTransition() {
        for animation in runningAnimations {
            animation.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

    
    
}
