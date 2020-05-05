//
//  CustomCellMainMenu.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 11/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import UIKit

class CustomCellMainMenu: UICollectionViewCell {
    
    @IBOutlet weak var LabelCountry: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var ButtonSup: UIButton!
    @IBOutlet weak var ContraintleftBtn: NSLayoutConstraint!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            print("Swipe Right")
            hiddenButton()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            print("Swipe Left")
            Showbutton()
            
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            print("Swipe Up")

        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            print("Swipe Down")

        }
    }
    
    func Showbutton(){
        ContraintleftBtn.constant = 0
    }
    
    func hiddenButton(){
        ContraintleftBtn.constant = -100
    }
    
    
    @IBAction func BtnSupAction(_ sender: Any) {
        print("suppresion")
    }
    
    

}
