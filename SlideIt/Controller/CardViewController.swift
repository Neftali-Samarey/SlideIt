//
//  CardViewController.swift
//  SlideIt
//
//  Created by Neftali Samarey on 4/27/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    // UI Components (programmatic)
    let mainTitle : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "avenir", size: 26.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // UI - Storyboard
    
    @IBOutlet weak var SBTitle: UILabel!
    @IBOutlet weak var SBDragingView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainTitle)
        // Do any additional setup after loading the view.
        initializeUIConponents()
    }
    
    // MARK: - UI COMPONENTS
    fileprivate func initializeUIConponents() {
        
        SBDragingView.backgroundColor = UIColor.white
        
        SBTitle.text = "SLIDE UP"
        SBTitle.textColor = UIColor.darkGray
    }


}

extension CardViewController {
    func addShadowing() {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        view.layer.shadowRadius = 8
    }
}
